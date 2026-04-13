import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/gratitude_entry.dart';
import '../utils/time_utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

//Single gratitude record card: Text + Timestamp + (Optional) Voice Playback
class GratitudeTile extends StatefulWidget {
  final GratitudeEntry entry;
  final VoidCallback onDeleted;
  const GratitudeTile({
    super.key,
    required this.entry,
    required this.onDeleted,
  });

  @override
  State<GratitudeTile> createState() => _GratitudeTileState();
}

class _GratitudeTileState extends State<GratitudeTile> {
  // Shared player: Ensures that only one item is played at a time.
  static final AudioPlayer _player = AudioPlayer();
  static String? _currentSrc; // The currently playing resource (asset path)

  late final StreamSubscription<Duration> _posSub;
  late final StreamSubscription<Duration> _durSub;
  late final StreamSubscription<PlayerState> _stateSub;

  Duration _pos = Duration.zero;
  Duration _dur = Duration.zero;
  bool _playingMine = false; // test  this currently playing or not
  //bool _isUrl(String s) => s.startsWith('http://') || s.startsWith('https://');

  @override
  void initState() {
    super.initState();
    _posSub = _player.onPositionChanged.listen((p) {
      if (!_isMine) return;
      setState(() => _pos = p);
    });
    _durSub = _player.onDurationChanged.listen((d) {
      if (!_isMine) return;
      setState(() => _dur = d);
    });
    _stateSub = _player.onPlayerStateChanged.listen((s) {
      final wasMine =
          _playingMine || _isMine; //Only update when it concerns oneself

      if (!wasMine) return;

      setState(() {
        _playingMine = _isMine && s == PlayerState.playing;

        if (s == PlayerState.completed ||
            s == PlayerState.stopped ||
            s == PlayerState.paused) {
          _pos = Duration.zero;
          _dur = Duration.zero;

          if (s == PlayerState.completed && _isMine) {
            //complete and was mine
            _currentSrc = null;
          }
        }
      });
    });
  }

  bool get _isMine =>
      _currentSrc != null &&
      widget.entry.audioAssetPath !=
          null && //Ensures that only one item is played at a time
      _currentSrc == widget.entry.audioAssetPath;

  @override
  void dispose() {
    _posSub.cancel();
    _durSub.cancel();
    _stateSub.cancel();
    super.dispose();
  }

  String _normalizeStoragePath(String p) {
    var s = p.trim();
    if (s.startsWith('assets/')) s = s.substring('assets/'.length);
    if (s.startsWith('/')) s = s.substring(1);
    return s;
  }

  Future<void> _togglePlay() async {
    //Debug session/user info
    final src = widget.entry.audioAssetPath;
    final session = Supabase.instance.client.auth.currentSession;
    final user = Supabase.instance.client.auth.currentUser;
    print('session is null? ${session == null}');
    print('currentUser=${user?.id}');
    if (src == null) return;

    //print('Click the play button：$src');

    if (_playingMine) {
      //print('Pause');
      await _player.pause();
    } else {
      //print('Try to play');
      await _player.stop(); // stop other playing

      //Go to Supabase to obtain the signed URL and then use UrlSource to play it.
      _currentSrc = src;
      _pos = Duration.zero;
      _dur = Duration.zero;
      setState(() {});
      final client = Supabase.instance.client;
      final cleanSrc = _normalizeStoragePath(src);

      debugPrint('bucket=gratitude-audio');
      debugPrint('src(raw)="$src"');
      debugPrint('src(clean)="$cleanSrc"');

      try {
        final publicUrl = client.storage
            .from('gratitude-audio')
            .getPublicUrl(cleanSrc);
        print('publicUrl=$publicUrl');
        await _player.play(UrlSource(publicUrl));
      } catch (e) {
        debugPrint('getPublicUrl failed: $e');
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Could not play audio')));
        }
      }
    }
  }

  Future<void> _deleteEntry() async {
    final supabase = Supabase.instance.client;
    try {
      if (widget.entry.audioAssetPath != null) {
        await supabase.storage.from('gratitude-audio').remove([
          widget.entry.audioAssetPath!,
        ]);
      }
      await supabase
          .from('Gratitude Entries')
          .delete()
          .eq('id', widget.entry.id);

      widget.onDeleted();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to delete: $e')));
    }
  }

  String _mmss(Duration d) {
    return formatMmSs(d);
  }

  Widget _moodChip(String mood) {
    IconData icon;
    Color bgColor;
    switch (mood) {
      case 'Happy':
        icon = Icons.sentiment_very_satisfied_rounded;
        bgColor = Color.lerp(Colors.white, const Color(0xFFFFC567), 0.55)!;
        break;
      case 'Good':
        icon = Icons.sentiment_satisfied_rounded;
        bgColor = Color.lerp(Colors.white, const Color(0xFFFFC567), 0.55)!;
        break;
      case 'Neutral':
        icon = Icons.sentiment_neutral_rounded;
        bgColor = Color.lerp(Colors.white, const Color(0xFF058CD7), 0.40)!;
        break;
      case 'Confused':
        icon = Icons.psychology_alt_rounded;
        bgColor = Color.lerp(Colors.white, const Color(0xFF058CD7), 0.40)!;
        break;
      case 'Sad':
        icon = Icons.sentiment_dissatisfied_rounded;
        bgColor = Color.lerp(Colors.white, const Color(0xFFFB7DA8), 0.45)!;
        break;
      case 'Overwhelmed':
        icon = Icons.warning_amber_rounded;
        bgColor = Color.lerp(Colors.white, const Color(0xFFFB7DA8), 0.45)!;
        break;
      case 'Frustrated':
        icon = Icons.whatshot_rounded;
        bgColor = Color.lerp(Colors.white, const Color(0xFFFB7DA8), 0.45)!;
        break;
      case 'Angry':
        icon = Icons.mood_bad_rounded;
        bgColor = Color.lerp(Colors.white, const Color(0xFFFB7DA8), 0.45)!;
        break;
      default:
        icon = Icons.emoji_emotions_outlined;
        bgColor = Colors.grey.shade300;
    }
    return Chip(
      label: Text(mood),
      avatar: Icon(icon, size: 16),
      backgroundColor: bgColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    final e = widget.entry;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      //color: Colors.white.withOpacity(0.96),
      color: isDark ? Colors.black : Color.fromRGBO(255, 255, 255, 0.96),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(e.text, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 6),
            Row(
              children: [
                if (e.mood != null) _moodChip(e.mood!),
                if (e.mood != null) const SizedBox(width: 8),
                Text(
                  friendlyTime(e.createdAt),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.redAccent,
                    size: 20,
                  ),
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Delete reflection?'),
                        content: const Text('This cannot be undone'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text(
                              'Delete',
                              style: TextStyle(color: Colors.redAccent),
                            ),
                          ),
                        ],
                      ),
                    );
                    if (confirm == true) await _deleteEntry();
                  },
                ),
              ],
            ),
            if (e.audioAssetPath != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      _playingMine ? Icons.pause_circle : Icons.play_circle,
                    ),
                    onPressed: _togglePlay,
                  ),
                  Expanded(
                    child: Slider(
                      value: (_playingMine && _dur.inMilliseconds > 0)
                          ? (_pos.inMilliseconds / _dur.inMilliseconds).clamp(
                              0,
                              1,
                            )
                          : 0,
                      onChanged: (_playingMine && _dur.inMilliseconds > 0)
                          ? (v) async {
                              final target = Duration(
                                milliseconds: (_dur.inMilliseconds * v).round(),
                              );
                              await _player.seek(target);
                            }
                          : null,
                    ),
                  ),
                  Text(
                    _playingMine ? _mmss(_pos) : '00:00',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

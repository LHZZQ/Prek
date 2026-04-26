import 'dart:async';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/gratitude_entry.dart';
import '../utils/time_utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// sort out the path
String normalizeGratitudeStoragePath(String path) {
  var value = path.trim();
  if (value.startsWith('/')) value = value.substring(1);
  if (value.startsWith('assets/')) value = value.substring('assets/'.length);
  return value;
}

// easy to mock test
abstract class GratitudeAudioController {
  Stream<Duration> get onPositionChanged;
  Stream<Duration> get onDurationChanged;
  Stream<PlayerState> get onPlayerStateChanged;

  Future<void> play(String publicUrl);
  Future<void> pause();
  Future<void> stop();
  Future<void> seek(Duration position);
}

class SharedGratitudeAudioController implements GratitudeAudioController {
  SharedGratitudeAudioController._();

  static final SharedGratitudeAudioController instance =
      SharedGratitudeAudioController._();
  //share one player
  static final AudioPlayer _player = AudioPlayer();

  @override
  Stream<Duration> get onPositionChanged => _player.onPositionChanged;

  @override
  Stream<Duration> get onDurationChanged => _player.onDurationChanged;

  @override
  Stream<PlayerState> get onPlayerStateChanged => _player.onPlayerStateChanged;

  @override
  Future<void> play(String publicUrl) => _player.play(UrlSource(publicUrl));

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() => _player.stop();

  @override
  Future<void> seek(Duration position) => _player.seek(position);
}

//Single gratitude record card: Text + Timestamp + (Optional) Voice Playback
class GratitudeTile extends StatefulWidget {
  final GratitudeEntry entry;
  final VoidCallback onDeleted;
  final GratitudeAudioController? audioController; //easy to mock test
  const GratitudeTile({
    super.key,
    required this.entry,
    required this.onDeleted,
    this.audioController,
  });

  @override
  State<GratitudeTile> createState() => _GratitudeTileState();
}

class _GratitudeTileState extends State<GratitudeTile> {
  // Shared player: Ensures that only one item is played at a time.
  static String? _currentSrc; // The currently playing resource (asset path)

  late final StreamSubscription<Duration> _posSub;
  late final StreamSubscription<Duration> _durSub;
  late final StreamSubscription<PlayerState> _stateSub;

  Duration _pos = Duration.zero;
  Duration _dur = Duration.zero;
  bool _playingMine = false; // test  this currently playing or not

  GratitudeAudioController get _audioController =>
      widget.audioController ?? SharedGratitudeAudioController.instance;
  //bool _isUrl(String s) => s.startsWith('http://') || s.startsWith('https://');

  Future<void> _probeDuration() async {
    final src = widget.entry.audioAssetPath;
    if (src == null) return;

    try {
      final client = Supabase.instance.client;
      final cleanSrc = normalizeGratitudeStoragePath(src);
      final publicUrl = client.storage
          .from('gratitude-audio')
          .getPublicUrl(cleanSrc);

      final probe = AudioPlayer();
      await probe.setSource(UrlSource(publicUrl));
      final duration = await probe.getDuration();
      await probe.dispose();

      if (mounted && duration != null) {
        setState(() => _dur = duration);
      }
    } catch (e) {
      debugPrint('Could not probe duration: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _probeDuration();
    _posSub = _audioController.onPositionChanged.listen((p) {
      if (!_isMine) return;
      setState(() => _pos = p);
    });
    _durSub = _audioController.onDurationChanged.listen((d) {
      if (!_isMine) return;
      setState(() => _dur = d);
    });
    _stateSub = _audioController.onPlayerStateChanged.listen((s) {
      final wasMine =
          _playingMine || _isMine; //Only update when it concerns oneself

      if (!wasMine) return;

      setState(() {
        _playingMine = _isMine && s == PlayerState.playing;

        if (s == PlayerState.completed ||
            s == PlayerState.stopped ||
            s == PlayerState.paused) {
          _pos = Duration.zero;

          if (s == PlayerState.completed && _isMine) {
            //complete and was mine
            _currentSrc = null;
            _dur = Duration.zero
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
      await _audioController.pause();
    } else {
      //print('Try to play');
      await _audioController.stop(); // stop other playing

      //Go to Supabase to obtain the signed URL and then use UrlSource to play it.
      _currentSrc = src;
      _pos = Duration.zero;
      setState(() {});
      final client = Supabase.instance.client;
      final cleanSrc = normalizeGratitudeStoragePath(src);

      debugPrint('bucket=gratitude-audio');
      debugPrint('src(raw)="$src"');
      debugPrint('src(clean)="$cleanSrc"');

      try {
        final publicUrl = client.storage
            .from('gratitude-audio')
            .getPublicUrl(cleanSrc);
        print('publicUrl=$publicUrl');
        await _audioController.play(publicUrl);
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
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    switch (mood) {
      case 'Happy':
        icon = Icons.sentiment_very_satisfied_rounded;
        bgColor = isDark
            ? Color(0xFFFFC567)
            : Color.lerp(Colors.white, const Color(0xFFFFC567), 0.55)!;
        break;
      case 'Good':
        icon = Icons.sentiment_satisfied_rounded;
        bgColor = isDark
            ? Color(0xFFFFC567)
            : Color.lerp(Colors.white, const Color(0xFFFFC567), 0.55)!;
      case 'Neutral':
        icon = Icons.sentiment_neutral_rounded;
        bgColor = isDark
            ? Color(0xFF058CD7)
            : Color.lerp(Colors.white, const Color(0xFF058CD7), 0.40)!;
        break;
      case 'Confused':
        icon = Icons.psychology_alt_rounded;
        bgColor = isDark
            ? Color(0xFF058CD7)
            : Color.lerp(Colors.white, const Color(0xFF058CD7), 0.40)!;
        break;
      case 'Sad':
        icon = Icons.sentiment_dissatisfied_rounded;
        bgColor = isDark
            ? Color(0xFFFB7DA8)
            : Color.lerp(Colors.white, const Color(0xFFFB7DA8), 0.45)!;
        break;
      case 'Overwhelmed':
        icon = Icons.warning_amber_rounded;
        bgColor = isDark
            ? Color(0xFFFB7DA8)
            : Color.lerp(Colors.white, const Color(0xFFFB7DA8), 0.45)!;
        break;
      case 'Frustrated':
        icon = Icons.whatshot_rounded;
        bgColor = isDark
            ? Color(0xFFFB7DA8)
            : Color.lerp(Colors.white, const Color(0xFFFB7DA8), 0.45)!;
        break;
      case 'Angry':
        icon = Icons.mood_bad_rounded;
        bgColor = isDark
            ? Color(0xFFFB7DA8)
            : Color.lerp(Colors.white, const Color(0xFFFB7DA8), 0.45)!;
        break;
      default:
        icon = Icons.emoji_emotions_outlined;
        bgColor = Colors.grey.shade300;
    }
    return Chip(
      label: Text(mood),
      avatar: Icon(icon, size: 16),
      backgroundColor: bgColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: Colors.transparent, width: 1.5),
      ),
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
            if (e.audioAssetPath == null) ...[
              Text(e.text, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 6),
            ],
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
                              await _audioController.seek(target);
                            }
                          : null,
                    ),
                  ),
                  Text(
                    _dur.inMilliseconds > 0
                        ? _mmss(_playingMine ? _pos : _dur)
                        : '00:00',
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

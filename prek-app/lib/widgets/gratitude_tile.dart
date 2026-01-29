import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/gratitude_entry.dart';
import '../utils/time_utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

//Single gratitude record card: Text + Timestamp + (Optional) Voice Playback
class GratitudeTile extends StatefulWidget {
  final GratitudeEntry entry;
  const GratitudeTile({super.key, required this.entry});

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
      final list = await client.storage
          .from('gratitude-audio')
          .list(path: 'user123'); // user123 for mock data
      final names = list.map((e) => e.name).toList();
      debugPrint('files under user123 = $names');

      final fileName = cleanSrc.split('/').last;
      if (!names.contains(fileName)) {
        debugPrint('file not found in folder yet, skip createSignedUrl');
        return;
      }

      try {
        final signedUrl = await client.storage
            .from('gratitude-audio')
            .createSignedUrl(cleanSrc, 60);
        print('signedUrl=$signedUrl');
        await _player.play(UrlSource(signedUrl));
      } catch (e) {
        debugPrint('createSignedUrl failed: $e');
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Could not play audio')));
        }
      }
    }
  }

  String _mmss(Duration d) {
    return formatMmSs(d);
  }

  Widget _moodChip(String mood) {
    IconData icon;
    switch (mood) {
      case 'happy':
        icon = Icons.sentiment_satisfied_alt;
        break;
      case 'calm':
        icon = Icons.self_improvement;
        break;
      case 'warm':
        icon = Icons.favorite;
        break;
      default:
        icon = Icons.emoji_emotions_outlined;
    }
    return Chip(label: Text(mood), avatar: Icon(icon, size: 16));
  }

  @override
  Widget build(BuildContext context) {
    final e = widget.entry;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      //color: Colors.white.withOpacity(0.96),
      color: const Color.fromRGBO(255, 255, 255, 0.96),
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

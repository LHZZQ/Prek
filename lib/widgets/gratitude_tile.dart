import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/gratitude_entry.dart';

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
      setState(() {
        _playingMine = _isMine && s == PlayerState.playing;
        if (!_playingMine) {
          // if now currently playing, don't show the bar
          _pos = Duration.zero;
          _dur = Duration.zero;
        }
      });
    });
  }

  bool get _isMine =>
      _currentSrc != null &&
      widget.entry.audioAssetPath != null &&
      _currentSrc == widget.entry.audioAssetPath;

  @override
  void dispose() {
    _posSub.cancel();
    _durSub.cancel();
    _stateSub.cancel();
    super.dispose();
  }

  Future<void> _togglePlay() async {
    final src = widget.entry.audioAssetPath;
    if (src == null) return;

    if (_playingMine) {
      await _player.pause();
    } else {
      await _player.stop(); //stop other playing
      _currentSrc = src;
      _pos = Duration.zero;
      _dur = Duration.zero;
      setState(() {});
      await _player.play(AssetSource(src)); // src format: 'audio/xxx.m4a'
    }
  }

  String _mmss(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(d.inMinutes.remainder(60))}:${two(d.inSeconds.remainder(60))}';
  }

  String _friendlyTime(DateTime dt) {
    final now = DateTime.now();
    final d0 = DateTime(now.year, now.month, now.day);
    final d1 = DateTime(dt.year, dt.month, dt.day);
    final days = d0.difference(d1).inDays;
    String day = days == 0 ? 'Today' : (days == 1 ? 'Yesterday' : '$days days ago');
    String two(int n) => n.toString().padLeft(2, '0');
    return '$day · ${two(dt.hour)}:${two(dt.minute)}';
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
      elevation: 0,
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
                  _friendlyTime(e.createdAt),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            if (e.audioAssetPath != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  IconButton(
                    icon: Icon(_playingMine ? Icons.pause_circle : Icons.play_circle),
                    onPressed: _togglePlay,
                  ),
                  Expanded(
                    child: Slider(
                      value: (_playingMine && _dur.inMilliseconds > 0)
                          ? (_pos.inMilliseconds / _dur.inMilliseconds).clamp(0, 1)
                          : 0,
                      onChanged: (_playingMine && _dur.inMilliseconds > 0)
                          ? (v) async {
                              final target = Duration(
                                  milliseconds: (_dur.inMilliseconds * v).round());
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

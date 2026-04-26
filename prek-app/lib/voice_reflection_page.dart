import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:_2025_prek/home_page.dart';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:_2025_prek/pages/entry_history_page.dart';
import 'package:_2025_prek/profile_page.dart';
import 'package:_2025_prek/settings_page.dart';
import 'package:_2025_prek/memory_gallery_page.dart';

class VoiceReflectionPage extends StatefulWidget {
  final String selectedMood;
  const VoiceReflectionPage({super.key, required this.selectedMood});

  @override
  State<VoiceReflectionPage> createState() => _VoiceReflectionPageState();
}

class _VoiceReflectionPageState extends State<VoiceReflectionPage> {
  bool _isRecording = false;
  bool _isCancelling = false;
  bool _isTappedMode = false;
  bool _isSaving = false;
  bool _isStopping = false;
  Duration _recordDuration = Duration.zero;
  Timer? _timer;

  final AudioRecorder _recorder = AudioRecorder();
  final AudioPlayer _previewPlayer = AudioPlayer();
  String? _localFilePath;
  bool _isPreviewing = false;

  @override
  void dispose() {
    _timer?.cancel();
    _recorder.dispose();
    _previewPlayer.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    }
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const EntryHistoryPage()),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfilePage()),
      );
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MemoryGalleryPage()),
      );
    } else if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SettingsPage()),
      );
    }
  }

  Future<void> _startRecording({bool isTapped = false}) async {
    if (_isRecording) return;
    if (!await _recorder.hasPermission()) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Microphone permission denied')),
        );
      }
      return;
    }

    if (kIsWeb) {
      await _recorder.start(
        const RecordConfig(encoder: AudioEncoder.opus),
        path: '',
      );
    } else {
      final dir = await getTemporaryDirectory();
      _localFilePath =
          '${dir.path}/reflection_${DateTime.now().millisecondsSinceEpoch}.m4a';

      await _recorder.start(
        const RecordConfig(encoder: AudioEncoder.aacLc),
        path: _localFilePath!,
      );
    }
    setState(() {
      _isRecording = true;
      _isTappedMode = isTapped;
      _isCancelling = false;
      _recordDuration = Duration.zero;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() => _recordDuration += const Duration(seconds: 1));
    });
  }

  Future<void> _stopAndSaveRecording() async {
    if (_isStopping || !_isRecording) return;
    _isStopping = true;

    _timer?.cancel();
    _timer = null;

    try {
      final path = await _recorder.stop();

      if (kIsWeb && path != null) {
        _localFilePath = path;
      }
    } catch (e) {
      debugPrint('Error stopping recorder: $e');
    }
    if (mounted) {
      setState(() {
        _isRecording = false;
        _isTappedMode = false;
      });
    }
  }

  Future<void> _cancelRecording() async {
    if (!_isRecording) return;
    _timer?.cancel();
    await _recorder.stop();
    if (!kIsWeb && _localFilePath != null) {
      final f = File(_localFilePath!);
      if (await f.exists()) f.delete();
      _localFilePath = null;
    }

    setState(() {
      _isRecording = false;
      _isCancelling = false;
      _isTappedMode = false;
      _recordDuration = Duration.zero;
    });
  }

  Future<void> _togglePreview() async {
    if (_localFilePath == null) return;
    if (_isPreviewing) {
      await _previewPlayer.stop();
      setState(() => _isPreviewing = false);
    } else {
      setState(() => _isPreviewing = true);
      await _previewPlayer.play(UrlSource(_localFilePath!));
      _previewPlayer.onPlayerComplete.listen((_) {
        if (mounted) setState(() => _isPreviewing = false);
      });
    }
  }

  Future<void> _saveReflection() async {
    if (_localFilePath == null) return;
    setState(() => _isSaving = true);

    try {
      final client = Supabase.instance.client;
      final user = client.auth.currentUser;
      if (user == null) throw Exception('User not logged in');

      final fileName =
          '${user.id}/${DateTime.now().millisecondsSinceEpoch}.webm';

      late Uint8List fileBytes;

      if (kIsWeb) {
        final response = await http.get(Uri.parse(_localFilePath!));
        fileBytes = response.bodyBytes;
      } else {
        fileBytes = await File(_localFilePath!).readAsBytes();
      }

      await client.storage
          .from('gratitude-audio')
          .uploadBinary(
            fileName,
            fileBytes,
            fileOptions: FileOptions(
              contentType: kIsWeb ? 'audio/webm' : 'audio/mp4',
            ),
          );

      await client.from('Gratitude Entries').insert({
        'user_id': user.id,
        'text': '',
        'mood': widget.selectedMood,
        'audio_path': fileName,
        'created_at': DateTime.now().toUtc().toIso8601String(),
      });

      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
          (route) => false,
        );
      }
    } catch (e) {
      setState(() => _isSaving = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to save: $e')));
      }
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    return "${twoDigits(duration.inMinutes.remainder(60))}:${twoDigits(duration.inSeconds.remainder(60))}";
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF94697E);
    const pink = Color(0xFFFB7DA8);
    const blue = Color(0xFF058CD7);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: textColor),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),

        title: Text(
          "Relection",
          style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final hUnit = constraints.maxHeight / 800;
          final btnSize = 160 * hUnit;

          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDark
                    ? const [Color(0xFF1E1E2C), Color(0xFF2A2A3D)]
                    : const [Color(0xFFFFF1F5), Color(0xFFFFF8EE)],
              ),
            ),
            child: SafeArea(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: 1 * hUnit,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: pink.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "Reflecting on: ${widget.selectedMood}",
                        style: TextStyle(
                          color: pink,
                          fontWeight: FontWeight.w600,
                          fontSize: 13 * hUnit,
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    top: 50 * hUnit,
                    child: SizedBox(
                      width: constraints.maxWidth * 0.85,
                      child: Text(
                        _isRecording
                            ? (_isCancelling
                                  ? "Release to cancel 🗑️"
                                  : (_isTappedMode
                                        ? "Tap button to stop\nor Slide up to cancel ⬆️"
                                        : "Swipe up to cancel ⬆️"))
                            : "Tap or Hold to record",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _isCancelling ? Colors.redAccent : textColor,
                          fontSize: 16 * hUnit,
                          height: 1.3,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: constraints.maxHeight * 0.30,
                    child: GestureDetector(
                      onTap: () async {
                        if (!_isRecording)
                          await _startRecording(isTapped: true);
                        else if (_isTappedMode)
                          await _stopAndSaveRecording();
                      },
                      onLongPressStart: (_) async =>
                          await _startRecording(isTapped: false),
                      onLongPressMoveUpdate: (details) {
                        setState(
                          () => _isCancelling =
                              details.localOffsetFromOrigin.dy < -60,
                        );
                      },
                      onLongPressEnd: (_) async {
                        if (!_isTappedMode) {
                          if (_isCancelling)
                            await _cancelRecording();
                          else
                            await _stopAndSaveRecording();
                        }
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: btnSize,
                        height: btnSize,
                        decoration: BoxDecoration(
                          color: _isCancelling
                              ? Colors.redAccent
                              : (_isRecording
                                    ? blue
                                    : (isDark
                                          ? Color(0xFF161622)
                                          : Colors.white)),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: isDark
                                  ? Colors.black.withValues(alpha: 0.1)
                                  : (_isRecording ? blue : pink).withOpacity(
                                      0.2,
                                    ),
                              blurRadius: 25,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Icon(
                          _isCancelling
                              ? Icons.delete_forever_rounded
                              : (_isRecording
                                    ? Icons.stop_rounded
                                    : Icons.mic_rounded),
                          size: 65 * hUnit,
                          color: (_isRecording || _isCancelling)
                              ? Colors.white
                              : pink,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: constraints.maxHeight * 0.52,
                    child: Container(
                      height: 50 * hUnit,
                      alignment: Alignment.center,
                      child: Text(
                        _formatDuration(_recordDuration),
                        style: TextStyle(
                          color: textColor,
                          fontSize: 42 * hUnit,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20 * hUnit,
                    left: 30,
                    right: 30,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Visibility(
                          visible:
                              !_isRecording && _recordDuration.inSeconds > 0,
                          maintainSize: true,
                          maintainAnimation: true,
                          maintainState: true,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ActionChip(
                                backgroundColor: isDark
                                    ? Color(0xFF161622)
                                    : Colors.white,
                                side: BorderSide.none,
                                label: Text(
                                  _isPreviewing ? "Stop" : "Preview",
                                  style: const TextStyle(color: blue),
                                ),
                                avatar: Icon(
                                  _isPreviewing ? Icons.stop : Icons.play_arrow,
                                  color: blue,
                                  size: 18,
                                ),
                                onPressed: _togglePreview,
                              ),
                              const SizedBox(width: 12),
                              ActionChip(
                                backgroundColor: isDark
                                    ? Color(0xFF161622)
                                    : Colors.white,
                                side: BorderSide.none,
                                label: const Text(
                                  "Redo",
                                  style: TextStyle(color: pink),
                                ),
                                avatar: const Icon(
                                  Icons.refresh,
                                  color: pink,
                                  size: 18,
                                ),
                                onPressed: () {
                                  _localFilePath = null;
                                  setState(
                                    () => _recordDuration = Duration.zero,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 25),
                        Container(
                          width: double.infinity,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            gradient: const LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Color(0xFFFFC567),
                                Color(0xFFFB7DA8),
                                Color(0xFF058CD7),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.pinkAccent.withOpacity(0.25),
                                blurRadius: 15,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                              ),
                            ),
                            onPressed:
                                (_recordDuration.inSeconds > 0 &&
                                    !_isRecording &&
                                    !_isSaving)
                                ? _saveReflection
                                : null,
                            child: _isSaving
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text(
                                    "Save Reflection",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: isDark ? Color(0xFF2A2A3D) : Color(0xFFFFF8EE),
          selectedItemColor: isDark ? Colors.white : Colors.grey.shade400,
          unselectedItemColor: isDark ? Colors.white : Colors.grey.shade400,
          showUnselectedLabels: true,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history_rounded),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.photo_album_rounded),
              label: 'Lookbook',
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.settings_rounded),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}

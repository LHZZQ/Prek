import 'dart:async';
import 'dart:io';
import 'package:_2025_prek/home_page.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';

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

    final dir = await getTemporaryDirectory();
    _localFilePath =
        '${dir.path}/reflection_${DateTime.now().millisecondsSinceEpoch}.m4a';

    await _recorder.start(
      const RecordConfig(encoder: AudioEncoder.aacLc),
      path: _localFilePath!,
    );

    setState(() {
      _isRecording = true;
      _isTappedMode = isTapped;
      _isCancelling = false;
      _recordDuration = Duration.zero;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() => _recordDuration += const Duration(seconds: 1));
    });
  }

  void _stopAndSaveRecording() {
    _timer?.cancel();
    setState(() {
      _isRecording = false;
      _isTappedMode = false;
    });
  }

  void _cancelRecording() {
    _timer?.cancel();
    setState(() {
      _isRecording = false;
      _isCancelling = false;
      _isTappedMode = false;
      _recordDuration = Duration.zero;
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    return "${twoDigits(duration.inMinutes.remainder(60))}:${twoDigits(duration.inSeconds.remainder(60))}";
  }

  @override
  Widget build(BuildContext context) {
    const textColor = Color(0xFF94697E);
    const pink = Color(0xFFFB7DA8);
    const blue = Color(0xFF058CD7);
    const yellow = Color(0xFFFFC567);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Voice Reflection",
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: textColor),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final hUnit = constraints.maxHeight / 800;
          final btnSize = 160 * hUnit;

          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFFFF1F5), Color(0xFFFFF8EE)],
              ),
            ),
            child: SafeArea(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: 10 * hUnit,
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
                      onTap: () {
                        if (!_isRecording)
                          _startRecording(isTapped: true);
                        else if (_isTappedMode)
                          _stopAndSaveRecording();
                      },
                      onLongPressStart: (_) => _startRecording(isTapped: false),
                      onLongPressMoveUpdate: (details) {
                        setState(
                          () => _isCancelling =
                              details.localOffsetFromOrigin.dy < -60,
                        );
                      },
                      onLongPressEnd: (_) {
                        if (!_isTappedMode) {
                          if (_isCancelling)
                            _cancelRecording();
                          else
                            _stopAndSaveRecording();
                        }
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: btnSize,
                        height: btnSize,
                        decoration: BoxDecoration(
                          color: _isCancelling
                              ? Colors.redAccent
                              : (_isRecording ? blue : Colors.white),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: (_isRecording ? blue : pink).withOpacity(
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
                                backgroundColor: Colors.white,
                                side: BorderSide.none,
                                label: const Text(
                                  "Preview",
                                  style: TextStyle(color: blue),
                                ),
                                avatar: const Icon(
                                  Icons.play_arrow,
                                  color: blue,
                                  size: 18,
                                ),
                                onPressed: () {},
                              ),
                              const SizedBox(width: 12),
                              ActionChip(
                                backgroundColor: Colors.white,
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
                                onPressed: () => setState(
                                  () => _recordDuration = Duration.zero,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10 * hUnit),
                        Container(
                          width: double.infinity,
                          height: 54 * hUnit,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              colors:
                                  (_recordDuration.inSeconds > 0 &&
                                      !_isRecording)
                                  ? [yellow, pink, blue]
                                  : [
                                      Colors.grey.shade300,
                                      Colors.grey.shade400,
                                    ],
                            ),
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              splashFactory: NoSplash.splashFactory,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onPressed:
                                (_recordDuration.inSeconds > 0 && !_isRecording)
                                ? () => Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const HomePage(),
                                    ),
                                    (route) => false,
                                  )
                                : null,
                            child: Text(
                              "SAVE REFLECTION",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16 * hUnit,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
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
    );
  }
}

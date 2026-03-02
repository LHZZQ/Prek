import 'dart:async';
import 'package:_2025_prek/home_page.dart';
import 'package:flutter/material.dart';

class VoiceReflectionPage extends StatefulWidget {
  final String selectedMood;
  const VoiceReflectionPage({super.key, required this.selectedMood});

  @override
  State<VoiceReflectionPage> createState() => _VoiceReflectionPageState();
}

class _VoiceReflectionPageState extends State<VoiceReflectionPage>
    with TickerProviderStateMixin {
  bool _isRecording = false;
  bool _isCancelling = false;
  Duration _recordDuration = Duration.zero;
  Timer? _timer;

  late AnimationController _rippleController;

  @override
  void initState() {
    super.initState();
    _rippleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _rippleController.dispose();
    super.dispose();
  }

  void _startRecording() {
    setState(() {
      _isRecording = true;
      _isCancelling = false;
      _recordDuration = Duration.zero;
      _rippleController.repeat();
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() => _recordDuration += const Duration(seconds: 1));
    });
  }

  void _stopAndSaveRecording() {
    _timer?.cancel();
    _rippleController.stop();
    setState(() => _isRecording = false);
    if (_recordDuration.inSeconds > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Recording kept. Tap Save to finish! 🎙️"),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _cancelRecording() {
    _timer?.cancel();
    _rippleController.stop();
    setState(() {
      _isRecording = false;
      _isCancelling = false;
      _recordDuration = Duration.zero;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Recording cancelled 🗑️"),
        backgroundColor: Colors.orange,
      ),
    );
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
          style: TextStyle(color: textColor, fontWeight: FontWeight.w700),
        ),
        iconTheme: const IconThemeData(color: textColor),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFF1F5), Color(0xFFFFF8EE)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 40),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  _isRecording
                      ? (_isCancelling
                            ? "Release to cancel 🗑️"
                            : "Swipe up to cancel ⬆️")
                      : "Hold the mic to record your thoughts",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _isCancelling ? Colors.redAccent : textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const Spacer(),

              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (_isRecording && !_isCancelling)
                      ...[0.5, 0.8].map(
                        (opacity) => AnimatedBuilder(
                          animation: _rippleController,
                          builder: (context, child) {
                            return Container(
                              width:
                                  140 +
                                  (120 * _rippleController.value * opacity),
                              height:
                                  140 +
                                  (120 * _rippleController.value * opacity),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: blue.withOpacity(
                                  0.15 * (1 - _rippleController.value),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                    GestureDetector(
                      onLongPressStart: (_) => _startRecording(),
                      onLongPressMoveUpdate: (details) {
                        setState(() {
                          _isCancelling =
                              details.localOffsetFromOrigin.dy < -80;
                        });
                      },
                      onLongPressEnd: (_) {
                        if (_isCancelling) {
                          _cancelRecording();
                        } else {
                          _stopAndSaveRecording();
                        }
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          color: _isCancelling
                              ? Colors.redAccent
                              : (_isRecording ? blue : Colors.white),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color:
                                  (_isCancelling
                                          ? Colors.red
                                          : (_isRecording ? blue : pink))
                                      .withOpacity(0.2),
                              blurRadius: 25,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Icon(
                          _isCancelling
                              ? Icons.delete_forever_rounded
                              : Icons.mic_rounded,
                          size: 70,
                          color: (_isRecording || _isCancelling)
                              ? Colors.white
                              : pink,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              Text(
                _formatDuration(_recordDuration),
                style: const TextStyle(
                  color: textColor,
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'monospace',
                ),
              ),

              const Spacer(),

              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30, bottom: 40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 40,
                      child: (!_isRecording && _recordDuration.inSeconds > 0)
                          ? TextButton.icon(
                              onPressed: () => setState(
                                () => _recordDuration = Duration.zero,
                              ),
                              icon: const Icon(
                                Icons.refresh_rounded,
                                color: pink,
                                size: 20,
                              ),
                              label: const Text(
                                "Redo Recording",
                                style: TextStyle(color: pink),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),

                    const SizedBox(height: 10),

                    Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 500),
                        child: Container(
                          width: double.infinity,
                          height: 62,
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
                            boxShadow: [
                              if (_recordDuration.inSeconds > 0 &&
                                  !_isRecording)
                                BoxShadow(
                                  color: pink.withOpacity(0.25),
                                  blurRadius: 15,
                                  offset: const Offset(0, 6),
                                ),
                            ],
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onPressed:
                                (_recordDuration.inSeconds > 0 && !_isRecording)
                                ? () {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const HomePage(),
                                      ),
                                      (route) => false,
                                    );
                                  }
                                : null,
                            child: const Text(
                              "Save & Finish",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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
      ),
    );
  }
}

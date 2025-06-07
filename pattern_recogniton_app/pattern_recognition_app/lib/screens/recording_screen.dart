import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/emotion_result.dart';
import '../services/audio_service.dart';
import '../services/api_service.dart';
import '../widgets/recording_button.dart';
import '../widgets/emotion_result_card.dart';
import '../widgets/error_message.dart';
import '../widgets/instructions_card.dart';

class RecordingScreen extends StatefulWidget {
  const RecordingScreen({super.key});

  @override
  State<RecordingScreen> createState() => _RecordingScreenState();
}

class _RecordingScreenState extends State<RecordingScreen>
    with TickerProviderStateMixin {
  final AudioService _audioService = AudioService();

  bool _isRecording = false;
  bool _isProcessing = false;
  bool _permissionChecked = false;
  EmotionResult? _emotionResult;
  String? _errorMessage;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    // Check permissions on app start
    _checkInitialPermissions();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _audioService.dispose();
    super.dispose();
  }

  Future<void> _checkInitialPermissions() async {
    final status = await Permission.microphone.status;
    setState(() {
      _permissionChecked = true;
    });

    if (kDebugMode) {
      print('Initial microphone permission status: $status');
    }
  }

  Future<void> _startRecording() async {
    setState(() {
      _errorMessage = null;
      _emotionResult = null;
    });

    // Show permission dialog immediately if needed
    final hasPermission = await _audioService.checkPermissions();
    if (!hasPermission) {
      final status = await Permission.microphone.status;
      if (status == PermissionStatus.permanentlyDenied) {
        setState(() {
          _errorMessage =
              'Microphone permission is permanently denied. Please enable it in Settings.';
        });
        // Show dialog to guide user to settings
        _showPermissionDialog();
      } else {
        setState(() {
          _errorMessage = 'Microphone permission is required to record audio.';
        });
      }
      return;
    }

    try {
      await _audioService.startRecording();

      setState(() {
        _isRecording = true;
      });

      // Auto-stop recording after 3 seconds
      _audioService.startTimer(const Duration(seconds: 3), () {
        _stopRecording();
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to start recording: $e';
      });
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Microphone Permission Required'),
          content: const Text(
            'This app needs microphone access to record your voice for emotion recognition. Please enable microphone permission in Settings.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings();
              },
              child: const Text('Open Settings'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _stopRecording() async {
    if (!_isRecording) return;

    try {
      final path = await _audioService.stopRecording();
      setState(() {
        _isRecording = false;
        _isProcessing = true;
      });

      if (path != null) {
        await _sendToAPI(path);
      }
    } catch (e) {
      setState(() {
        _isRecording = false;
        _isProcessing = false;
        _errorMessage = 'Failed to stop recording: $e';
      });
    }
  }

  Future<void> _sendToAPI(String filePath) async {
    try {
      final result = await ApiService.predictEmotion(filePath);
      setState(() {
        _emotionResult = result;
        _isProcessing = false;
      });
    } catch (e) {
      setState(() {
        _isProcessing = false;
        _errorMessage = e.toString();
      });
    }
  }

  String _getStatusText() {
    if (_isRecording) return 'Recording... (3 seconds)';
    if (_isProcessing) return 'Analyzing emotion...';
    return 'Tap to record your voice';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        title: const Text(
          'Emotion Recognition',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF2D2D2D),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Status Text
            Text(
              _getStatusText(),
              style: const TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.w300,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 50),

            // Recording Button
            RecordingButton(
              isRecording: _isRecording,
              isProcessing: _isProcessing,
              pulseAnimation: _pulseController,
              onTap: _isRecording || _isProcessing ? null : _startRecording,
            ),
            const SizedBox(height: 30),

            // Manual Permission Button (for debugging)
            if (!_permissionChecked ||
                _errorMessage?.contains('permission') == true)
              ElevatedButton.icon(
                onPressed: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  setState(() {
                    _errorMessage = null;
                  });

                  final hasPermission = await _audioService.checkPermissions();
                  if (hasPermission) {
                    setState(() {
                      _errorMessage = null;
                    });
                    if (mounted) {
                      messenger.showSnackBar(
                        const SnackBar(
                          content: Text('Microphone permission granted!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  } else {
                    final status = await Permission.microphone.status;
                    setState(() {
                      _errorMessage = 'Permission denied. Status: $status';
                    });
                  }
                },
                icon: const Icon(Icons.mic_none),
                label: const Text('Request Microphone Permission'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),

            const SizedBox(height: 20),

            // Result Section
            if (_emotionResult != null) ...[
              EmotionResultCard(emotionResult: _emotionResult!),
            ],

            // Error Message
            if (_errorMessage != null) ...[
              const SizedBox(height: 20),
              ErrorMessage(message: _errorMessage!),
            ],

            const Spacer(),

            // Instructions
            const InstructionsCard(),
          ],
        ),
      ),
    );
  }
}

import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioService {
  final AudioRecorder _audioRecorder = AudioRecorder();
  Timer? _recordingTimer;

  Future<bool> checkPermissions() async {
    try {
      // Check current permission status
      final microphoneStatus = await Permission.microphone.status;

      if (kDebugMode) {
        print('Current microphone permission status: $microphoneStatus');
      }

      // If permission is already granted, return true
      if (microphoneStatus == PermissionStatus.granted) {
        return true;
      }

      // If permission was permanently denied, we can't request it again
      if (microphoneStatus == PermissionStatus.permanentlyDenied) {
        if (kDebugMode) {
          print(
              'Microphone permission permanently denied. Opening settings...');
        }
        // On iOS, this will open the Settings app
        await openAppSettings();
        return false;
      }

      // Request permission
      if (kDebugMode) {
        print('Requesting microphone permission...');
      }

      final result = await Permission.microphone.request();

      if (kDebugMode) {
        print('Permission request result: $result');
      }

      return result == PermissionStatus.granted;
    } catch (e) {
      if (kDebugMode) {
        print('Error checking microphone permissions: $e');
      }
      return false;
    }
  }

  Future<String> startRecording() async {
    final directory = await getTemporaryDirectory();
    final path =
        '${directory.path}/recording_${DateTime.now().millisecondsSinceEpoch}.wav';

    // Delete any existing file
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }

    await _audioRecorder.start(
      const RecordConfig(
        encoder: AudioEncoder.wav,
        sampleRate: 16000,
        bitRate: 128000,
      ),
      path: path,
    );

    return path;
  }

  Future<String?> stopRecording() async {
    _recordingTimer?.cancel();
    return await _audioRecorder.stop();
  }

  void startTimer(Duration duration, VoidCallback onComplete) {
    _recordingTimer = Timer(duration, onComplete);
  }

  void dispose() {
    _recordingTimer?.cancel();
    _audioRecorder.dispose();
  }
}

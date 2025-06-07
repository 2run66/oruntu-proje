import 'package:flutter/material.dart';
import 'screens/recording_screen.dart';

void main() {
  runApp(const EmotionRecognitionApp());
}

class EmotionRecognitionApp extends StatelessWidget {
  const EmotionRecognitionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Emotion Recognition',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const RecordingScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

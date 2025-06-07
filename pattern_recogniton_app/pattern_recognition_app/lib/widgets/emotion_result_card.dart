import 'package:flutter/material.dart';
import '../models/emotion_result.dart';
import '../utils/emotion_utils.dart';

class EmotionResultCard extends StatelessWidget {
  final EmotionResult emotionResult;

  const EmotionResultCard({
    super.key,
    required this.emotionResult,
  });

  @override
  Widget build(BuildContext context) {
    final color = EmotionUtils.getEmotionColor(emotionResult.emotion);
    final icon = EmotionUtils.getEmotionIcon(emotionResult.emotion);
    final description =
        EmotionUtils.getEmotionDescription(emotionResult.emotion);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: color,
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 60,
            color: color,
          ),
          const SizedBox(height: 15),
          Text(
            'Detected Emotion:',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            emotionResult.emotion.toUpperCase(),
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Analyzed at ${_formatTime(emotionResult.timestamp)}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    return '${timestamp.hour.toString().padLeft(2, '0')}:'
        '${timestamp.minute.toString().padLeft(2, '0')}:'
        '${timestamp.second.toString().padLeft(2, '0')}';
  }
}

import 'package:flutter/material.dart';

class EmotionUtils {
  static Color getEmotionColor(String? emotion) {
    if (emotion == null) return Colors.grey;
    switch (emotion.toLowerCase()) {
      case 'happy':
        return Colors.yellow;
      case 'sad':
        return Colors.blue;
      case 'angry':
        return Colors.red;
      case 'fearful':
        return Colors.purple;
      case 'surprised':
        return Colors.orange;
      case 'disgust':
        return Colors.green;
      case 'calm':
        return Colors.lightBlue;
      case 'neutral':
        return Colors.grey;
      default:
        return Colors.teal;
    }
  }

  static IconData getEmotionIcon(String? emotion) {
    if (emotion == null) return Icons.sentiment_neutral;
    switch (emotion.toLowerCase()) {
      case 'happy':
        return Icons.sentiment_very_satisfied;
      case 'sad':
        return Icons.sentiment_very_dissatisfied;
      case 'angry':
        return Icons.sentiment_dissatisfied;
      case 'fearful':
        return Icons.psychology;
      case 'surprised':
        return Icons.sentiment_satisfied;
      case 'disgust':
        return Icons.sick;
      case 'calm':
        return Icons.self_improvement;
      case 'neutral':
        return Icons.sentiment_neutral;
      default:
        return Icons.sentiment_satisfied;
    }
  }

  static String getEmotionDescription(String? emotion) {
    if (emotion == null) return 'Unknown';
    switch (emotion.toLowerCase()) {
      case 'happy':
        return 'You sound happy and joyful! 😊';
      case 'sad':
        return 'You seem a bit sad. 😢';
      case 'angry':
        return 'There\'s some anger in your voice. 😠';
      case 'fearful':
        return 'You sound fearful or anxious. 😨';
      case 'surprised':
        return 'You seem surprised! 😲';
      case 'disgust':
        return 'You sound disgusted or displeased. 🤢';
      case 'calm':
        return 'You sound calm and peaceful. 😌';
      case 'neutral':
        return 'Your emotion is neutral. 😐';
      default:
        return 'Emotion detected: ${emotion.toUpperCase()}';
    }
  }

  static List<String> getAllEmotions() {
    return [
      'neutral',
      'calm',
      'happy',
      'sad',
      'angry',
      'fearful',
      'disgust',
      'surprised',
    ];
  }
}

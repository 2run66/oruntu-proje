class EmotionResult {
  final String emotion;
  final DateTime timestamp;

  EmotionResult({
    required this.emotion,
    required this.timestamp,
  });

  factory EmotionResult.fromJson(Map<String, dynamic> json) {
    return EmotionResult(
      emotion: json['emotion'] as String,
      timestamp: DateTime.now(),
    );
  }
}

import 'package:flutter/material.dart';

class RecordingButton extends StatelessWidget {
  final bool isRecording;
  final bool isProcessing;
  final Animation<double> pulseAnimation;
  final VoidCallback? onTap;

  const RecordingButton({
    super.key,
    required this.isRecording,
    required this.isProcessing,
    required this.pulseAnimation,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedBuilder(
        animation: pulseAnimation,
        builder: (context, child) {
          return Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _getButtonColor(),
              boxShadow: _getBoxShadow(),
            ),
            child: Icon(
              _getButtonIcon(),
              size: 80,
              color: Colors.white,
            ),
          );
        },
      ),
    );
  }

  Color _getButtonColor() {
    if (isRecording) return Colors.red.withValues(alpha: 0.8);
    if (isProcessing) return Colors.orange.withValues(alpha: 0.8);
    return Colors.blue.withValues(alpha: 0.8);
  }

  IconData _getButtonIcon() {
    if (isRecording) return Icons.stop;
    if (isProcessing) return Icons.hourglass_empty;
    return Icons.mic;
  }

  List<BoxShadow> _getBoxShadow() {
    if (isRecording) {
      return [
        BoxShadow(
          color: Colors.red.withValues(alpha: 0.3 + 0.3 * pulseAnimation.value),
          blurRadius: 20 + 20 * pulseAnimation.value,
          spreadRadius: 5 + 10 * pulseAnimation.value,
        ),
      ];
    }
    return [
      BoxShadow(
        color: Colors.blue.withValues(alpha: 0.3),
        blurRadius: 20,
        spreadRadius: 5,
      ),
    ];
  }
}

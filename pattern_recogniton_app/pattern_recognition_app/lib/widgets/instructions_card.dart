import 'package:flutter/material.dart';

class InstructionsCard extends StatelessWidget {
  const InstructionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Column(
        children: [
          Icon(Icons.info_outline, color: Colors.white70),
          SizedBox(height: 10),
          Text(
            'Instructions:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '• Tap the microphone to start recording\n'
            '• Speak clearly for 3 seconds\n'
            '• Recording will stop automatically\n'
            '• Your emotion will be analyzed and displayed',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

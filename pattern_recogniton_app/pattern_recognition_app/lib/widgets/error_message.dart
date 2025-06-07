import 'package:flutter/material.dart';

class ErrorMessage extends StatelessWidget {
  final String message;

  const ErrorMessage({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.red, width: 1),
      ),
      child: Row(
        children: [
          const Icon(Icons.error, color: Colors.red),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

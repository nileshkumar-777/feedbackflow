import 'package:flutter/material.dart';

class StepFourScreen extends StatelessWidget {
  const StepFourScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Icon(Icons.preview, size: 80),
        SizedBox(height: 15),
        Text(
          "Review & Submit",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

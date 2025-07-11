import 'package:flutter/material.dart';

class StartButton extends StatelessWidget {
  final bool isTracking;
  final VoidCallback onPressed;

  const StartButton({
    super.key,
    required this.isTracking,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isTracking ? Colors.red : Colors.green,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
        icon: Icon(isTracking ? Icons.pause : Icons.directions_walk),
        label: Text(isTracking ? 'إيقاف' : 'ابدأ'),
      ),
    );
  }
}

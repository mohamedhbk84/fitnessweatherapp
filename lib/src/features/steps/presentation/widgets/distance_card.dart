// ملف: distance_card.dart
import 'package:flutter/material.dart';

class DistanceCard extends StatelessWidget {
  final double distance; // بالكيلومتر

  const DistanceCard({super.key, required this.distance});

  @override
  Widget build(BuildContext context) {
    final displayValue = distance >= 1
        ? '${distance.toStringAsFixed(2)} كم'
        : '${(distance * 1000).toStringAsFixed(0)} م';

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: distance),
      duration: const Duration(milliseconds: 500),
      builder: (context, value, child) {
        final animatedValue = value >= 1
            ? '${value.toStringAsFixed(2)} كم'
            : '${(value * 1000).toStringAsFixed(0)} م';

        return Card(
          elevation: 6,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                colors: [Colors.orange, Colors.deepOrange],
              ),
            ),
            child: Column(
              children: [
                const Icon(Icons.straighten, color: Colors.white, size: 40),
                const SizedBox(height: 8),
                const Text('المسافة المقطوعة', style: TextStyle(color: Colors.white70)),
                const SizedBox(height: 8),
                Text(
                  animatedValue,
                  style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

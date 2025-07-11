// ملف: steps_card.dart
import 'package:flutter/material.dart';

class StepsCard extends StatefulWidget {
  final int steps;

  const StepsCard({super.key, required this.steps});

  @override
  State<StepsCard> createState() => _StepsCardState();
}

class _StepsCardState extends State<StepsCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulse;
  late int _oldSteps;

  @override
  void initState() {
    super.initState();
    _oldSteps = widget.steps;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _pulse = Tween<double>(begin: 1.0, end: 1.2).chain(CurveTween(curve: Curves.easeOut)).animate(_controller);
  }

  @override
  void didUpdateWidget(covariant StepsCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.steps != oldWidget.steps) {
      _controller.forward(from: 0);
      _oldSteps = widget.steps;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _pulse,
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [Colors.indigo, Colors.deepPurple],
            ),
          ),
          child: Column(
            children: [
              const Icon(Icons.directions_walk, color: Colors.white, size: 40),
              const SizedBox(height: 8),
              const Text('عدد الخطوات', style: TextStyle(color: Colors.white70)),
              const SizedBox(height: 8),
              Text(
                '${widget.steps}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(color: Colors.black26, blurRadius: 4)],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

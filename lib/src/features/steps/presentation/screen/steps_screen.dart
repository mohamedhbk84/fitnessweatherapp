// ملف: lib/src/features/steps/presentation/screens/steps_screen.dart
import 'dart:math';
import 'package:fitnessweatherapp/src/features/steps/presentation/widgets/distance_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitnessweatherapp/src/features/steps/presentation/bloc/steps_bloc.dart';
import 'package:fitnessweatherapp/src/features/steps/presentation/bloc/steps_event.dart';
import 'package:fitnessweatherapp/src/features/steps/presentation/bloc/steps_state.dart';

class StepsScreen extends StatefulWidget {
  const StepsScreen({super.key});

  @override
  State<StepsScreen> createState() => _StepsScreenState();
}

class _StepsScreenState extends State<StepsScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _stepBumpController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _stepBumpAnimation;
  int _lastSteps = 0;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _stepBumpController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _stepBumpAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _stepBumpController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _stepBumpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('عداد الخطوات')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<StepsBloc, StepsState>(
          builder: (context, state) {
            final isTracking = state.isTracking;
            final steps = state.steps;
            final distance = state.distanceKm;

            // Trigger animation on step change
            if (_lastSteps != steps) {
              _stepBumpController.forward(from: 0.0);
              _lastSteps = steps;
            }

            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ScaleTransition(
                    scale: _pulseAnimation,
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () {
                          if (isTracking) {
                            context.read<StepsBloc>().add(StopTracking());
                          } else {
                            context.read<StepsBloc>().add(StartTracking());
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          isTracking ? Colors.orange : Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 20),
                        ),
                        child: Column(
                          children: [
                            Icon(isTracking ? Icons.pause : Icons.play_arrow,
                                size: 32, color: Colors.white),
                            const SizedBox(height: 8),
                            Text(
                              isTracking ? 'إيقاف' : 'ابدأ',
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Steps Card with animated number
                  ScaleTransition(
                    scale: _stepBumpAnimation,
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: const LinearGradient(
                            colors: [Colors.blue, Colors.lightBlueAccent],
                          ),
                        ),
                        child: Column(
                          children: [
                            const Icon(Icons.directions_walk,
                                color: Colors.white, size: 40),
                            const SizedBox(height: 10),
                            const Text('عدد الخطوات',
                                style: TextStyle(color: Colors.white70)),
                            const SizedBox(height: 8),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              transitionBuilder: (child, animation) =>
                                  ScaleTransition(scale: animation, child: child),
                              child: Text(
                                '$steps',
                                key: ValueKey(steps),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Distance Card
                  DistanceCard(distance: distance),

                  const SizedBox(height: 15),

                  // Reset Button
                  ElevatedButton(
                    onPressed: () {
                      context.read<StepsBloc>().add(ResetSteps());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('إعادة تهيئة',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

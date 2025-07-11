import 'package:flutter/material.dart';

class WeeklyForecastItem {
  final String day;
  final double temperature;
  final String condition;

  WeeklyForecastItem({
    required this.day,
    required this.temperature,
    required this.condition,
  });
}

class WeatherWeeklyForecast extends StatefulWidget {
  final List<WeeklyForecastItem> forecasts;

  const WeatherWeeklyForecast({super.key, required this.forecasts});

  @override
  State<WeatherWeeklyForecast> createState() => _WeatherWeeklyForecastState();
}

class _WeatherWeeklyForecastState extends State<WeatherWeeklyForecast>
    with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;
  late final List<Animation<Offset>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = widget.forecasts.map((_) {
      return AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
      );
    }).toList();

    _animations = _controllers.map((controller) {
      return Tween<Offset>(
        begin: const Offset(1.5, 0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeOut),
      );
    }).toList();

    _runStaggeredAnimations();
  }

  void _runStaggeredAnimations() async {
    for (var controller in _controllers) {
      await Future.delayed(const Duration(milliseconds: 150));
      controller.forward();
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.forecasts.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = widget.forecasts[index];

        return SlideTransition(
          position: _animations[index],
          child: Card(
            elevation: 3,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [Colors.lightBlueAccent, Colors.blue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(item.day,
                      style: const TextStyle(
                          fontSize: 18, color: Colors.white70)),
                  Row(
                    children: [
                      Text(
                        '${item.temperature.toStringAsFixed(1)}°C',
                        style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        _getIcon(item.condition),
                        color: Colors.white,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  IconData _getIcon(String condition) {
    if (condition.contains('شمس')) return Icons.wb_sunny;
    if (condition.contains('غيوم')) return Icons.cloud;
    if (condition.contains('مطر')) return Icons.beach_access;
    return Icons.cloud_queue;
  }
}

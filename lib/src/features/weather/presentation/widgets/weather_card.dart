// ملف: lib/src/features/weather/presentation/widgets/weather_card.dart
import 'package:flutter/material.dart';

class WeatherCard extends StatelessWidget {
  final String condition;
  final double temperature;
  final int humidity;
  final double windSpeed;

  const WeatherCard({
    super.key,
    required this.condition,
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
  });

  IconData _getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'sunny':
        return Icons.wb_sunny;
      case 'cloudy':
        return Icons.wb_cloudy;
      case 'rainy':
        return Icons.beach_access;
      default:
        return Icons.wb_sunny;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [Colors.lightBlue, Colors.blueAccent],
            ),
          ),
          child: Column(
            children: [
              Icon(
                _getWeatherIcon(condition),
                size: 60,
                color: Colors.white,
              ),
              const SizedBox(height: 12),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (child, animation) => ScaleTransition(
                  scale: animation,
                  child: child,
                ),
                child: Text(
                  '${temperature.toStringAsFixed(1)}°C',
                  key: ValueKey(temperature),
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                condition,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildDetail('الرطوبة', '$humidity%', Icons.water_drop),
                  _buildDetail('الرياح', '$windSpeed م/ث', Icons.air),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetail(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 24),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

class ForecastItem extends StatelessWidget {
  final String day;
  final String conditionEmoji;
  final double temperature;

  const ForecastItem({
    super.key,
    required this.day,
    required this.conditionEmoji,
    required this.temperature,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: ListTile(
        leading: Text(
          conditionEmoji,
          style: const TextStyle(fontSize: 28),
        ),
        title: Text(
          day,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: Text(
          '${temperature.toStringAsFixed(1)}°C',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.blue[700],
          ),
        ),
      ),
    );
  }
}

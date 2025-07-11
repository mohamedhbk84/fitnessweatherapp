import 'package:equatable/equatable.dart';

class WeatherModel extends Equatable {
  final double temperature;
  final String condition;
  final int humidity;
  final double windSpeed;
  final List<DailyForecast> weekly;

  const WeatherModel({
    required this.temperature,
    required this.condition,
    required this.humidity,
    required this.windSpeed,
    required this.weekly,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      temperature: (json['temperature'] as num).toDouble(),
      condition: json['condition']["text"] ?? '',
      humidity: json['humidity'] ?? 0,
      windSpeed: (json['windSpeed'] as num).toDouble(),
      weekly: (json['weekly'] as List<dynamic>)
          .map((e) => DailyForecast.fromJson(e))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [temperature, condition, humidity, windSpeed, weekly];
}

class DailyForecast extends Equatable {
  final String day;
  final double temperature;
  final String condition;

  const DailyForecast({
    required this.day,
    required this.temperature,
    required this.condition,
  });

  factory DailyForecast.fromJson(Map<String, dynamic> json) {
    return DailyForecast(
      day: json['day'] ?? 'اليوم',
      temperature: (json['temperature'] as num).toDouble(),
      condition: json['condition'] ?? '☀️',
    );
  }

  @override
  List<Object?> get props => [day, temperature, condition];
}



import 'package:equatable/equatable.dart';
import 'package:fitnessweatherapp/src/features/weather/models/weather_model.dart';

abstract class WeatherState extends Equatable {
  const WeatherState();

  @override
  List<Object?> get props => [];
}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherError extends WeatherState {
  final String message;

  const WeatherError(this.message);

  @override
  List<Object?> get props => [message];
}

class WeatherLoaded extends WeatherState {
  final WeatherModel current;
  final List<DailyForecast> weekly;

  const WeatherLoaded({required this.current, required this.weekly});

  @override
  List<Object?> get props => [current, weekly];
}
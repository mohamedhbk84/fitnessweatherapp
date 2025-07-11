

import 'package:equatable/equatable.dart';
import 'package:fitnessweatherapp/src/features/weather/models/weather_model.dart';

abstract class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object> get props => [];
}

class StartWeatherUpdates extends WeatherEvent {}

class WeatherUpdated extends WeatherEvent {
  final WeatherModel weather;

  const WeatherUpdated(this.weather);

  @override
  List<Object> get props => [weather];
}

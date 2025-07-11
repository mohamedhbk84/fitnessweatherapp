// ملف: lib/src/features/weather/bloc/weather_bloc.dart
import 'dart:async';

import 'package:fitnessweatherapp/src/features/weather/models/weather_model.dart';
import 'package:fitnessweatherapp/src/features/weather/presentation/bloc/weather_event.dart';
import 'package:fitnessweatherapp/src/features/weather/presentation/bloc/weather_state.dart';
import 'package:fitnessweatherapp/src/features/weather/repository/WeatherRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';


class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository repository;
  StreamSubscription<WeatherModel>? _weatherSubscription;

  WeatherBloc({required this.repository}) : super(WeatherInitial()) {
    on<StartWeatherUpdates>(_onStartWeatherUpdates);
    on<WeatherUpdated>(_onWeatherUpdated);
  }

  void _onStartWeatherUpdates(
      StartWeatherUpdates event, Emitter<WeatherState> emit) {
    emit(WeatherLoading());

    _weatherSubscription?.cancel();
    _weatherSubscription = repository.getWeatherStream().listen(
          (weatherData) {
        add(WeatherUpdated(weatherData));
      },
      onError: (error) {
        emit(WeatherError(error.toString()));
      },
    );
  }

  void _onWeatherUpdated(WeatherUpdated event, Emitter<WeatherState> emit) {
    emit(WeatherLoaded(
      current: event.weather,
      weekly: event.weather.weekly,
    ));
  }

  @override
  Future<void> close() {
    _weatherSubscription?.cancel();
    return super.close();
  }
}

import 'package:fitnessweatherapp/src/features/weather/models/weather_model.dart';
import 'package:fitnessweatherapp/src/features/weather/presentation/bloc/weather_event.dart';
import 'package:fitnessweatherapp/src/features/weather/presentation/bloc/weather_state.dart';
import 'package:fitnessweatherapp/src/features/weather/presentation/widgets/weekly_forecast_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/weather_bloc.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WeatherBloc(repository: context.read())
        ..add(StartWeatherUpdates()),
      child: const WeatherView(),
    );
  }
}

class WeatherView extends StatelessWidget {
  const WeatherView({super.key});

  IconData _getWeatherIcon(String condition) {
    switch (condition) {
      case 'Sunny':
        return Icons.wb_sunny;
      case 'Cloudy':
        return Icons.cloud;
      case 'Rainy':
        return Icons.beach_access;
      default:
        return Icons.wb_cloudy;
    }
  }

  Widget _buildWeatherCard(WeatherModel weather) {
    final Color startColor = weather.condition.contains('شمس')
        ? Colors.orange
        : weather.condition.contains('غيوم')
        ? Colors.grey
        : Colors.blueGrey;

    final Color endColor = weather.condition.contains('شمس')
        ? Colors.deepOrange
        : weather.condition.contains('غيوم')
        ? Colors.blueGrey
        : Colors.lightBlue;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [startColor, endColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (child, animation) =>
                ScaleTransition(scale: animation, child: child),
            child: Icon(
              _getWeatherIcon(weather.condition),
              key: ValueKey(weather.condition),
              size: 64,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (child, animation) =>
                ScaleTransition(scale: animation, child: child),
            child: Text(
              '${weather.temperature.toStringAsFixed(1)} °C',
              key: ValueKey(weather.temperature),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            weather.condition,
            style: const TextStyle(color: Colors.white70, fontSize: 20),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildDetail('الرطوبة', '${weather.humidity}%', Icons.water_drop),
              _buildDetail(
                'الرياح',
                '${weather.windSpeed.toStringAsFixed(1)} م/ث',
                Icons.air,
              ),
            ],
          )
        ],
      ),
    );
  }


  Widget _buildDetail(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 24),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white70)),
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('حالة الطقس'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocBuilder<WeatherBloc, WeatherState>(
          builder: (context, state) {
            if (state is WeatherLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is WeatherLoaded) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    _buildWeatherCard(state.current),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'توقعات الأسبوع',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    const SizedBox(height: 10),
                    WeatherWeeklyForecast(
                      forecasts: state.weekly
                          .map((e) => WeeklyForecastItem(
                        day: e.day,
                        temperature: e.temperature,
                        condition: e.condition,
                      ))
                          .toList(),
                    ),
                  ],
                ),
              );

              // return SingleChildScrollView(
              //   child: Column(
              //     children: [
              //       _buildWeatherCard(state.current),
              //       const SizedBox(height: 20),
              //       Align(
              //         alignment: Alignment.centerRight,
              //         child: Text(
              //           'توقعات الأسبوع',
              //           style: Theme.of(context).textTheme.titleMedium,
              //         ),
              //       ),
              //       const SizedBox(height: 10),
              //       ListView.builder(
              //         shrinkWrap: true,
              //         physics: const NeverScrollableScrollPhysics(),
              //         itemCount: state.weekly.length,
              //         itemBuilder: (_, index) {
              //           final day = state.weekly[index];
              //           return Card(
              //             elevation: 3,
              //             margin: const EdgeInsets.symmetric(vertical: 6),
              //             shape: RoundedRectangleBorder(
              //               borderRadius: BorderRadius.circular(12),
              //             ),
              //             child: ListTile(
              //               leading: Text(day.condition,
              //                   style: const TextStyle(fontSize: 24)),
              //               title: Text(day.day,
              //                   style:
              //                   const TextStyle(fontWeight: FontWeight.bold)),
              //               trailing: Text(
              //                   '${day.temperature.toStringAsFixed(1)} °C'),
              //             ),
              //           );
              //         },
              //       ),
              //     ],
              //   ),
              // );
            } else if (state is WeatherError) {
              return Center(child: Text('حدث خطأ: ${state.message}'));
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}

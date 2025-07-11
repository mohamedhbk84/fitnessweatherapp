import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherRepository {
  final Duration updateInterval;
  final String apiKey;
  final String city;

  WeatherRepository({
    required this.apiKey,
    required this.city,
    this.updateInterval = const Duration(minutes: 15),
  });

  Stream<WeatherModel> getWeatherStream() async* {
    while (true) {
      try {
        final weather = await fetchWeather();
        yield weather;
      } catch (e) {
        print('Weather fetch error: $e');
      }

      await Future.delayed(updateInterval);
    }
  }

  Future<WeatherModel> fetchWeather() async {
    final url = Uri.parse(
        'https://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=$city&days=7&lang=ar');
        // 'https://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=$city&days=7&lang=ar');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final decodedBody = utf8.decode(response.bodyBytes);
      final data = json.decode(decodedBody);
      // final data = json.decode(response.body);
      //  print("dataqweqweqw");
      //  print(data.toString());
      final current = data['current'];
      final forecastList = data['forecast']['forecastday'] as List;

      final weekly = forecastList.map((item) {
        final day = DateTime.parse(item['date']).weekday;
        final dayNames = [
          'الاثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت', 'الأحد'
        ];
        return DailyForecast(
          day: dayNames[(day - 1) % 7],
          temperature: (item['day']['avgtemp_c'] ?? 0).toDouble(),
          condition: item['day']['condition']['text'] ?? '',
        );
      }).toList();

      return WeatherModel(
        temperature: (current['temp_c'] ?? 0).toDouble(),
        condition: current['condition']['text'] ?? '',
        humidity: current['humidity'] ?? 0,
        windSpeed: (current['wind_kph'] ?? 0).toDouble(),
        weekly: weekly,
      );
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}

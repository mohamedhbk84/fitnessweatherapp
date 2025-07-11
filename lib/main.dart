
import 'package:fitnessweatherapp/firebase_options.dart';
import 'package:fitnessweatherapp/src/features/weather/presentation/bloc/weather_event.dart';
import 'package:fitnessweatherapp/src/features/weather/repository/WeatherRepository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'src/features/steps/presentation/bloc/steps_bloc.dart';
import 'src/features/weather/presentation/bloc/weather_bloc.dart';
import 'src/features/main_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   await initFirebaseMessaging();
  final weatherRepository = WeatherRepository(
    apiKey: '49984c31075544809ac163024251007',
    city: 'Cairo',
    updateInterval: const Duration(seconds: 5),

  );

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<WeatherRepository>.value(value: weatherRepository),
      ],
      child: const FitnessWeatherApp(),
    ),
  );
}
class FitnessWeatherApp extends StatelessWidget {
  const FitnessWeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => StepsBloc()), //..add(StartTracking())),
        BlocProvider(
          create: (_) => WeatherBloc(
            repository: context.read<WeatherRepository>(),
          )..add(StartWeatherUpdates()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Fitness  Weather App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Roboto',
          scaffoldBackgroundColor: Colors.white,
        ),
        home: const MainScreen(),
      ),
    );
  }
}

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   try {
//     await Firebase.initializeApp();
//   }catch(e){
//
//   }
//   runApp(const FitnessWeatherApp());
// }

// class FitnessWeatherApp extends StatelessWidget {
//   const FitnessWeatherApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//
//       final weatherRepository = WeatherRepository(
//         apiKey: 'a7d85e7c142514411235bcfa6cab6e8d',
//         city: 'Cairo',
//       );
//
//       return MultiBlocProvider(
//         providers: [
//           BlocProvider(create: (_) => StepsBloc()..add(StartTracking())),
//           BlocProvider(create: (_) => WeatherBloc(repository: weatherRepository)..add(StartWeatherUpdates())),
//         ],
//         child: MaterialApp(
//           debugShowCheckedModeBanner: false,
//           title: 'Fitness & Weather App',
//           theme: ThemeData(
//             primarySwatch: Colors.blue,
//             fontFamily: 'Roboto',
//             scaffoldBackgroundColor: Colors.white,
//           ),
//           home: const MainScreen(),
//         ),
//       );
//
//   }
// }

#!/bin/bash

# Create base folders
mkdir -p lib/src/features/steps/data
mkdir -p lib/src/features/steps/domain
mkdir -p lib/src/features/steps/presentation/widgets

mkdir -p lib/src/features/weather/data
mkdir -p lib/src/features/weather/domain
mkdir -p lib/src/features/weather/presentation/widgets

mkdir -p lib/core
mkdir -p lib/config

# Create files
touch lib/main.dart

# Steps
touch lib/src/features/steps/data/step_repository.dart
touch lib/src/features/steps/domain/usecases.dart
touch lib/src/features/steps/presentation/bloc/steps_bloc.dart
touch lib/src/features/steps/presentation/widgets/step_card.dart
touch lib/src/features/steps/presentation/widgets/distance_card.dart

# Weather
touch lib/src/features/weather/data/weather_repository.dart
touch lib/src/features/weather/domain/usecases.dart
touch lib/src/features/weather/presentation/bloc/weather_bloc.dart
touch lib/src/features/weather/presentation/widgets/weather_card.dart
touch lib/src/features/weather/presentation/widgets/daily_weather_list.dart

# Main screen
mkdir -p lib/src/features/
touch lib/src/features/main_screen.dart

# Core
touch lib/core/constants.dart
touch lib/core/utils.dart

# Config
touch lib/config/firebase_options.dart
touch lib/config/notification_helper.dart

echo "✅ Project structure created successfully."

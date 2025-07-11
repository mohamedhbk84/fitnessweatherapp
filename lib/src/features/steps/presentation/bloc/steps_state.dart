class StepsState {
  final int steps;
  final bool isTracking;

  StepsState({required this.steps, required this.isTracking});

  double get distanceKm => steps * 0.8 / 1000;

  StepsState copyWith({int? steps, bool? isTracking}) {
    return StepsState(
      steps: steps ?? this.steps,
      isTracking: isTracking ?? this.isTracking,
    );
  }
}

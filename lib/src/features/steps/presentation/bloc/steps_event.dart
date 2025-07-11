abstract class StepsEvent {}

class StartTracking extends StepsEvent {}

class StopTracking extends StepsEvent {}

class ResetSteps extends StepsEvent {}

class IncrementStep extends StepsEvent {}

import 'dart:async';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'steps_event.dart';
import 'steps_state.dart';

class StepsBloc extends Bloc<StepsEvent, StepsState> {
  Timer? _timer;

  StepsBloc() : super(StepsState(steps: 0, isTracking: false)) {
    on<StartTracking>((event, emit) {
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(milliseconds: 800), (_) {
        add(IncrementStep());
      });
      emit(state.copyWith(isTracking: true));

    });

    on<StopTracking>((event, emit) {
      _timer?.cancel();
      emit(state.copyWith(isTracking: false));
    });

    on<ResetSteps>((event, emit) {
      _timer?.cancel();
      emit(StepsState(steps: 0, isTracking: false));
    });

    on<IncrementStep>((event, emit) {
      emit(state.copyWith(steps: state.steps + 1));
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}

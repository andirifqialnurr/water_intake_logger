import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:water_intake_logger/data/repositories/hydration_repository.dart';
import 'package:water_intake_logger/features/hydration/bloc/hydration_event.dart';
import 'package:water_intake_logger/features/hydration/bloc/hydration_state.dart';

class HydrationBloc extends Bloc<HydrationEvent, HydrationState> {
  final HydrationRepository repository;

  HydrationBloc({required this.repository}) : super(const HydrationInitial()) {
    on<HydrationStarted>(_onStarted);
    on<HydrationWaterAdded>(_onWaterAdded);
    on<HydrationWaterRemoved>(_onWaterRemoved);
    on<HydrationGoalChanged>(_onGoalChanged);
  }

  Future<void> _onStarted(
    HydrationStarted event,
    Emitter<HydrationState> emit,
  ) async {
    emit(const HydrationLoading());

    try {
      final summary = await repository.getTodaySummary();
      emit(HydrationSuccess(summary: summary));
    } catch (error) {
      emit(HydrationFailure(message: error.toString()));
    }
  }

  Future<void> _onWaterAdded(
    HydrationWaterAdded event,
    Emitter<HydrationState> emit,
  ) async {
    try {
      await repository.addWater(
        amountMl: event.amountMl,
        sourceType: event.sourceType,
        sourceLabel: event.sourceLabel,
      );
      final summary = await repository.getTodaySummary();

      emit(HydrationSuccess(summary: summary));
    } catch (error) {
      emit(HydrationFailure(message: error.toString()));
    }
  }

  Future<void> _onWaterRemoved(
    HydrationWaterRemoved event,
    Emitter<HydrationState> emit,
  ) async {
    try {
      await repository.removeWater(
        amountMl: event.amountMl,
        sourceType: event.sourceType,
        sourceLabel: event.sourceLabel,
      );

      final summary = await repository.getTodaySummary();
      emit(HydrationSuccess(summary: summary));
    } catch (error) {
      emit(HydrationFailure(message: error.toString()));
    }
  }

  Future<void> _onGoalChanged(
    HydrationGoalChanged event,
    Emitter<HydrationState> emit,
  ) async {
    try {
      await repository.setTodayGoal(event.targetMl);
      final summary = await repository.getTodaySummary();

      emit(HydrationSuccess(summary: summary));
    } catch (error) {
      emit(HydrationFailure(message: error.toString()));
    }
  }
}

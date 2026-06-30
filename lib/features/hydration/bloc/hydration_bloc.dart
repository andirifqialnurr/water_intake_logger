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
    on<HydrationEntryAmountChanged>(_onEntryAmountChanged);
    on<HydrationEntryDeleted>(_onEntryDeleted);
  }

  Future<void> _emitHydrationSuccess(Emitter<HydrationState> emit) async {
    final summary = await repository.getTodaySummary();
    final history = await repository.getHistorySummaries();
    final weeklyProgress = await repository.getCurrentWeekSummaries();
    final profileSummary = await repository.getProfileSummary();
    final entryLogs = await repository.getHistoryEntryLogs();

    emit(
      HydrationSuccess(
        summary: summary,
        history: history,
        weeklyProgress: weeklyProgress,
        profileSummary: profileSummary,
        entryLogs: entryLogs,
      ),
    );
  }

  Future<void> _onStarted(
    HydrationStarted event,
    Emitter<HydrationState> emit,
  ) async {
    emit(const HydrationLoading());

    try {
      await _emitHydrationSuccess(emit);
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
      await _emitHydrationSuccess(emit);
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

      await _emitHydrationSuccess(emit);
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

      await _emitHydrationSuccess(emit);
    } catch (error) {
      emit(HydrationFailure(message: error.toString()));
    }
  }

  Future<void> _onEntryAmountChanged(
    HydrationEntryAmountChanged event,
    Emitter<HydrationState> emit,
  ) async {
    try {
      await repository.updateEntryAmount(
        entryId: event.entryId,
        amountMl: event.amountMl,
      );
      await _emitHydrationSuccess(emit);
    } catch (error) {
      emit(HydrationFailure(message: error.toString()));
    }
  }

  Future<void> _onEntryDeleted(
    HydrationEntryDeleted event,
    Emitter<HydrationState> emit,
  ) async {
    try {
      await repository.softDeleteEntry(entryId: event.entryId);
      await _emitHydrationSuccess(emit);
    } catch (error) {
      emit(HydrationFailure(message: error.toString()));
    }
  }
}

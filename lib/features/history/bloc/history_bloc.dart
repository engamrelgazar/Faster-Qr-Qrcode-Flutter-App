/*
 * Author: Amr Ahmed Elgazar
 * Phone: +201030691425
 * Country: Egypt
 * Email: eng.amr.elgazar@outlook.com
 */

import 'package:bloc/bloc.dart';
import 'package:fasterqr/features/history/data_layer/history_repository.dart';
import 'package:fasterqr/services/data/operation.dart';
import 'package:meta/meta.dart';

part 'history_event.dart';
part 'history_state.dart';

/// The BLoC (Business Logic Component) responsible for handling history-related events and states.
class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final HistoryRepository historyRepository;
  static const int pageSize = 35;

  /// Constructor for [HistoryBloc] which initializes the event handlers.
  HistoryBloc(this.historyRepository) : super(HistoryInitial()) {
    on<LoadHistory>(_onLoadHistory);
    on<LoadMoreHistory>(_onLoadMoreHistory);
    on<DeleteOperation>(_onDeleteOperation);
    on<DeleteAllOperations>(_onDeleteAllOperations);
  }

  /// Event handler for loading the initial history.
  ///
  /// Emits [HistoryLoading] state, then fetches the history data from the repository.
  /// Emits [HistoryLoaded] with the history data if successful, otherwise emits [HistoryError].
  void _onLoadHistory(LoadHistory event, Emitter<HistoryState> emit) async {
    try {
      emit(HistoryLoading());
      final history = await historyRepository.loadHistory(pageSize);
      emit(HistoryLoaded(history, history.length < pageSize));
    } catch (e) {
      emit(HistoryError("Could not load history"));
    }
  }

  /// Event handler for loading more history.
  ///
  /// Fetches more history data from the repository if the current state is [HistoryLoaded] and has not reached max.
  /// Emits [HistoryLoaded] with updated history data if successful, otherwise emits [HistoryError].
  void _onLoadMoreHistory(
      LoadMoreHistory event, Emitter<HistoryState> emit) async {
    final currentState = state;
    if (currentState is HistoryLoaded && !currentState.hasReachedMax) {
      try {
        final nextHistory = await historyRepository.loadMoreHistory(
            currentState.history.length, pageSize);
        emit(currentState.copyWith(
          history: currentState.history + nextHistory,
          hasReachedMax: nextHistory.length < pageSize,
        ));
      } catch (e) {
        emit(HistoryError("Could not load more history"));
      }
    }
  }

  /// Event handler for deleting a specific operation.
  ///
  /// Deletes the operation from the repository and reloads the history.
  /// Emits [HistoryLoaded] with updated history data if successful, otherwise emits [HistoryError].
  void _onDeleteOperation(
      DeleteOperation event, Emitter<HistoryState> emit) async {
    try {
      await historyRepository.deleteOperation(event.key);
      final history = await historyRepository.loadHistory(pageSize);
      emit(HistoryLoaded(history, history.length < pageSize));
    } catch (e) {
      emit(HistoryError("Could not delete operation"));
    }
  }

  /// Event handler for deleting all operations.
  ///
  /// Deletes all operations from the repository and emits [HistoryLoaded] with an empty history.
  /// Emits [HistoryLoaded] with an empty history if successful, otherwise emits [HistoryError].
  void _onDeleteAllOperations(
      DeleteAllOperations event, Emitter<HistoryState> emit) async {
    try {
      await historyRepository.deleteAllOperations();
      emit(HistoryLoaded(const [], true));
    } catch (e) {
      emit(HistoryError("Could not delete all operations"));
    }
  }
}

/*
 * Author: Amr Ahmed Elgazar
 * Phone: +201030691425
 * Country: Egypt
 * Email: eng.amr.elgazar@outlook.com
 */

part of 'history_bloc.dart';

@immutable
sealed class HistoryState {}

/// Initial state of the history bloc.
final class HistoryInitial extends HistoryState {}

/// State when history is loaded successfully.
class HistoryLoaded extends HistoryState {
  final List<Operation> history;
  final bool hasReachedMax;

  HistoryLoaded(this.history, this.hasReachedMax);

  List<Object> get props => [history, hasReachedMax];

  HistoryLoaded copyWith({
    List<Operation>? history,
    bool? hasReachedMax,
  }) {
    return HistoryLoaded(
      history ?? this.history,
      hasReachedMax ?? this.hasReachedMax,
    );
  }
}

/// State when the history is being loaded.
class HistoryLoading extends HistoryState {}

/// State when there is an error loading the history.
class HistoryError extends HistoryState {
  final String message;

  HistoryError(this.message);

  List<Object> get props => [message];
}

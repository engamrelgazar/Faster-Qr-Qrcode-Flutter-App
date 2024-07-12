/*
 * Author: Amr Ahmed Elgazar
 * Phone: +201030691425
 * Country: Egypt
 * Email: eng.amr.elgazar@outlook.com
 */

part of 'history_bloc.dart';

@immutable
sealed class HistoryEvent {}

/// Event to load the initial history.
class LoadHistory extends HistoryEvent {}

/// Event to load more history.
class LoadMoreHistory extends HistoryEvent {}

/// Event to delete a specific operation from the history.
class DeleteOperation extends HistoryEvent {
  final dynamic key;

  DeleteOperation(this.key);

  List<Object> get props => [key];
}

/// Event to delete all operations from the history.
class DeleteAllOperations extends HistoryEvent {}

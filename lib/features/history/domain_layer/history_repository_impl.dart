/*
 * Author: Amr Ahmed Elgazar
 * Phone: +201030691425
 * Country: Egypt
 * Email: eng.amr.elgazar@outlook.com
 */

import 'package:fasterqr/features/history/data_layer/history_repository.dart';
import 'package:fasterqr/services/data/operation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  final Box<Operation> historyBox = Hive.box<Operation>('operation_history');

  @override
  Future<List<Operation>> loadHistory(int pageSize) async {
    return historyBox.values.take(pageSize).toList();
  }

  @override
  Future<List<Operation>> loadMoreHistory(int currentSize, int pageSize) async {
    return historyBox.values.skip(currentSize).take(pageSize).toList();
  }

  @override
  Future<void> deleteOperation(dynamic key) async {
    await historyBox.delete(key);
  }

  @override
  Future<void> deleteAllOperations() async {
    await historyBox.clear();
  }
}

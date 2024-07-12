/*
 * Author: Amr Ahmed Elgazar
 * Phone: +201030691425
 * Country: Egypt
 * Email: eng.amr.elgazar@outlook.com
 */

import 'package:fasterqr/services/data/operation.dart';

abstract class HistoryRepository {
  Future<List<Operation>> loadHistory(int pageSize);
  Future<List<Operation>> loadMoreHistory(int currentSize, int pageSize);
  Future<void> deleteOperation(dynamic key);
  Future<void> deleteAllOperations();
}

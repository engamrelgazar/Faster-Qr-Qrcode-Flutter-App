/*
 * Author: Amr Ahmed Elgazar
 * Phone: +201030691425
 * Country: Egypt
 * Email: eng.amr.elgazar@outlook.com
 */

import 'package:hive/hive.dart';
import 'data/operation.dart';

class OperationService {
  static const String _boxName = 'operation_history';
  late final Box<Operation> operationHistoryBox;

  OperationService() {
    _initializeBox();
  }

  /// Initializes the Hive box.
  Future<void> _initializeBox() async {
    operationHistoryBox = await Hive.openBox<Operation>(_boxName);
  }

  /// Saves an operation to the Hive box.
  void saveOperation(String result) {
    final operation = Operation(result, DateTime.now());
    operationHistoryBox.add(operation);
  }

  /// Closes the Hive box.
  Future<void> closeBox() async {
    await operationHistoryBox.close();
  }
}

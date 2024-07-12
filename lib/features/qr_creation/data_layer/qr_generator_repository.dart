/*
 * Author: Amr Ahmed Elgazar
 * Phone: +201030691425
 * Country: Egypt
 * Email: eng.amr.elgazar@outlook.com
 */

import 'package:fasterqr/services/operation_service.dart';

/// Repository for handling QR code generation and saving operations.
class QRGeneratorRepository {
  final OperationService operationService = OperationService();

  /// Saves the generated QR code operation.
  void saveOperation(String result) {
    operationService.saveOperation(result);
  }
}

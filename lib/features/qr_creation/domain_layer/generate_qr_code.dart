/*
 * Author: Amr Ahmed Elgazar
 * Phone: +201030691425
 * Country: Egypt
 * Email: eng.amr.elgazar@outlook.com
 */

import 'package:fasterqr/features/qr_creation/data_layer/qr_generator_repository.dart';

/// Use case for generating QR codes.
class GenerateQRCode {
  final QRGeneratorRepository repository = QRGeneratorRepository();

  /// Calls the repository to save the generated QR code operation.
  void call(String result) {
    repository.saveOperation(result);
  }
}

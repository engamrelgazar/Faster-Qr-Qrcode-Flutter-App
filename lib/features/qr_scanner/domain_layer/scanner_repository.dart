import 'package:fasterqr/features/qr_scanner/data_layer/scanner_data_source.dart';
import 'package:images_picker/images_picker.dart';

/// [ScannerRepository] provides the interface for scanning QR codes.
class ScannerRepository {
  final ScannerDataSource dataSource;

  ScannerRepository(this.dataSource);



  /// Analyzes a QR code from an image.
  Future<String?> analyzeImage(String path) async {
    return await dataSource.analyzeImage(path);
  }

  /// Picks an image from the gallery.
  Future<List<Media>?> pickImage() async {
    return await dataSource.pickImage();
  }

  /// Checks and requests camera permission if not granted.
  Future<bool> checkCameraPermission() async {
    return await dataSource.checkCameraPermission();
  }
}

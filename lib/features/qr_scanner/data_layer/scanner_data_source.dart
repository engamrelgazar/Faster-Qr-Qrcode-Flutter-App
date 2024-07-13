import 'package:images_picker/images_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scan/scan.dart';

/// [ScannerDataSource] handles the low-level QR code scanning operations.
class ScannerDataSource {


  /// Analyzes a QR code from an image.
  Future<String?> analyzeImage(String path) async {
    return await Scan.parse(path);
  }

  /// Picks an image from the gallery.
  Future<List<Media>?> pickImage() async {
    return await ImagesPicker.pick();
  }

  /// Checks and requests camera permission if not granted.
  Future<bool> checkCameraPermission() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      status = await Permission.camera.request();
    }
    return status.isGranted;
  }
}

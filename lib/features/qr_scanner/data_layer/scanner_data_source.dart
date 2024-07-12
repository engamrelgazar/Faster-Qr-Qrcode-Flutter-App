import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:images_picker/images_picker.dart';
import 'package:permission_handler/permission_handler.dart';

/// [ScannerDataSource] handles the low-level QR code scanning operations.
class ScannerDataSource {
  final MobileScannerController controller = MobileScannerController();

  /// Starts scanning for QR codes using the camera.
  Future<void> startScanning(Function(String) onBarcodeDetected) async {
    if (!controller.value.isRunning) {
      await controller.start();
    }
    controller.barcodes.listen((barcodeCapture) {
      final barcode = barcodeCapture.barcodes.first;
      if (barcode.rawValue != null) {
        onBarcodeDetected(barcode.rawValue!);
      }
    });
  }

  /// Analyzes a QR code from an image.
  Future<BarcodeCapture?> analyzeImage(String path) async {
    return await controller.analyzeImage(path);
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

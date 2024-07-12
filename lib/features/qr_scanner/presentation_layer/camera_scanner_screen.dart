/*
 * Author: Amr Ahmed Elgazar
 * Phone: +201030691425
 * Country: Egypt
 * Email: eng.amr.elgazar@outlook.com
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:fasterqr/features/qr_scanner/bloc/scanner_bloc.dart';

/// A stateless widget that displays the camera scanner screen.
class CameraScannerScreen extends StatelessWidget {
  // Controller for the mobile scanner.
  final MobileScannerController controller = MobileScannerController();

  // Constructor for the CameraScannerScreen widget.
  CameraScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera Scanner'),
      ),
      body: MobileScanner(
        
        controller: controller,
        fit: BoxFit.cover,

        /// Callback function when a QR code is detected.
        onDetect: (barcodeCapture) {
          final barcode = barcodeCapture.barcodes.first;
          if (barcode.rawValue != null) {
            // Triggering the ScanCompleted event with the detected barcode value.
            BlocProvider.of<ScannerBloc>(context)
                .add(ScanCompleted(barcode.rawValue!, context));
          }
        },

        /// Builder function to display an error message if scanning fails.
        errorBuilder: (context, error, child) {
          return Center(child: Text('Error: ${error.errorDetails!.message}'));
        },

        /// Builder function to display an overlay on the scanner.
        overlayBuilder: (context, constraints) {
          return Center(
            child: Container(
              width: constraints.maxWidth * 0.8,
              height: constraints.maxHeight * 0.4,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 2),
              ),
            ),
          );
        },

        /// Builder function to display a placeholder while the scanner is initializing.
        placeholderBuilder: (context, child) {
          return const Center(child: CircularProgressIndicator());
        },

        /// Threshold for updating the scan window.
        scanWindowUpdateThreshold: 10.0,
      ),
    );
  }
}

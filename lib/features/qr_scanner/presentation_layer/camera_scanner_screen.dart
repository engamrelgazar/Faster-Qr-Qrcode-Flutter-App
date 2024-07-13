/*
 * Author: Amr Ahmed Elgazar
 * Phone: +201030691425
 * Country: Egypt
 * Email: eng.amr.elgazar@outlook.com
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fasterqr/features/qr_scanner/bloc/scanner_bloc.dart';
import 'package:scan/scan.dart';

/// A stateless widget that displays the camera scanner screen.
class CameraScannerScreen extends StatelessWidget {
  // Controller for the mobile scanner.
  final ScanController controller = ScanController();

  // Constructor for the CameraScannerScreen widget.
  CameraScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera Scanner'),
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: ScanView(
          controller: controller,
          scanAreaScale: .7,
          scanLineColor: Colors.green.shade400,

          /// Callback function when a QR code is detected.
          onCapture: (barcodeCapture) {
            // Triggering the ScanCompleted event with the detected barcode value.
            BlocProvider.of<ScannerBloc>(context)
                .add(ScanCompleted(barcodeCapture, context));
          },
        ),
      ),
    );
  }
}

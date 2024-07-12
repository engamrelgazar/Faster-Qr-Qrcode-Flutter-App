/*
 * Author: Amr Ahmed Elgazar
 * Phone: +201030691425
 * Country: Egypt
 * Email: eng.amr.elgazar@outlook.com
 */

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:bloc/bloc.dart';
import 'package:fasterqr/core/utils/flutter_toast.dart';
import 'package:fasterqr/features/qr_creation/domain_layer/generate_qr_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:meta/meta.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:path_provider/path_provider.dart';
part 'generate_event.dart';
part 'generate_state.dart';

/// [GenerateBloc] handles the state management for QR code generation.
class GenerateBloc extends Bloc<GenerateEvent, GenerateState> {
  final GenerateQRCode generateQRCode = GenerateQRCode();

  GenerateBloc() : super(GenerateInitial()) {
    on<GenerateQREvent>(_onGenerateQREvent);
    on<SaveQREvent>(_onSaveQREvent);
  }

  /// Generates the QR code based on the provided data.
  void _onGenerateQREvent(GenerateQREvent event, Emitter<GenerateState> emit) {
    final qrData = event.data;
    generateQRCode.call(qrData);
    emit(QRGenerated(qrData, event.eyeStyle, event.dataModuleStyle));
  }

  /// Saves the generated QR code as an image to the gallery.
  Future<void> _onSaveQREvent(
      SaveQREvent event, Emitter<GenerateState> emit) async {
    try {
      RenderRepaintBoundary boundary = event.globalKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      var image = await boundary.toImage(
          pixelRatio: 3.0); // Adjust pixel ratio for higher resolution
      ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();
      final tempDir = await getTemporaryDirectory();
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final file = await File('${tempDir.path}/qr_$timestamp.png').create();
      await file.writeAsBytes(pngBytes);
      await GallerySaver.saveImage(file.path, albumName: 'Faster QR');
      CustomToast.successToast('Saved successfully');
      emit(QRCodeSaved());
    } catch (e) {
      CustomToast.errorToast('Unexpected error');
    }
  }
}

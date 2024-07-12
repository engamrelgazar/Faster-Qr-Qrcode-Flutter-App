/*
 * Author: Amr Ahmed Elgazar
 * Phone: +201030691425
 * Country: Egypt
 * Email: eng.amr.elgazar@outlook.com
 */

part of 'generate_bloc.dart';

/// Base class for all generate states.
@immutable
sealed class GenerateState {}

/// Initial state of the QR code generation process.
final class GenerateInitial extends GenerateState {}

/// State indicating that a QR code has been generated.
class QRGenerated extends GenerateState {
  final String qrData;
  final QrEyeStyle eyeStyle;
  final QrDataModuleStyle dataModuleStyle;

  QRGenerated(this.qrData, this.eyeStyle, this.dataModuleStyle);
}

/// State indicating that an image has been picked from the gallery.
class ImagePickedState extends GenerateState {
  final ImageProvider image;

  ImagePickedState(this.image);
}

/// State indicating that the QR code has been saved successfully.
class QRCodeSaved extends GenerateState {}

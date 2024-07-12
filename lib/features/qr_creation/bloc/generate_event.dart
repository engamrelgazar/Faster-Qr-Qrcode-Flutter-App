/*
 * Author: Amr Ahmed Elgazar
 * Phone: +201030691425
 * Country: Egypt
 * Email: eng.amr.elgazar@outlook.com
 */

part of 'generate_bloc.dart';

/// Base class for all generate events.
@immutable
sealed class GenerateEvent {}

/// Event to generate a QR code with specified styles and optional embedded image.
class GenerateQREvent extends GenerateEvent {
  final String data;
  final QrEyeStyle eyeStyle;
  final QrDataModuleStyle dataModuleStyle;

  GenerateQREvent(this.data, this.eyeStyle, this.dataModuleStyle);
}



/// Event to save the generated QR code as an image.
class SaveQREvent extends GenerateEvent {
  final GlobalKey globalKey;

  SaveQREvent(this.globalKey);
}

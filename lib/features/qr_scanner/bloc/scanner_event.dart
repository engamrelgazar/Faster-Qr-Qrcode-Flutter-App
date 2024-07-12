/*
 * Author: Amr Ahmed Elgazar
 * Phone: +201030691425
 * Country: Egypt
 * Email: eng.amr.elgazar@outlook.com
 */

part of 'scanner_bloc.dart';

/// Base class for all scanner events.
@immutable
sealed class ScannerEvent {}

/// Event to start scanning using the camera.
class StartScan extends ScannerEvent {
  final BuildContext context;
  StartScan(this.context);
  List<Object> get props => [context];
}

/// Event to scan a QR code from an image.
class ScanFromImage extends ScannerEvent {}

/// Event triggered when a scan is completed successfully.
class ScanCompleted extends ScannerEvent {
  final String result;
  final BuildContext context;
  ScanCompleted(this.result, this.context);
  List<Object> get props => [result];
}

/// Event to reset the scanner state.
class ScanAgain extends ScannerEvent {}

class CheckCameraPermission extends ScannerEvent {
  final BuildContext context;

  CheckCameraPermission(this.context);

  List<Object> get props => [context];
}
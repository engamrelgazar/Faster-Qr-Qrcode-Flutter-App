/*
 * Author: Amr Ahmed Elgazar
 * Phone: +201030691425
 * Country: Egypt
 * Email: eng.amr.elgazar@outlook.com
 */

part of 'scanner_bloc.dart';

/// Base class for all scanner states.
@immutable
sealed class ScannerState {}

/// Initial state of the scanner.
final class ScannerInitial extends ScannerState {}

/// State indicating a successful scan.
class ScanSuccess extends ScannerState {
  final String scannedValue;
  ScanSuccess(this.scannedValue);
}

/// State indicating a scan failure.
class ScanFailure extends ScannerState {
  final String message;
  ScanFailure(this.message);
}

class OpenCamera extends ScannerState {}

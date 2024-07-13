import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:fasterqr/core/constants/app_routes.dart';
import 'package:fasterqr/core/utils/flutter_toast.dart';
import 'package:fasterqr/features/qr_scanner/data_layer/scanner_data_source.dart';
import 'package:fasterqr/features/qr_scanner/domain_layer/scanner_repository.dart';
import 'package:fasterqr/services/operation_service.dart';
import 'package:images_picker/images_picker.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';

part 'scanner_event.dart';
part 'scanner_state.dart';

/// [ScannerBloc] handles the state management for QR code scanning.
class ScannerBloc extends Bloc<ScannerEvent, ScannerState> {
  final OperationService operationService;
  final ScannerRepository repository;
  final AudioPlayer _audioPlayer = AudioPlayer();

  ScannerBloc()
      : operationService = OperationService(),
        repository = ScannerRepository(ScannerDataSource()),
        super(ScannerInitial()) {
    on<ScanFromImage>(_onScanFromImage);
    on<ScanAgain>(_onScanAgain);
    on<ScanCompleted>(_onScanCompleted);
    on<CheckCameraPermission>(_onCheckCameraPermission);
  }

  /// Checks for camera permission and navigates to camera scanner if granted.
  Future<void> _onCheckCameraPermission(
      CheckCameraPermission event, Emitter<ScannerState> emit) async {
    final hasPermission = await repository.checkCameraPermission();
    if (hasPermission) {
      if (!event.context.mounted) return;
      Navigator.pushNamed(event.context, AppRoutes.cameraScanner);
    } else {
      CustomToast.errorToast('Camera permission is required to scan QR codes.');
    }
  }

  /// Scans a QR code from an image selected from the gallery.
  Future<void> _onScanFromImage(
      ScanFromImage event, Emitter<ScannerState> emit) async {
    try {
      List<Media>? res = await repository.pickImage();
      if (res != null && res.isNotEmpty) {
        String? result = await repository.analyzeImage(res[0].path);
        if (result != null) {
          await _playSuccessSound();
          operationService.saveOperation(result);
          emit(ScanSuccess(result));
        } else {
          emit(ScanFailure('No QR code found in the image.'));
          CustomToast.errorToast('No QR code found in the image.');
        }
      } else {
        emit(ScanFailure('Error try again later'));
        CustomToast.errorToast('Error try again later');
      }
    } catch (e) {
      emit(ScanFailure(e.toString()));
      CustomToast.errorToast(e.toString());
    }
  }

  /// Handles the successful completion of a QR code scan.
  void _onScanCompleted(ScanCompleted event, Emitter<ScannerState> emit) async {
    emit(ScanSuccess(event.result));
    await _playSuccessSound();
    operationService.saveOperation(event.result);
    if (!event.context.mounted) return null;
    if (Navigator.canPop(event.context)) {
      Navigator.pop(event.context);
    }
  }

  /// Resets the state to allow scanning again.
  void _onScanAgain(ScanAgain event, Emitter<ScannerState> emit) {
    emit(ScannerInitial());
  }

  /// Plays a success sound after a successful scan.
  Future<void> _playSuccessSound() async {
    await _audioPlayer.play(
      AssetSource('sounds/scan.mp3'),
    );
  }
}

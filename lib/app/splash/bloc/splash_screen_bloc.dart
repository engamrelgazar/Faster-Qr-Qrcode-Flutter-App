/*
 * Author: Amr Ahmed Elgazar
 * Phone: +201030691425
 * Country: Egypt
 * Email: eng.amr.elgazar@outlook.com
 */

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'splash_screen_event.dart';
part 'splash_screen_state.dart';

class SplashScreenBloc extends Bloc<SplashScreenEvent, SplashScreenState> {
  SplashScreenBloc() : super(SplashScreenInitial()) {
    // Handle StartSplashScreenEvent
    on<StartSplashScreenEvent>((event, emit) async {
      // Simulate a delay for the splash screen
      await Future.delayed(const Duration(seconds: 5));
      // Emit SplashScreenCompleted state after delay
      emit(SplashScreenCompleted());
    });
  }
}

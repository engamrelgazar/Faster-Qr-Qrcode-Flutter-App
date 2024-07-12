/*
 * Author: Amr Ahmed Elgazar
 * Phone: +201030691425
 * Country: Egypt
 * Email: eng.amr.elgazar@outlook.com
 */

part of 'splash_screen_bloc.dart';

@immutable
sealed class SplashScreenEvent {}

// Event to start the splash screen
class StartSplashScreenEvent extends SplashScreenEvent {}

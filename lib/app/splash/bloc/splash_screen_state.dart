/*
 * Author: Amr Ahmed Elgazar
 * Phone: +201030691425
 * Country: Egypt
 * Email: eng.amr.elgazar@outlook.com
 */

part of 'splash_screen_bloc.dart';

@immutable
sealed class SplashScreenState {}

// Initial state of the splash screen
final class SplashScreenInitial extends SplashScreenState {}

// State when the splash screen is completed
class SplashScreenCompleted extends SplashScreenState {}

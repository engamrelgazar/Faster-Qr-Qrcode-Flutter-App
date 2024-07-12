import 'package:fasterqr/features/history/presentation_layer/history_screen.dart';
import 'package:fasterqr/app/home/presentation/home_screen.dart';
import 'package:fasterqr/app/splash/presentation/splash_screen.dart';
import 'package:fasterqr/features/qr_scanner/presentation_layer/camera_scanner_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
  static const String history = '/history';
   static const String cameraScanner = '/camerascanner';
  static Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),
    home: (context) => const HomeScreen(),
    history: (context) => const HistoryScreen(),
    cameraScanner: (context) =>  CameraScannerScreen()
  };
}

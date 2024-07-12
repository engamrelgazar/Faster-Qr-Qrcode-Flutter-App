/*
 * Author: Amr Ahmed Elgazar
 * Phone: +201030691425
 * Country: Egypt
 * Email: eng.amr.elgazar@outlook.com
 */

import 'package:fasterqr/core/constants/app_colors.dart';
import 'package:fasterqr/core/constants/app_routes.dart';
import 'package:fasterqr/core/utils/flutter_toast.dart';
import 'package:fasterqr/features/qr_creation/bloc/generate_bloc.dart';
import 'package:fasterqr/features/qr_scanner/bloc/scanner_bloc.dart';
import 'package:fasterqr/services/data/operation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize MethodChannel for native communication.
  const platform = MethodChannel('com.fasterqr.qrcode.fasterqr/tile');
  try {
    await platform.invokeMethod('toggleTile');
  } on PlatformException catch (e) {
    CustomToast.errorToast(e.toString());
    // Handle exception if any occurs during the method call.
  }

  // Initialize Hive for local storage.
  final appDocumentDirectory = await getApplicationSupportDirectory();
  Hive.registerAdapter(OperationAdapter());
  await Hive.initFlutter(appDocumentDirectory.path);
  await Hive.openBox<Operation>('operation_history');

  // Run the application.
  runApp(const MyApp());
}

/// MyApp is the root widget of the application.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ScannerBloc(),
        ),
        BlocProvider(
          create: (context) => GenerateBloc(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Faster QR',
        theme: ThemeData(
          primaryColor: AppColors.kPrimaryColor,
          fontFamily: 'PTSerif',
          colorScheme:
              ColorScheme.fromSeed(seedColor: AppColors.kBackgroundColor),
        ),
        initialRoute: '/',
        routes: AppRoutes.routes,
      ),
    );
  }
}

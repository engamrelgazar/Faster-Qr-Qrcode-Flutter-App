/*
 * Author: Amr Ahmed Elgazar
 * Phone: +201030691425
 * Country: Egypt
 * Email: eng.amr.elgazar@outlook.com
 */

import 'package:fasterqr/core/constants/app_routes.dart';
import 'package:fasterqr/app/splash/bloc/splash_screen_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fasterqr/core/constants/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late SplashScreenBloc _splashBloc;

  @override
  void initState() {
    super.initState();
    _splashBloc = SplashScreenBloc()..add(StartSplashScreenEvent());
    // Initialize animation controller and animation
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    // Start the animation
    _controller.forward();

    // Start the splash screen process after animation completes
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _splashBloc.add(StartSplashScreenEvent());
      }
    });
  }

  @override
  void dispose() {
    // Dispose the animation controller
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _splashBloc,
      child: BlocListener<SplashScreenBloc, SplashScreenState>(
        listener: (context, state) {
          if (state is SplashScreenCompleted) {
            Navigator.of(context).pushReplacementNamed(AppRoutes.home);
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.kBackgroundColor,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Center(
                    // Animated logo
                    child: ScaleTransition(
                      scale: _animation,
                      child: Image.asset(
                        'assets/logo/app_logo_no_background.png',
                      ),
                    ),
                  ),
                ),
                // AnimatedBuilder to show loading indicator after animation completes
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return _controller.isCompleted
                        ? const Padding(
                            padding: EdgeInsets.only(bottom: 30.0),
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Container(); // Empty container when animation is running
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

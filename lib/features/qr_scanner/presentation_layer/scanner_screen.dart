/*
 * Author: Amr Ahmed Elgazar
 * Phone: +201030691425
 * Country: Egypt
 * Email: eng.amr.elgazar@outlook.com
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fasterqr/core/widgets/custom_button.dart';
import 'package:fasterqr/features/qr_scanner/bloc/scanner_bloc.dart';

/// ScannerScreen handles the UI for QR code scanning, including initial scanning,
/// displaying scan results, and handling scan failures.
class ScannerScreen extends StatelessWidget {
  const ScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: BlocBuilder<ScannerBloc, ScannerState>(
            builder: (context, state) {
              if (state is ScannerInitial) {
                return _buildInitialContent(context);
              } else if (state is ScanSuccess) {
                return _buildScanSuccessContent(context, state.scannedValue);
              } else if (state is ScanFailure) {
                return _buildFailureContent(context, state.message);
              }
              return Container(); // Default empty container
            },
          ),
        ),
      ),
    );
  }

  /// Builds the initial content for the screen, including buttons for camera and gallery scanning.
  Widget _buildInitialContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset(
          'assets/lottie_animation/qr_scanner.json',
          fit: BoxFit.cover,
          height: MediaQuery.of(context).size.height / 2.5,
        ),
        const SizedBox(height: 35),
        Wrap(
          spacing: MediaQuery.of(context).size.width / 20,
          children: [
            CustomButton(
              label: 'Camera',
              icon: Icons.camera,
              onPressed: () {
                BlocProvider.of<ScannerBloc>(context)
                    .add(CheckCameraPermission(context));
              },
            ),
            CustomButton(
              label: 'Gallery',
              icon: Icons.image,
              onPressed: () {
                BlocProvider.of<ScannerBloc>(context).add(ScanFromImage());
              },
            ),
          ],
        ),
      ],
    );
  }

  /// Builds the content for displaying scan results, including options to copy or share the result.
  Widget _buildScanSuccessContent(BuildContext context, String scannedValue) {
    bool isUrl = Uri.tryParse(scannedValue)?.hasAbsolutePath ?? false;
    bool isEmail = scannedValue.contains('@');
    bool isPhoneNumber = RegExp(r'^\+?[1-9]\d{1,14}$').hasMatch(scannedValue);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            if (isUrl) {
              _launchUrl(scannedValue);
            } else if (isEmail) {
              _launchEmail(scannedValue);
            } else if (isPhoneNumber) {
              _launchPhone(scannedValue);
            }
          },
          child: Text(
            scannedValue,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isUrl || isEmail || isPhoneNumber
                  ? Colors.blue
                  : Colors.black,
              decoration: isUrl || isEmail || isPhoneNumber
                  ? TextDecoration.underline
                  : TextDecoration.none,
            ),
          ),
        ),
        if (isUrl || isEmail || isPhoneNumber)
          const Divider(color: Colors.blue, thickness: 2),
        const SizedBox(height: 20),
        Wrap(
          spacing: MediaQuery.of(context).size.width / 20,
          children: [
            CustomButton(
              label: 'Copy',
              icon: Icons.copy,
              onPressed: () {
                Clipboard.setData(ClipboardData(text: scannedValue));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Copied to clipboard')),
                );
              },
            ),
            CustomButton(
              label: 'Share',
              icon: Icons.share,
              onPressed: () {
                FlutterShare.share(title: 'Scan Result', text: scannedValue);
              },
            ),
          ],
        ),
        const SizedBox(height: 20),
        CustomButton(
          label: 'Scan Again',
          icon: Icons.refresh,
          onPressed: () {
            BlocProvider.of<ScannerBloc>(context).add(ScanAgain());
          },
        ),
      ],
    );
  }

  /// Builds the content for handling scan failures, including a retry button.
  Widget _buildFailureContent(BuildContext context, String message) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18, color: Colors.red),
        ),
        const SizedBox(height: 20),
        CustomButton(
          label: 'Try Again',
          icon: Icons.refresh,
          onPressed: () {
            BlocProvider.of<ScannerBloc>(context).add(ScanAgain());
          },
        ),
      ],
    );
  }

  /// Launches a URL in the default browser.
  void _launchUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  /// Launches the email client with pre-filled details.
  void _launchEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    if (await canLaunchUrl(Uri.parse(emailUri.toString()))) {
      await launchUrl(Uri.parse(emailUri.toString()));
    } else {
      throw 'Could not launch $emailUri';
    }
  }

  /// Launches the phone dialer with the given phone number.
  void _launchPhone(String phoneNumber) async {
    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(Uri.parse(phoneUri.toString()))) {
      await launchUrl(Uri.parse(phoneUri.toString()));
    } else {
      throw 'Could not launch $phoneUri';
    }
  }
}

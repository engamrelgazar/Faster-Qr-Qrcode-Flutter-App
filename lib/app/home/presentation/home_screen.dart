/*
 * Author: Amr Ahmed Elgazar
 * Phone: +201030691425
 * Country: Egypt
 * Email: eng.amr.elgazar@outlook.com
 */

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

// UI Packages
import 'package:fasterqr/core/constants/app_routes.dart';
import 'package:fasterqr/features/qr_scanner/presentation_layer/scanner_screen.dart';
import 'package:fasterqr/features/qr_creation/presentation_layer/generator_screen.dart';

/// [HomeScreen] is the main screen with tabs for scanning and generating QR codes.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () =>
                    Navigator.pushNamed(context, AppRoutes.history),
                icon: const Icon(Icons.history),
              ),
              IconButton(
                onPressed: () => _showInfoDialog(context),
                icon: const Icon(Icons.question_mark),
              ),
            ],
            title: const Text(
              'Faster QR',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
            bottom: const TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.qr_code_scanner),
                  text: 'Scan QR',
                ),
                Tab(icon: Icon(Icons.qr_code), text: 'Generate QR'),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              ScannerScreen(),
              GeneratorScreen(),
            ],
          ),
        ),
      ),
    );
  }

  /// Shows an information dialog with app details and contact options.
  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('About Faster QR'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Version: 1.0.0'),
              const Text('Release Date: July 5, 2024'),
              const SizedBox(height: 10),
              const Text(
                'Faster QR is an application for scanning and generating QR codes quickly and easily.',
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: const Icon(Icons.email),
                    onPressed: _launchEmail,
                  ),
                  IconButton(
                    icon: const Icon(FontAwesomeIcons.whatsapp),
                    onPressed: _launchWhatsApp,
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  /// Launches the email client with pre-filled details.
  void _launchEmail() async {
    String? encodeQueryParameters(Map<String, String> params) {
  return params.entries
      .map((MapEntry<String, String> e) =>
          '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
      .join('&');
}
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'eng.amr.elgazar@outlook.com',
      query: encodeQueryParameters(<String, String>{
        'subject': 'Example Subject & Symbols are allowed!',
      }),
    );
    _launchUri(emailUri);
  }

  /// Launches WhatsApp with a pre-filled message.
  void _launchWhatsApp() async {
    final Uri whatsappUri = Uri(
      scheme: 'https',
      host: 'wa.me',
      path: '/201030691425',
      queryParameters: {
        'text': 'Hello, I have a question about Faster QR app.'
      },
    );
    _launchUri(whatsappUri);
  }

  /// Helper function to launch a given URI.
  void _launchUri(Uri uri) async {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }
}

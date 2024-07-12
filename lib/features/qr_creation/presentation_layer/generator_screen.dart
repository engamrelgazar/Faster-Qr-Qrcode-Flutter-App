/*
 * Author: Amr Ahmed Elgazar
 * Phone: +201030691425
 * Country: Egypt
 * Email: eng.amr.elgazar@outlook.com
 */

import 'package:fasterqr/features/qr_creation/bloc/generate_bloc.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fasterqr/core/constants/app_colors.dart';
import 'package:fasterqr/core/widgets/custom_button.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// Screen for generating and customizing QR codes.
class GeneratorScreen extends StatefulWidget {
  const GeneratorScreen({super.key});

  @override
  _GeneratorScreenState createState() => _GeneratorScreenState();
}

class _GeneratorScreenState extends State<GeneratorScreen> {
  final TextEditingController textController = TextEditingController();
  QrEyeShape? _selectedEyeShape;
  QrDataModuleShape? _selectedDataModuleShape;
  final GlobalKey globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildQRDisplay(),
              const SizedBox(height: 25),
              _buildTextField(),
              const SizedBox(height: 25),
              _buildDropdowns(),
              const SizedBox(height: 15),
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the QR display widget based on the current state.
  Widget _buildQRDisplay() {
    return BlocBuilder<GenerateBloc, GenerateState>(
      builder: (context, state) {
        if (state is QRGenerated) {
          return RepaintBoundary(
            key: globalKey,
            child: QrImageView(
              backgroundColor: Colors.white,
              data: state.qrData,
              eyeStyle: state.eyeStyle,
              dataModuleStyle: state.dataModuleStyle,
              size: 200,
            ),
          );
        } else if (state is ImagePickedState) {
          return Image(image: state.image, height: 100);
        } else {
          return Image.asset(
            'assets/imgs/qr.png',
            fit: BoxFit.cover,
            height: MediaQuery.of(context).size.height / 4,
          );
        }
      },
    );
  }

  /// Builds the text field for inputting QR data.
  Widget _buildTextField() {
    return TextFormField(
      controller: textController,
      maxLength: 255,
      decoration: InputDecoration(
        hintText: 'Enter Data',
        border: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: AppColors.kBackgroundColor,
          ),
        ),
      ),
    );
  }

  /// Builds the dropdown buttons for selecting QR styles.
  Widget _buildDropdowns() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        DropdownButton<QrEyeShape>(
          value: _selectedEyeShape,
          items: QrEyeShape.values.map((QrEyeShape shape) {
            return DropdownMenuItem<QrEyeShape>(
              value: shape,
              child: Text(shape.toString().split('.').last),
            );
          }).toList(),
          onChanged: (QrEyeShape? newShape) {
            setState(() {
              _selectedEyeShape = newShape;
            });
          },
          hint: const Text('Eye Shape'),
        ),
        const SizedBox(height: 15),
        DropdownButton<QrDataModuleShape>(
          value: _selectedDataModuleShape,
          items: QrDataModuleShape.values.map((QrDataModuleShape shape) {
            return DropdownMenuItem<QrDataModuleShape>(
              value: shape,
              child: Text(shape.toString().split('.').last),
            );
          }).toList(),
          onChanged: (QrDataModuleShape? newShape) {
            setState(() {
              _selectedDataModuleShape = newShape;
            });
          },
          hint: const Text('Data Shape'),
        ),
      ],
    );
  }

  /// Builds the action buttons for picking an image and generating the QR code.
  Widget _buildActionButtons(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceEvenly,
      runAlignment: WrapAlignment.spaceEvenly,
      children: [
        CustomButton(
          label: 'Generate',
          icon: Icons.qr_code,
          onPressed: () {
            final QrEyeStyle eyeStyle = QrEyeStyle(
              eyeShape: _selectedEyeShape ?? QrEyeShape.square,
              color: Colors.black,
            );
            final QrDataModuleStyle dataModuleStyle = QrDataModuleStyle(
              dataModuleShape:
                  _selectedDataModuleShape ?? QrDataModuleShape.square,
              color: Colors.black,
            );

            BlocProvider.of<GenerateBloc>(context).add(
              GenerateQREvent(
                textController.text,
                eyeStyle,
                dataModuleStyle,
              ),
            );
          },
        ),
        _buildSaveButton()
      ],
    );
  }

  /// Builds the save button to save the generated QR code.
  Widget _buildSaveButton() {
    return BlocBuilder<GenerateBloc, GenerateState>(
      builder: (context, state) {
        if (state is QRGenerated) {
          return Column(
            children: [
              CustomButton(
                label: 'Save QR Code',
                icon: Icons.save,
                onPressed: () {
                  BlocProvider.of<GenerateBloc>(context)
                      .add(SaveQREvent(globalKey));
                },
              ),
              if (state is QRCodeSaved)
                const Text(
                  'QR Code saved to gallery',
                  style: TextStyle(color: Colors.green),
                ),
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }
}

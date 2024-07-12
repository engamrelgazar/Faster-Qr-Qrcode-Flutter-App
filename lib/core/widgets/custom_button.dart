import 'package:fasterqr/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final void Function()? onPressed;
  const CustomButton(
      {super.key,
      required this.label,
      required this.icon,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          iconColor: Colors.white,
          backgroundColor: AppColors.kBackgroundColor,
        ),
        label: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(label,
              style: const TextStyle(color: Colors.white, fontSize: 20)),
        ),
        icon: Icon(icon),
      ),
    );
  }
}

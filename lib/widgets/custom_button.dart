import 'package:factory_organizer_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Color? backgroundColor;
  final Color? textColor;
  final String text;
  final VoidCallback onPressed;
  final double? textSize;

  const CustomButton(
      {Key? key,
      required this.text,
      required this.onPressed,
      this.backgroundColor,
      this.textColor = Colors.white,this.textSize=16.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          primary: backgroundColor,
        ),
        onPressed: onPressed,
        child: CustomText(
          text: text,
          color: textColor,
          size: textSize,
          weight: FontWeight.w800,
        ));
  }
}

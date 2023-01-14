import 'package:factory_organizer_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class BackgroundedText extends StatelessWidget {

  final String text;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final double? textSize;


   const BackgroundedText({Key? key, required this.text, this.onTap, this.backgroundColor,this.textSize=16.0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        margin: const EdgeInsets.all(6),
        padding:const EdgeInsets.symmetric(vertical: 6,horizontal: 16),
        decoration: BoxDecoration(
          color: backgroundColor??Colors.grey[800],
          borderRadius: BorderRadius.circular(10),

        ),
        child: CustomText(text: text,size: textSize,color: Colors.white,weight: FontWeight.w800,),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAlertDialog extends StatelessWidget {

  final  String title;
  final String message;
  final VoidCallback onSubmit;
  Widget? content;


  CustomAlertDialog({Key? key,  required this.title,required this.message,required this.onSubmit,this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      
      height: Get.height*0.35,
      width: Get.width*0.75,

      child: AlertDialog(
        contentPadding: const EdgeInsets.all(8),
        actionsPadding: const EdgeInsets.all(8),
        title: Text(title),content:content ?? Text(message , style: GoogleFonts.abel(),maxLines: 3,),
      actions: [
        GestureDetector(
            onTap: onSubmit,
            child: Text('تأكيد',style: GoogleFonts.abel(fontWeight: FontWeight.w700,color: Colors.green[700],fontSize: 17.0))),
        const SizedBox(width: 16,),
        GestureDetector(
            onTap:(){ Get.back();},
            child: Text('إلغاء',style: GoogleFonts.abel(fontWeight: FontWeight.w700,color: Colors.grey[800],fontSize: 17.0)))
      ],
      ),
    );
  }
}

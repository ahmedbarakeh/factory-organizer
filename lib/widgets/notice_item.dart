import 'package:factory_organizer_app/controller/home_controller.dart';
import 'package:factory_organizer_app/models/customer_model.dart';
import 'package:factory_organizer_app/models/notice_model.dart';
import 'package:factory_organizer_app/utils/constants.dart';
import 'package:factory_organizer_app/widgets/alert_dialog.dart';
import 'package:factory_organizer_app/widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class NoticeItem extends StatelessWidget {

  final NoticeModel notice;
  final HomeController _homeController = Get.find();


  NoticeItem({Key? key, required this.notice}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(

      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15)
      ),
      height: Get.height*0.175,
      width: Get.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor:appColors[Random().nextInt(appColors.length)] ,
                radius: 35,
                child:  CustomText(text: notice.title,weight: FontWeight.bold,color: Colors.white,size: 20.0,),
              ),
              const SizedBox(width: 16,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                   mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(notice.noticeText!,style: GoogleFonts.abel(fontWeight: FontWeight.bold,color: Colors.grey[800],fontSize: 14.0),maxLines: 5,),
                    const SizedBox(height: 16,),
                    Row(
                      children: [
                        Text(notice.noticeDate!,style: GoogleFonts.abel(fontWeight: FontWeight.bold,color: Colors.grey[600],fontSize: 17.0),),
                        const Spacer(),
                        GestureDetector(
                          onTap: (){

                            showDialog(context: context, builder: (ctx){
                              return CustomAlertDialog(title: 'حذف ملاحظة', message: "هل أنت متأكد من الحذف " ,onSubmit:  (){
                               _homeController.deleteNotice(id: notice.id!);
                               Get.back();
                               _homeController.loadNotices();
                              });
                            });
                          },
                            child: Text('حذف',style: GoogleFonts.acme(color: Colors.red,fontWeight: FontWeight.w700,fontSize: 16.0),)),
                        const SizedBox(width: 18,),

                      ],
                    ),

                  ],
                ),
              )

            ],
          ),
          const SizedBox(height: 8,),
          const Divider(),
        ],
      ),

    );
  }
}

import 'package:factory_organizer_app/controller/app_controller.dart';
import 'package:factory_organizer_app/controller/home_controller.dart';
import 'package:factory_organizer_app/models/notice_model.dart';
import 'package:factory_organizer_app/widgets/custom_text.dart';
import 'package:factory_organizer_app/widgets/notice_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../utils/constants.dart';
import '../widgets/alert_dialog.dart';

class NoticesScreen extends StatelessWidget {
   NoticesScreen({Key? key}) {
     _homeController.loadNotices();
   }

  final HomeController _homeController = Get.find();
  final AppController _appController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ملاحظاتي'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Obx(()=>_homeController.noticesLoaded.isTrue
          ? _homeController.notices.value.isEmpty
           ? const Center(child: CustomText(text: 'لا يوجد ملاحظات',size: 22.0,weight: FontWeight.bold,),)
           : ListView.builder(itemCount: _homeController.notices.value.length,itemBuilder: (ctx,index){
             return NoticeItem(notice: _homeController.notices.value[index]);
      },)
          :Center(child: const CircularProgressIndicator())),
      floatingActionButton:  FloatingActionButton(

        backgroundColor: appColors[_appController.appColorIndex],
        onPressed: (){
          var typeIndex=0.obs;
          showDialog(context: context, builder: (ctx){
            final newFormKey=GlobalKey<FormState>();
            final noticeTextController = TextEditingController();
            final noticeTitleController = TextEditingController();
            return CustomAlertDialog(title: 'جديد', message: '',
                content:SizedBox(
                  height: Get.height*0.3,
                  child: Form(
                    key: newFormKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: noticeTextController,
                          maxLength: 45,
                          maxLines: 3,
                          validator: (v){
                            if(v!.isEmpty)  return 'هذا الحقل لا يجب أن يكون فارغ';
                            return null;
                          },
                          decoration: const InputDecoration(
                            hintText: 'أدخل ملاحظتك ',
                          ),
                        ),
                        const SizedBox(height: 10,),
                        TextFormField(
                          controller: noticeTitleController,
                          validator: (v){
                            if(v!.isEmpty)  return 'هذا الحقل لا يجب أن يكون فارغ';
                            if(v.length>=5) return 'عدد الحروف يجب ان يكون 5 حروف او اقل';
                            return null;
                          },
                          maxLength: 5,
                          decoration: const InputDecoration(
                            hintText: 'أدخل عنوان الملاحظة ',
                          ),
                        ),
                        const SizedBox(height: 16,),
                      ],
                    ),
                  ),
                ),
                onSubmit: (){
                  newFormKey.currentState!.save();
                  final valid = newFormKey.currentState!.validate();

                  if(valid){
                    _homeController.addNewNotice(NoticeModel(title: noticeTitleController.text, noticeText: noticeTextController.text, noticeDate:  DateFormat("yyyy-MM-dd").format(DateTime.parse(DateTime.now().toString()))));
                    _homeController.loadNotices();
                    Get.back();
                  }

                });
          });


        },
        child:  const CustomText(text: '+',weight: FontWeight.bold,size: 28.0,
          color: Colors.white,),
      ),
    );
  }

}

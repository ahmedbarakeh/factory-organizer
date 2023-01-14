import 'package:factory_organizer_app/controller/app_controller.dart';
import 'package:factory_organizer_app/controller/home_controller.dart';
import 'package:factory_organizer_app/widgets/alert_dialog.dart';
import 'package:factory_organizer_app/widgets/history_item.dart';
import 'package:factory_organizer_app/utils/constants.dart';
import 'package:factory_organizer_app/widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HistoryScreen extends StatelessWidget {

  final AppController _appController = Get.find();
  final HomeController _homeController =Get.find();

  var showingDeleteIcon=false.obs;


  @override
  Widget build(BuildContext context) {
    _homeController.loadHistory();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: InkWell(
              onTap: (){

              },
                child: Icon(Icons.sort)),
          )
        ],
        backgroundColor: appColors[_appController.appColorIndex],
        title: const CustomText(text: 'سجل التخزين',size: 18.0,weight: FontWeight.bold,color: Colors.white,),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 2),
        child: SizedBox(
          height: Get.height*0.99,
          child: Obx(()=>_homeController.historyItemsLoaded.isTrue
              ? _homeController.historyStoreList.value.isEmpty
              ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                  Icon(Icons.history,size: 120,color: appColors[_appController.appColorIndex],),
                  SizedBox(height: 24,),
                  CustomText(text: 'سجل التخزين فارغ',weight: FontWeight.bold,size: 20.0,color: Colors.red,)
            ],
          ),
                ],
              )
              : ListView.builder(
              itemCount: _homeController.historyStoreList.value.length,
              itemBuilder: (ctx,index){
                return HistoryItem(
                    item: _homeController.historyStoreList.value[index]);
              })
              :const Center(child:  CircularProgressIndicator()),),
        ),
      ),
    );
  }
}

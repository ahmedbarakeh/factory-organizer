import 'dart:math';

import 'package:factory_organizer_app/controller/app_controller.dart';
import 'package:factory_organizer_app/models/store_model.dart';
import 'package:factory_organizer_app/screens/navigation_screen.dart';
import 'package:factory_organizer_app/screens/store_construction_startup_screen.dart';
import 'package:factory_organizer_app/utils/constants.dart';
import 'package:factory_organizer_app/widgets/backgrounded_text.dart';
import 'package:factory_organizer_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SettingsScreen extends StatelessWidget {
  
  SettingsScreen(){
    _appController.loadStores();
  }

  final AppController _appController=Get.find();


  
  @override
  Widget build(BuildContext context) {
    final stId= _appController.currentStoreId.value;
    return Scaffold(
      appBar: AppBar(
        title: Text('الاعدادات'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: InkWell(
              onTap: (){
                Get.offAll(StoreConstructionScreen());
              },
                child: Icon(Icons.add)),
          )
        ],
        centerTitle: true,
          backgroundColor: appColors[_appController.appColorIndex]
      ),
      body: Container(
        height: Get.height,
        padding: EdgeInsets.symmetric(vertical: 16,horizontal: 24),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Image.asset('assets/images/storehouse.png',height: 50,width: 50,),
                Spacer(),
                CustomText(text: 'المخزن الحالي : ${_appController.getStoreNameById(id: stId)}',weight: FontWeight.bold,size: 21.0,color: Colors.grey[800],),
                Spacer(),

              ],
            ),
            Expanded(child: Obx(()=>_appController.storeLoaded.isTrue
                ?ListView.builder(
                itemCount: _appController.stores.value.length,
                itemBuilder: (ctx,index){
                  return StoreItem(_appController.stores.value[index]);
                })
                :CircularProgressIndicator()))
          ],
        ),
      ),
    );
  }
  Widget StoreItem(StoreModel store){
    return InkWell(
      onTap: (){
        _appController.writeSetting(name: 'storeId', value: store.id);
        _appController.currentPageIndex(0);
        _appController.currentStoreId(store.id);
        Get.offAll(NavigationScreen());

      },
      child: Container(
        width: Get.width*0.45,
        height: Get.width*0.45,
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: appColors[Random().nextInt(appColors.length)]
        ),
        child: Center(
          child: CustomText(
            text: store.name!,
            color: Colors.white,
            weight: FontWeight.bold,
            size: 18.0,

          ),
        ),
      ),
    );
  }
}

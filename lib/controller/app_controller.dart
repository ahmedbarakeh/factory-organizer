import 'package:factory_organizer_app/models/square_model.dart';
import 'package:factory_organizer_app/models/store_model.dart';
import 'package:factory_organizer_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';

import '../data/sqllife_db.dart';

class AppController extends GetxController{

  var currentPageIndex=0.obs;
  int appColorIndex=Random().nextInt(appColors.length);
  final db=FactoryOrganizerDb.instance;
  var storeLoaded=false.obs;
  var stores=Rx<List<StoreModel>>([]);
  var currentStoreId=1.obs;

  @override
  void onInit() async {
    final id=await readSetting(name: 'storeId');
    currentStoreId(int.parse(id.toString()));
    super.onInit();
  }

  Future setupSquaresMap(SquareModel square)async{
    print(square.toJson());
   final res= await db.insertSquareData(square);
   print(res);
  }
  Future<int> addNewStore({required String name})async{
    final id=  await db.insertStore(name: name);
    writeSetting(name: 'storeId', value: id);
    currentStoreId(id);
    return id;
  }

  Future loadStores()async{
    storeLoaded(false);
    final res=await db.getStores();
    final List<StoreModel> list=[];
    for (var item in res!) {
      list.add(StoreModel.fromJson(item));
    }
    stores(list);
    storeLoaded(true);
  }
  Future <dynamic> readSetting({required String name})async{
    return await db.readSettingValueByName(name: name);
  }
  writeSetting({required String name,required  value})async{
     db.writeAppSetting(name: name,value: value);
  }

  String? getStoreNameById({required int id}){
    String? t;
    if(storeLoaded.isTrue){
      stores.value.forEach((element) {
        if(id==element.id) {
          t= element.name!;
        }
      });
    }
    return t;
  }


}
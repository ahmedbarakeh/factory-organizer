import 'dart:convert';

import 'package:factory_organizer_app/controller/app_controller.dart';
import 'package:factory_organizer_app/models/square_model.dart';
import 'package:factory_organizer_app/screens/navigation_screen.dart';
import 'package:factory_organizer_app/widgets/alert_dialog.dart';
import 'package:factory_organizer_app/widgets/custom_button.dart';
import 'package:factory_organizer_app/widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';

import '../utils/constants.dart';


class StoreConstructionScreen extends StatelessWidget {

  var selectedIndexes=Rx<List<int>>([]);
  final AppController _appController = Get.find();
  var isStoreBuilding=false.obs;
  var isStoreSaved=false.obs;

  StoreConstructionScreen({Key? key}) : super(key: key){

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[300],
        title: const Text('قم بتشييد مخزنك'),
        centerTitle: true,
        leading: GestureDetector(
            onTap: (){
              TextEditingController storeNameController=TextEditingController();
              final  storeKey=GlobalKey<FormState>();
              showDialog(context: context, builder: (ctx){
                return CustomAlertDialog(title: ' اسم المخزن', message: '',content: Form(
                  key: storeKey,
                  child: TextFormField(
                    validator: (val){
                      if(val!.isEmpty) return 'هذا الحقل يجب الا يكون فارغا';
                      return null;
                    },
                    maxLength: 15,
                    controller: storeNameController,
                    decoration: const InputDecoration(hintText: 'أدخل  اسم المخزن'),
                  ),
                ), onSubmit: ()async{

                  storeKey.currentState!.save();
                final res= storeKey.currentState!.validate();
                if(!res){
                  return;
                }
                  // first of all add new store
                  final storeId=await  _appController.addNewStore(name: storeNameController.text);
                  _appController.writeSetting(name: 'storeId', value: storeId);

                  final List<SquareIndex> list=[];
                  selectedIndexes.value.forEach((element) {
                    list.add(SquareIndex(mapIndex: element,));
                  });

                  selectedIndexes.value.forEach((element) {
                    _appController.setupSquaresMap(SquareModel(index: element,storeId: storeId));
                  });
                  selectedIndexes([]);
                  isStoreSaved(true);

                  Get.back();

                });
              });


            },
            child: const Icon(Icons.save)),
        actions: [
          GestureDetector(
            onTap: (){
              selectedIndexes.update((val) {
                if(selectedIndexes.value.isNotEmpty)
                selectedIndexes.value.removeAt(selectedIndexes.value.length-1);

              });
            },
              child: Image.asset('assets/images/undo.png'))
        ],
        elevation: 0,
      ),

      body: Column(
        children: [
          Expanded(
            child: Obx(()=>isStoreBuilding.value
                ? buildingProcessIsLoading()
                :GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 48,gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 76,
              crossAxisSpacing: 0,
              mainAxisSpacing:0,
              mainAxisExtent: 76,
            ), itemBuilder: (ctx,index){
              return  GestureDetector(
                  onTap: (){
                    selectedIndexes.update((val) {
                      selectedIndexes.value.add(index);
                    });

                  },
                  child: Obx(()=>Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color:selectedIndexes.value.contains(index)?Colors.grey:Colors.grey[200],
                    ),
                    child:selectedIndexes.value.contains(index)? const CustomText( size: 35.0,color: Colors.red, text: 'X',):const SizedBox(width: 0,),
                  ),)
              );

            },
            ),),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 18.0),
            child:Obx(()=>isStoreSaved.isTrue&&isStoreBuilding.isFalse? CustomButton(
                text: 'حفظ الكل و متابعة',backgroundColor: Colors.red, onPressed: (){
              // _appController.setupSquaresMap(SquareModel(index: -1,));
              isStoreBuilding.update((val) {
                isStoreBuilding.value=true;
              });
              Future.delayed(const Duration(seconds: 5),(){
                Get.off(()=>NavigationScreen());
              });
            }):const SizedBox()),
          )
        ],
      )
    );
  }
  Widget buildingProcessIsLoading(){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 65),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/construction2.png',),
            const Spacer(),
            const CustomText(text: 'جارٍ بناء مخزنك .. الرجاء الانتظار لحظة',maxLines: 2,size: 18.0,color: Colors.black45,weight: FontWeight.bold,),
            const SizedBox(height: 16,),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

import 'package:factory_organizer_app/controller/app_controller.dart';
import 'package:factory_organizer_app/controller/home_controller.dart';
import 'package:factory_organizer_app/models/item_model.dart';
import 'package:factory_organizer_app/widgets/alert_dialog.dart';
import 'package:factory_organizer_app/widgets/custom_text.dart';
import 'package:factory_organizer_app/widgets/item_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/unit_model.dart';
import '../utils/constants.dart';
import '../widgets/backgrounded_text.dart';

class ItemsScreen extends StatelessWidget {
  final HomeController _homeController = Get.find();
  final AppController _appController = Get.find();

  ItemsScreen({Key? key}) : super(key: key){
    _homeController.loadExternalItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appColors[_appController.appColorIndex],
        elevation: 0,
        title: Text(
          'Items',
          style: GoogleFonts.actor(fontWeight: FontWeight.bold, fontSize: 19.0),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(()=>_homeController.externalItemsLoaded.value
                ?_homeController.externalItems.value.isEmpty
                ?Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    const Icon(Icons.category_outlined,size: 120,color: Colors.red,),
                    const SizedBox(height: 24,),
                    const CustomText(text: 'لا يوجد مواد',size: 20.0,color: Colors.red,weight: FontWeight.bold,)
                  ],
                )
              ],
            )
                : Expanded(
              child: ListView.builder(
                itemCount: _homeController.externalItems.value.length,
                itemBuilder: (ctx, index) {
                  return ItemView(item: _homeController.externalItems.value[index]);

                },
              ),)
                :const Center(child: CircularProgressIndicator(),)
            )
          ],
        ),
      ),
      floatingActionButton: Container(
        height: 65,
        width: 65,
        margin:const EdgeInsets.all(28),
        child: FloatingActionButton(
          
          backgroundColor: appColors[_appController.appColorIndex],
          onPressed: (){
            var typeIndex=0.obs;
            showDialog(context: context, builder: (ctx){
              final newFormKey=GlobalKey<FormState>();
              final addController = TextEditingController();
              return CustomAlertDialog(title: 'جديد', message: '',
                  content:SizedBox(
                    height: Get.height*0.25,
                    child: Form(
                      key: newFormKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: addController,
                            validator: (v){
                              if(v!.isEmpty)  return 'هذا الحقل لا يجب أن يكون فارغ';
                              return null;
                            },
                            decoration: const InputDecoration(
                              hintText: 'أدخل الاسم ',
                            ),
                          ),
                          const SizedBox(height: 16,),
                          Obx(()=>Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Image.asset(unitTypeImages[0],height: 45,width: 45,),
                                  const SizedBox(height: 4,),
                                  BackgroundedText(text: 'Carton',textSize: 15.0,backgroundColor:typeIndex.value==0?Colors.orange:Colors.grey[300] ,onTap: (){
                                    typeIndex(0);
                                  },),
                                ],
                              ),
                              const SizedBox(width: 18,),
                              Column(
                                children: [
                                  Image.asset(unitTypeImages[1],height: 45,width: 45,),
                                  const SizedBox(height: 4,),
                                  BackgroundedText(text: 'Case',textSize: 15.0,backgroundColor:typeIndex.value==1?Colors.orange:Colors.grey[300] ,onTap: (){
                                    typeIndex(1);
                                  },),
                                ],
                              )
                            ],
                          ),),
                        ],
                      ),
                    ),
                  ),
                  onSubmit: (){
                    _homeController.addNewItem(ItemCustomerModel(
                      name: addController.text,
                      unit: UnitModel(
                        typeIndex: typeIndex.value,
                      )
                    ));
                    Get.back();
                    _homeController.loadExternalItems();
                  });
            });


          },
          child:  const CustomText(text: '+',weight: FontWeight.bold,size: 28.0,
            color: Colors.white,),
        ),
      ),
    );
  }
}

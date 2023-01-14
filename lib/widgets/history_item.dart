import 'dart:math';

import 'package:factory_organizer_app/controller/home_controller.dart';
import 'package:factory_organizer_app/models/item_model.dart';
import 'package:factory_organizer_app/screens/history/history_details_screen.dart';
import 'package:factory_organizer_app/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/constants.dart';
import 'alert_dialog.dart';
import 'custom_text.dart';

class HistoryItem extends StatelessWidget {

  final ItemCustomerModel item;
  final HomeController _homeController = Get.find();

  var showHistoryDetail=false.obs;

  HistoryItem({required this.item});

  @override
  Widget build(BuildContext context) {
    String? customerName='';
    String? itemName='';

    if(_homeController.externalItemsLoaded.isTrue&&
       _homeController.customersLoaded.isTrue){
      print('line 30 customerId ${item.customerId!}  externalItemId  ${item.externalItemId!}');
      customerName=_homeController.isCustomerExist(id: item.customerId!)
          ? _homeController.getCustomerById(id: item.customerId!)!.name!
          : item.customer!.name;

      itemName=_homeController.isItemExist(id: item.externalItemId!)
          ? _homeController.getExternalItemById(id: item.externalItemId!)!.name!
          : item.name;
    }

final isItemInStore=_homeController.isItemInStore(id: item.externalItemId!);
    return InkWell(
      onTap: (){
        showHistoryDetail(!showHistoryDetail.value);
      },
      onLongPress: (){
        showDialog(context: context, builder: (tx){
          return isItemInStore
              ?CustomAlertDialog(title: 'تحذير', message: '',content: SizedBox(
            height: Get.height*0.15,
                child: Column(
             children: const [
                 Icon(Icons.warning_amber_rounded,color: Colors.red,size: 65,),
                 SizedBox(height: 16,),
                 CustomText(text: 'لا يمكن حذف هذا العنصر لوجوده في المخزن',maxLines: 2,weight: FontWeight.bold,size: 16.0,),
             ],
          ),
              ), onSubmit: (){Get.back();})
              :  CustomAlertDialog(title: 'حذف', message: "هل تريد حذف هذا العنصر من السجل ؟", onSubmit: ()async{
            await _homeController.deleteItemFromHistory(id: item.id!);
            Get.back();
           await _homeController.loadHistory();

          });
        });
      },
      child: Container(
        width: Get.width,
        padding: const EdgeInsets.symmetric(horizontal: 6,vertical: 6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor:appColors[Random().nextInt(appColors.length)] ,
                  radius: 35,
                  child:  CustomText(text:customerName!.substring(0,2),weight: FontWeight.bold,color: Colors.white,size: 20.0,),
                ),
                const SizedBox(width: 12,),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(customerName,style: GoogleFonts.abel(fontWeight: FontWeight.bold,color: Colors.grey[800],fontSize: 20.0),),
                          Row(
                            children: [
                              const Icon(Icons.arrow_circle_down_rounded,size: 22,color: Colors.green,),
                              const SizedBox(width: 1,),
                              Text(item.insertDate!),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(itemName!,style: GoogleFonts.abel(fontWeight: FontWeight.bold,color: Colors.black54,fontSize: 16.0),),
                          isItemInStore
                          ?Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: const [Icon(Icons.done,size: 22,color: Colors.green,),CustomText(text: 'في المخزن',color: Colors.green,weight: FontWeight.w800,size: 14.0,)],)
                         : Row(
                            children: [
                              const Icon(Icons.arrow_circle_up,size: 22,color: Colors.red,),
                              const SizedBox(width: 1,),
                              Text(item.outDate!),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 3,),
                      CustomText(text: '${item.originalQnt} x ${item.unit!.weight!} = ${Utility.getSeparatedNumber('${item.originalQnt! * item.unit!.weight!}')}',size: 13.0,),
                      const SizedBox(height: 2,),
                      Row(
                        children: [
                          CustomText(text: '${item.qnt} x ${item.unit!.weight!} = ${Utility.getSeparatedNumber('${item.qnt! * item.unit!.weight!}')}',size: 12.0,),
                          const SizedBox(width: 4,),
                          const CustomText(text: " باقي ",color: Colors.black54,size: 12.0,),
                          const Spacer(),
                          GestureDetector(
                              onTap: (){
                                showHistoryDetail(!showHistoryDetail.value);
                              },
                              child:  Obx(()=>showHistoryDetail.isFalse
                              ? const Icon(Icons.expand_more,size: 30)
                              :const Icon(Icons.expand_less,size: 30))),
                          const SizedBox(width: 12,),
                        ],
                      )

                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4,),
            Obx(()=>AnimatedContainer(duration: const Duration(milliseconds: 250),
            height: showHistoryDetail.isTrue
              ? Get.height*0.5
              :0,
              padding:const EdgeInsets.all(8),
              child:showHistoryDetail.isTrue?  HistoryDetailScreen(itemId: item.id!,):SizedBox(height: 0,),
            )),
            const Divider(),
          ],
        ),
      ),
    );
  }
}

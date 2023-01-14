import 'package:factory_organizer_app/controller/home_controller.dart';
import 'package:factory_organizer_app/models/item_model.dart';
import 'package:factory_organizer_app/utils/utility.dart';
import 'package:factory_organizer_app/widgets/alert_dialog.dart';
import 'package:factory_organizer_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HistoryDetailScreen extends StatelessWidget {

  final int itemId;
  final HomeController _homeController = Get.find();


  HistoryDetailScreen({required this.itemId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ItemCustomerModel>>(
        future: _homeController.getItemHistoryDetail(itemId: itemId),
        builder: (ctx,snap){
          final data = snap.data;


          if(data!=null){
            if(!data.isBlank!){
              return Container(width: Get.width*0.95,
                padding: const EdgeInsets.symmetric(horizontal: 6,vertical: 12),
                child: ListView.builder(itemCount: data.length,itemBuilder: (ctx,index){
                  final isItemInStore=_homeController.isItemInStore(id: data[index].externalItemId!);
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 2),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    height: Get.height*0.111,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(text: '${data[index].popedQnt} x ${data[index].unit!.weight!}',size: 14.0,weight: FontWeight.w600,),
                            Row(
                              children: [
                                const Icon(Icons.arrow_circle_up,size: 22,color: Colors.red,),
                                const SizedBox(width: 1,),
                                CustomText(text: '${data[index].outDate}',size: 14.0,weight: FontWeight.w600,color: Colors.red,),
                              ],
                            ),

                          ],
                        ),
                        const SizedBox(height: 4,),
                        Row(
                          children: [
                            CustomText(text: Utility.getSeparatedNumber('${data[index].popedQnt! * data[index].unit!.weight!}'),size: 14.0,weight: FontWeight.w600,),
                            const Spacer(),
                           if(isItemInStore) InkWell(
                             onTap: (){
                               showDialog(context: context, builder: (ctx){
                                 return CustomAlertDialog(title: 'إرجاع', message: "هل تريد استعادة هذا العنصر ؟", onSubmit: (){
                                   final restoredItem=data[index];
                                   final currentId=data[index].id;
                                   restoredItem.id=data[index].popedItemId;
                                   restoredItem.qnt=restoredItem.qnt! +data[index].popedQnt!;
                                   restoredItem.popedItemId=0;


                                   _homeController.updateItem(restoredItem);
                                   _homeController.deleteItem(id: currentId!);
                                   _homeController.loadInternalItems();
                                   _homeController.loadHistory();
                                   Get.back();
                                   print('restoredItem new id = '+restoredItem.id.toString());
                                   print('restoredItem poped id = '+restoredItem.popedItemId.toString());

                                 });
                               });
                             },
                               child: const Icon(Icons.delete,color: Colors.grey,)),
                            const SizedBox(width: 40,),

                          ],
                        ),
                        SizedBox(height: 2,),
                        Row(
                          children: [
                            Icon(Icons.arrow_forward,color: Colors.red,size: 20,),
                            SizedBox(width: 8,),
                            CustomText(text: _homeController.getCustomerById(id: data[index].popedCustomerId!)!.name,color: Colors.grey[700],)
                          ],
                        ),
                      ],
                    ),
                  );
                })
                ,);
            }
            else{
              return const Text('لا يوجد سحوبات لهذا العنصر !');
            }
          }
          return const Text('خطأ');
        });
  }
}

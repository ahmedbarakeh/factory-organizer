import 'package:factory_organizer_app/controller/home_controller.dart';
import 'package:factory_organizer_app/utils/constants.dart';
import 'package:factory_organizer_app/utils/utility.dart';
import 'package:factory_organizer_app/widgets/alert_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/item_model.dart';

class ItemView extends StatelessWidget {

  final ItemCustomerModel item;
  final HomeController _homeController = Get.find();


  ItemView({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15)
      ),
      height: Get.height*0.15,
      width: Get.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey[300],
                radius: 35,
                child: Image.asset(unitTypeImages[item.unit!.typeIndex!],width: 35,height: 35,),
              ),
              const SizedBox(width: 16,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(item.name!,style: GoogleFonts.abel(fontWeight: FontWeight.bold,color: Colors.grey[800],fontSize: 18.0),),
                    const SizedBox(height: 16,),
                    Row(
                      children: [
                        Text(Utility.getSeparatedNumber(_homeController.getTotalQntOfItem(id: item.id!).toString()),style: GoogleFonts.abel(fontWeight: FontWeight.bold,color: Colors.grey[600],fontSize: 17.0),),
                        const Spacer(),
                        GestureDetector(
                            onTap: (){
                              final isInStore=_homeController.isItemInStore(id: item.id!);

                              showDialog(context: context, builder: (ctx){
                                return isInStore
                                    ?CustomAlertDialog(title: 'تحذير',message: '', content: SizedBox(
                                  height: Get.height*0.2,
                                   child: Column(
                                    children: [
                                      const Icon(Icons.warning,color: Colors.red,size: 40,),
                                      const SizedBox(height: 24,),
                                      Text('لا يمكن حذف هذه المادة لوجودها في المخزن ',style: GoogleFonts.abel(fontWeight: FontWeight.w700),)
                                    ],
                                  ),
                                ) ,onSubmit:  (){})
                                    : CustomAlertDialog(title: 'حذف مادة', message: "هل أنت متأكد من حذف " + item.name! ,onSubmit:  (){
                                  _homeController.deleteItem(id: item.id!);
                                  Get.back();
                                  _homeController.loadExternalItems();
                                });
                              });
                            },
                            child: Text('حذف',style: GoogleFonts.acme(color: Colors.red,fontWeight: FontWeight.w700,fontSize: 16.0),)),
                        const SizedBox(width: 18,),
                        GestureDetector(
                            onTap: (){
                              final editFormKey=GlobalKey<FormState>();
                              final editController=TextEditingController();

                              showDialog(context: context, builder: (ctx){
                                return CustomAlertDialog(title: 'تعديل مادة', message: '',onSubmit:  (){
                                  editFormKey.currentState!.save();
                                  bool valid=editFormKey.currentState!.validate();

                                  if(valid){
                                    _homeController.updateItem(ItemCustomerModel(
                                      width: item.width,
                                      name: editController.text,
                                      id: item.id,
                                      placeIndex: item.placeIndex,
                                      qnt: item.qnt,
                                      customer: item.customer,
                                      unit: item.unit,
                                      height: item.height,
                                      insertDate: item.insertDate,
                                      outDate: item.outDate,
                                    ));
                                    _homeController.loadExternalItems();
                                    Get.back();
                                  }
                                },
                                  content: Form(
                                    key: editFormKey,
                                    child: TextFormField(
                                      controller: editController,
                                      validator: (v){
                                        if(v!.isEmpty)  return 'هذا الحقل لا يجب أن يكون فارغ';
                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                        hintText: 'أدخل الاسم الجديد',
                                      ),
                                    ),
                                  ),);
                              });
                            },
                            child: Text('تعديل',style: GoogleFonts.acme(color: Colors.black54,fontWeight: FontWeight.w700,fontSize: 16.0),)),
                        const SizedBox(width: 12,),

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

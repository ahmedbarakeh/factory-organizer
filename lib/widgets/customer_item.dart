import 'package:factory_organizer_app/controller/home_controller.dart';
import 'package:factory_organizer_app/models/customer_model.dart';
import 'package:factory_organizer_app/screens/customer_details_screen.dart';
import 'package:factory_organizer_app/utils/constants.dart';
import 'package:factory_organizer_app/widgets/alert_dialog.dart';
import 'package:factory_organizer_app/widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomerItem extends StatelessWidget {

  final CustomerModel customer;
  final HomeController _homeController = Get.find();


  CustomerItem({Key? key, required this.customer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Get.to(()=>CustomerDetailsScreen(customerName: customer.name!, customerId: customer.id!));
      },
      child: Container(
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
                  backgroundColor:appColors[Random().nextInt(appColors.length)] ,
                  radius: 35,
                  child:  CustomText(text: customer.name!.substring(0,2),weight: FontWeight.bold,color: Colors.white,size: 20.0,),
                ),
                const SizedBox(width: 16,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                     mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(customer.name!,style: GoogleFonts.abel(fontWeight: FontWeight.bold,color: Colors.grey[800],fontSize: 18.0),),
                      const SizedBox(height: 16,),
                      Row(
                        children: [
                          Text(customer.phone!,style: GoogleFonts.abel(fontWeight: FontWeight.bold,color: Colors.grey[600],fontSize: 17.0),),
                          const Spacer(),
                          GestureDetector(
                            onTap: (){

                             final hasItems= _homeController.isCustomerHasItems(id: customer.id!);

                              showDialog(context: context, builder: (ctx){
                                return hasItems
                                    ? CustomAlertDialog(title: 'تحذير',message: '', content: SizedBox(
                                  height: Get.height*0.2,
                                      child: Column(
                                      children: [
                                        const Icon(Icons.warning,color: Colors.red,size: 40,),
                                        const SizedBox(height: 24,),
                                        Text('لا يمكن حذف هذا العنصر لأنه يمتلك مواد ',style: GoogleFonts.abel(fontWeight: FontWeight.w700),)
                                      ],
                                ),
                                    ) ,onSubmit:  (){})
                                    : CustomAlertDialog(title: 'حذف مستخدم', message: "هل أنت متأكد من حذف " + customer.name! ,onSubmit:  (){
                                 _homeController.deleteCustomer(id: customer.id!);
                                 Get.back();
                                 _homeController.loadCustomers();
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
                                  return CustomAlertDialog(title: 'تعديل مستخدم', message: '',onSubmit:  (){
                                    editFormKey.currentState!.save();
                                    bool valid=editFormKey.currentState!.validate();

                                    if(valid){
                                      _homeController.editCustomer(CustomerModel(
                                        name: editController.text,
                                        id: customer.id,
                                        phone: customer.phone,
                                      ));
                                      _homeController.loadCustomers();
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

      ),
    );
  }
}

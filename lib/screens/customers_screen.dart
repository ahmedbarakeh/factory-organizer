import 'package:factory_organizer_app/controller/app_controller.dart';
import 'package:factory_organizer_app/controller/home_controller.dart';
import 'package:factory_organizer_app/models/customer_model.dart';
import 'package:factory_organizer_app/widgets/alert_dialog.dart';
import 'package:factory_organizer_app/widgets/custom_text.dart';
import 'package:factory_organizer_app/widgets/customer_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/constants.dart';

class CustomersScreen extends StatelessWidget {
  final HomeController _homeController = Get.find();
  final AppController _appController =Get.find();

  CustomersScreen({Key? key}) : super(key: key){
    _homeController.loadCustomers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appColors[_appController.appColorIndex],
        elevation: 0,
        title: Text(
          'Customers',
          style: GoogleFonts.actor(fontWeight: FontWeight.bold, fontSize: 19.0),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Obx(()=>_homeController.customersLoaded.value
                ?_homeController.customers.value.isEmpty
                ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                     children: const [
                       Icon(Icons.no_accounts_rounded,color: Colors.red,size: 120,),
                       SizedBox(height: 24,),
                       CustomText(text: 'لا يوجد عملاء',size: 20.0,weight: FontWeight.bold,color: Colors.red,)
                     ],
            ),
                  ],
                )
                : Expanded(
                child: ListView.builder(
                itemCount: _homeController.customers.value.length,
                itemBuilder: (ctx, index) {
                  return CustomerItem(customer: _homeController.customers.value[index]);

                },
              ),)
            :const Center(child: CircularProgressIndicator(),)
            )
          ],
        ),
      ),
      floatingActionButton: Container(
        height: 122,
        width: 122,
        padding: const EdgeInsets.all(28.0),
        child: FloatingActionButton(
          backgroundColor: appColors[_appController.appColorIndex],
          onPressed: (){
            showDialog(context: context, builder: (ctx){
              final newFormKey=GlobalKey<FormState>();
              final addController = TextEditingController();
              return CustomAlertDialog(title: 'جديد', message: '',
                  content:Form(
                    key: newFormKey,
                    child: TextFormField(
                      controller: addController,
                      validator: (v){
                        if(v!.isEmpty)  return 'هذا الحقل لا يجب أن يكون فارغ';
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: 'أدخل الاسم ',
                      ),
                    ),
                  ),
                  onSubmit: (){
                    _homeController.addNewCustomer(CustomerModel(
                      name: addController.text,
                      phone:'039548842',
                    ));
                    Get.back();
                    _homeController.loadCustomers();
              });
            });


          },
          child: const CustomText(text: '+',weight: FontWeight.bold,size: 28.0,
          color: Colors.white,),
        ),
      ),
    );
  }
}

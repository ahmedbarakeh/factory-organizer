import 'package:factory_organizer_app/controller/home_controller.dart';
import 'package:factory_organizer_app/models/item_model.dart';
import 'package:factory_organizer_app/screens/history/history_details_screen.dart';
import 'package:factory_organizer_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerDetailsScreen extends StatelessWidget {

  final String customerName;
  final int customerId;
  final HomeController _homeController = Get.find();



  CustomerDetailsScreen({required this.customerName, required this.customerId}){
    _homeController.loadCustomerPops(customerId: customerId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(customerName),
        centerTitle: true,
      ),
      body: Padding(
        padding:const EdgeInsets.all(8.0),
        child: SizedBox(
          height: Get.height,
          child:Column(
            children: [
              CustomText(text: 'السحوبات',weight: FontWeight.bold,size: 20.0,),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Obx(()=>_homeController.customerPopsLoaded.isTrue?GridView.builder(gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 1,
                    mainAxisSpacing: 1,
                  ), itemBuilder: (ctx,index){
                    return popDetailsView(_homeController.customerPops.value[index]);
                  },itemCount: _homeController.customerPops.value.length,):const Center(child: const CircularProgressIndicator(),),),
                ),
              )
            ],
          )
        ),
      ),
    );
  }

  Widget popDetailsView(ItemCustomerModel item){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16,horizontal: 8),
      decoration: BoxDecoration(
          border: Border.all(
          color: Colors.grey,
          width: 0.5
        )
      ),
      height: Get.height*0.2,
      width: Get.width*0.475,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  decoration: const BoxDecoration(
                      image:DecorationImage(image: AssetImage('assets/images/spot2.png',) )
                  ),
                  child: CustomText(text: item.name,size: 19.0,weight: FontWeight.bold,)),            ],
          ),
          const SizedBox(height: 24,),
          CustomText(text: '${item.popedQnt} x ${item.unit!.weight!} : ${item.popedQnt! *item.unit!.weight!}'),
          const SizedBox(height: 16,),
          CustomText(text: '${item.outDate}'),

        ],
      ),
    );
  }
}

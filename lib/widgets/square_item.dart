import 'package:factory_organizer_app/controller/home_controller.dart';
import 'package:factory_organizer_app/models/item_model.dart';
import 'package:factory_organizer_app/utils/constants.dart';
import 'package:factory_organizer_app/utils/utility.dart';
import 'package:factory_organizer_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SquareItem extends StatelessWidget {

  final ItemCustomerModel item;
  final bool isExternal;
  final VoidCallback? onTap;

  final HomeController _homeController=Get.find();
 var itemName='';
 var customerName='';

  SquareItem({Key? key, required this.item,required this.isExternal,this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    if(item.placeIndex ==-1){ // external
      itemName=item.name!;
    }
    else
    if(item.placeIndex!=null &&item.placeIndex! > -1) // internal
    {
       itemName=_homeController.getExternalItemById(id: item.externalItemId!)!.name!;
       customerName=_homeController.getCustomerById(id: item.customerId!)!.name!;
    }

    return GestureDetector(
      child: Container(
        height: 110,
        width: 100,
        margin: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(10)
        ),
        child: Column(
          children: [
           if(item.placeIndex ==-1)  Column(
             children: [
               Image.asset(unitTypeImages[item.unit!.typeIndex!],width: 40,height: 40,),
               const SizedBox(height: 12,)
             ],
           ),
           if(item.placeIndex!=null &&item.placeIndex !=-1)
              Image.asset(unitTypeImages[item.unit!.typeIndex!],fit: BoxFit.fitWidth,width: 25,height: 25,),
            Container(
               decoration: const BoxDecoration(
                 image:DecorationImage(image: AssetImage('assets/images/spot2.png',) )
               ),
                child: CustomText(text: itemName,size: 14.0,weight: FontWeight.bold,)),
             if(item.placeIndex!=null &&item.placeIndex !=-1)
               CustomText(text: Utility.getSeparatedNumber('${item.qnt!.toDouble()*item.unit!.weight!.toDouble()}'),size: 12.0,weight: FontWeight.w500,),

          ],
        ),
      ),
      onTap: onTap,
    );
  }
}

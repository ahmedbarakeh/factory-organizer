import 'package:factory_organizer_app/controller/home_controller.dart';
import 'package:factory_organizer_app/models/carousel_model.dart';
import 'package:factory_organizer_app/utils/constants.dart';
import 'package:factory_organizer_app/widgets/carousel_item.dart';
import 'package:factory_organizer_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StartupScreen extends StatelessWidget {
   StartupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: CarouselSliderItem(
          imagesModel: [
           CarouselItemModel(imageSrc: startupCarouselImages[0],title: 'Welcome',subTitle: 'Join to Storehouse Organizer And Enjoy Life'),
            CarouselItemModel(imageSrc: startupCarouselImages[1],title: 'Organized Your Store',subTitle: 'Do not Worry About Ordering The Store By Using This App'),
            CarouselItemModel(imageSrc: startupCarouselImages[2],title: 'From Charge To Store',subTitle: 'Put Every Item In StoreOrganized App And Every Thing Will Be Nice !')

          ],
          nextButton: Container(
            padding: EdgeInsets.symmetric(vertical: 16,horizontal: 65),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.red[400],
            ),
            child: CustomText(text: 'التالي',color: Colors.white,),
          ),

        ),
      ),
    );
  }
}

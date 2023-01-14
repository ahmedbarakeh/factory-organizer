import 'package:factory_organizer_app/screens/navigation_screen.dart';
import 'package:factory_organizer_app/screens/stratup_screen.dart';
import 'package:factory_organizer_app/utils/constants.dart';
import 'package:factory_organizer_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../controller/app_controller.dart';
import '../controller/home_controller.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({Key? key}) : super(key: key);
  final _appController=Get.put(AppController());
  final HomeController _homeController = Get.put(HomeController());


  Future startApp()async{

    Future.delayed(
      const Duration(seconds: 3),
          () async{
            final storeIsBuilt=await _homeController.isBuilt();
        storeIsBuilt? Get.off(() => NavigationScreen()) :Get.off(() => StartupScreen());
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    startApp();

    return Scaffold(
      body: Container(
        decoration:  BoxDecoration(
          gradient: LinearGradient(
            colors: [appColors[_appController.appColorIndex],lighterAppColors[_appController.appColorIndex] ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,

          ),),
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Storehouse Organizer',
              style: GoogleFonts.abrilFatface(
                  color: Colors.white,
                  fontSize: 35.0,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width:Get.width*0.7,child: CustomText(text:  'Organize your storehouse easily and fastly!',size: 25.0,textAlign:TextAlign.start,color: Colors.grey[200],weight: FontWeight.w800,maxLines: 3,)),
              ],
            ),
            const SizedBox(height: 8,),

            const SizedBox(height: 16,),
            SizedBox(height: Get.height*0.005,),
            Image.asset(
              'assets/images/storehouse.png',
              height: Get.height * 0.35,
              width: Get.width * 0.65,
            ),
            SizedBox(height: Get.height*0.02,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/boxes.png',width: 65,height: 65,),
                const SizedBox(width: 25,),
                Image.asset('assets/images/case.png',width: 65,height: 65,),
                const SizedBox(width: 25,),
                Image.asset('assets/images/box.png',width: 65,height: 65,),


              ],
            ),
            const SizedBox(height: 60,),
            Text(
              'Loading...',
              style: GoogleFonts.actor(
                  color: Colors.white,
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold),
            ),

          ],
        ),
      ),
    );
  }
}


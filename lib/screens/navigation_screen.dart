import 'package:factory_organizer_app/controller/app_controller.dart';
import 'package:factory_organizer_app/controller/home_controller.dart';
import 'package:factory_organizer_app/screens/customers_screen.dart';
import 'package:factory_organizer_app/screens/history/history_screen.dart';
import 'package:factory_organizer_app/screens/notices_screen.dart';
import 'package:factory_organizer_app/screens/settings_screen.dart';
import 'package:factory_organizer_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home_screen.dart';
import 'items_screen.dart';

class NavigationScreen extends StatelessWidget {

  final AppController _appController=Get.find();
  final HomeController _homeController = Get.find();

  final _pageController=PageController();

  List<Widget>pages=[
    HomeScreen(),
    CustomersScreen(),
    ItemsScreen(),
    SettingsScreen(),
    HistoryScreen(),
    NoticesScreen(),
  ];

  NavigationScreen({Key? key}) {
    _homeController.loadExternalItems();
    _homeController.loadInternalItems();
  }


  @override
  Widget build(BuildContext context) {
    return Obx(()=>Scaffold(
      body:PageView(
        controller: _pageController,
        children: pages,
        onPageChanged:(index){ _appController.currentPageIndex(index);},
      ),
      bottomNavigationBar:navigationBar() ,
    ));
  }
  Widget navigationBar(){
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      onTap: (index){
        //_appController.currentPageIndex(index);
        _pageController.animateToPage(index, duration: const Duration(milliseconds: 200), curve: Curves.bounceOut);

      },
      selectedItemColor:appColors[_appController.appColorIndex],
      unselectedItemColor: Colors.grey,
      currentIndex: _appController.currentPageIndex.value ,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      items:   [
        BottomNavigationBarItem(
          icon: const Icon(Icons.home,),
          label:'الرئيسية'.tr,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.person,),
          label:'العملاء'.tr,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.category,),
          label:'المواد'.tr,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.settings,),
          label:'اعدادات'.tr,
        ),

        BottomNavigationBarItem(
          icon: const Icon(Icons.history,),
          label:'السجل'.tr,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.message,),
          label:'ملاحظات'.tr,
        ),


      ],

    );
  }
}

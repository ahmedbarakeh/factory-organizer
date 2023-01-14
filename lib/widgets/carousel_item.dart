import 'package:factory_organizer_app/screens/navigation_screen.dart';
import 'package:factory_organizer_app/screens/store_construction_startup_screen.dart';
import 'package:factory_organizer_app/widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import '../models/carousel_model.dart';

class CarouselSliderItem extends StatelessWidget {
  var currentSliderIndex = 0.obs;

  final List<CarouselItemModel> imagesModel;
  final Widget? nextButton;
  final Widget? titleText;
  int x=1;

  CarouselSliderItem({required this.imagesModel,this.nextButton,this.titleText,Key? key}) : super(key: key);

  var currentCarouselIndex=0.obs;


  Widget buildCarouselImageItem(int index) {
    return Obx(()=>currentSliderIndex.value!=-1?Center(
      child: Image.asset(imagesModel[currentSliderIndex.value].imageSrc,width: Get.width*0.98,height: Get.height*0.5,),
    ):SizedBox(width: 0,));
  }

  @override
  Widget build(BuildContext context) {
    var titleText=imagesModel[0].title.obs;
    var subTitleText=imagesModel[0].subTitle.obs;

    return Container(
      height: Get.height,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
        imagesModel.length > 1
            ? CarouselSlider.builder(
          itemCount: imagesModel.length,
          itemBuilder: (ctx, index, realIndex) {
            return buildCarouselImageItem(currentSliderIndex.value);
          },
          options: CarouselOptions(

              autoPlay: false,
              initialPage: 0,
              onPageChanged: (index, reason) {
                print('onchhh');
                currentCarouselIndex.update((val) {
                  currentSliderIndex.value=index;
                });
                titleText(imagesModel[currentSliderIndex.value].title);
                subTitleText(imagesModel[currentSliderIndex.value].subTitle);
              }),
        )
            : buildCarouselImageItem(0),
        SizedBox(height: Get.height*0.075,),
        imagesModel.length > 1
            ? Obx(
              () => Column(
                children: [
                 AnimatedSmoothIndicator(
                  activeIndex: currentSliderIndex.value,
                  count: imagesModel.length,
                  effect: const ScrollingDotsEffect(
                    dotHeight: 6,
                    dotWidth: 20,
                    activeDotColor: Colors.red,
                    dotColor: Colors.grey,
                  ),
            ),
                ],
              ),
        )
            : const SizedBox(
          height: 0,
        ),
        SizedBox(height:  Get.height*0.05,),
       Obx(()=> Container(
         height: Get.height*0.175,
         padding: EdgeInsets.symmetric(vertical: 16,horizontal: 32),
         child: Column(
           mainAxisAlignment: MainAxisAlignment.spaceAround,
           children: [
             CustomText(text: titleText.value,color: Colors.grey[900],weight: FontWeight.w900,size: 28.0,),
             SizedBox(height: 24,),
             CustomText(text: subTitleText.value,maxLines: 3,color: Colors.grey[500],weight: FontWeight.w500,size: 17.0,),

           ],
         ),
       )),
        SizedBox(height:  Get.height*0.15,),
       if(nextButton!=null)
         Obx(()=>currentSliderIndex.value==imagesModel.length-1
             ?buildNextButton('Get Started',(){
            Get.off(()=>StoreConstructionScreen());

         })
             :buildNextButton('Next',(){
             currentSliderIndex.update((val) {
             currentSliderIndex.value=x%imagesModel.length;
           });
           titleText(imagesModel[currentSliderIndex.value].title);
           subTitleText(imagesModel[currentSliderIndex.value].subTitle);
           print('kvmkvk ' + currentSliderIndex.value.toString());
           x=x+1;
         }),)
      ]),
    );
  }
  Widget buildNextButton(String text,VoidCallback onPressed){
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16,horizontal: 65),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.red[400],
        ),
        child: CustomText(text: text,color: Colors.white,),
      ),
    );
  }
}

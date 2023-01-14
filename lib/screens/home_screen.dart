// ignore_for_file: must_be_immutable

import 'package:factory_organizer_app/controller/app_controller.dart';
import 'package:factory_organizer_app/controller/home_controller.dart';
import 'package:factory_organizer_app/models/customer_model.dart';
import 'package:factory_organizer_app/models/item_model.dart';
import 'package:factory_organizer_app/models/unit_model.dart';
import 'package:factory_organizer_app/utils/utility.dart';
import 'package:factory_organizer_app/widgets/backgrounded_text.dart';
import 'package:factory_organizer_app/widgets/custom_button.dart';
import 'package:factory_organizer_app/widgets/custom_text.dart';
import 'package:factory_organizer_app/widgets/square_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:intl/intl.dart';
import '../utils/constants.dart';

class HomeScreen extends StatelessWidget {
  final HomeController _homeController = Get.find();
  final AppController _appController = Get.find();

  HomeScreen() {
    _homeController.loadSquares(storeId: _appController.currentStoreId.value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: SizedBox(
            height: Get.height - 50,
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.77,
                  color: Colors.blue[400],
                  child: Obx(
                    () => _homeController.internalItemsLoaded.value
                        ? GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 48,
                            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 75,
                              crossAxisSpacing: 0,
                              mainAxisSpacing: 0,
                              mainAxisExtent: 75,
                            ),
                            itemBuilder: (ctx, index) {
                              final occupiedItem = _homeController
                                  .getItemByPlaceIndex(placeIndex: index);
                              return occupiedItem == null
                                  ? internalSquare(index: index)
                                  : SquareItem(
                                      item: occupiedItem,
                                      isExternal: false,
                                      onTap: () {
                                        showDialog(
                                            context: Get.context!,
                                            builder: (con) {
                                              return popItemDialog(
                                                  item: occupiedItem);
                                            });
                                      },
                                    );
                            })
                        : const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Expanded(
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 8),
                      child: Obx(
                        () => GridView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount:
                                _homeController.externalItems.value.length + 1,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                              crossAxisSpacing: 0,
                              mainAxisSpacing: 0,
                              mainAxisExtent: 110,
                            ),
                            itemBuilder: (ctx, index) {
                              return index == 0
                                  ? GestureDetector(
                                      onTap: () {
                                        showAddNewItemSheet();
                                      },
                                      child: CircleAvatar(
                                        backgroundColor: appColors[
                                            _appController.appColorIndex],
                                        child: const Padding(
                                          padding: EdgeInsets.all(12.0),
                                          child: CustomText(
                                            text: 'إضافة مادة',
                                            weight: FontWeight.w800,
                                            color: Colors.white,
                                            size: 16.0,
                                          ),
                                        ),
                                      ),
                                    )
                                  : externalSquare(_homeController
                                      .externalItems.value[index - 1]);
                            }),
                      )),
                )
              ],
            ),
          ),
        ));
  }

  Widget externalSquare(ItemCustomerModel item) {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: LongPressDraggable<ItemCustomerModel>(
          data: item,
          feedback: SquareItem(
            item: item,
            isExternal: true,
          ),
          child: SquareItem(
            isExternal: true,
            item: item,
          )),
    );
  }

  Widget internalSquare({int? index}) {
    bool accept = true;
    if (_homeController.squaresLoaded.value) {
      _homeController.squaresMap.value.forEach((element) {
        if (index == element.index) {
          accept = false;
          return;
        }
      });
    }
    return Obx(() => _homeController.squaresLoaded.value
        ? Padding(
            padding: const EdgeInsets.all(2.0),
            child: DragTarget<ItemCustomerModel>(
                onAccept: (data) {
                  showPushItemSheet(data: data, index: index!);
                },
                onWillAccept: (data) {
                  return accept;
                },
                builder: (ctx, d, x) => Container(
                      height: 110,
                      width: 100,
                      margin: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                          color: !accept ? Colors.grey : Colors.grey[100],
                          borderRadius: BorderRadius.circular(10)),
                      // child: Text(_homeController.squaresMap.value[index].index.toString()),
                    )),
          )
        : const Center(
            child: CircularProgressIndicator(),
          ));
  }

  void showPushItemSheet(
      {required ItemCustomerModel data, required int index}) {
    _homeController.loadCustomers();
    var qnt = 0.0.obs;
    var uniWeight = 0.obs;
    var addition = 0.0.obs;

    TextEditingController quantityController = TextEditingController();
    TextEditingController unitWeightController = TextEditingController();
    TextEditingController additionQntController = TextEditingController();
    TextEditingController newCustomerController = TextEditingController();

    final addKey = GlobalKey<FormState>();
    final addCustomerKey = GlobalKey<FormState>();
    var showAddNewCustomer = false.obs;
    var currentCustomerIndex = 0.obs;
    var showCustomersListEmpty = false.obs;

    if (_homeController.customers.value.isEmpty) showAddNewCustomer(true);

    showMaterialModalBottomSheet(
      elevation: 4,
      duration: const Duration(milliseconds: 500),
      context: Get.context!,
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        height: Get.height * 0.7,
        color: Colors.white,
        child: Form(
          key: addKey,
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    text: data.name,
                    size: 20.0,
                    weight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                  width: Get.width * 0.95,
                  height: Get.height * 0.058,
                  child: Obx(
                    () => ListView.builder(
                        itemCount: _homeController.customers.value.length + 1,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (ctx, index) {
                          return index == 0
                              ? GestureDetector(
                                  onTap: () {
                                    showCustomersListEmpty(false);
                                    showAddNewCustomer(true);
                                  },
                                  child: CircleAvatar(
                                    child: const CustomText(
                                      text: '+',
                                      size: 25.0,
                                      weight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    backgroundColor:
                                        appColors[_appController.appColorIndex],
                                    radius: 25,
                                  ),
                                )
                              : Obx(() => BackgroundedText(
                                    text: _homeController
                                        .customers.value[index - 1].name!,
                                    onTap: () {
                                      currentCustomerIndex(index - 1);
                                    },
                                    backgroundColor:
                                        currentCustomerIndex.value == index - 1
                                            ? Colors.blue[400]
                                            : Colors.grey[400],
                                  ));
                        }),
                  )),
              const SizedBox(
                height: 16,
              ),
              Obx(() => showCustomersListEmpty.value
                  ? const CustomText(
                      text: 'أضف عملاء أولاً',
                      weight: FontWeight.w700,
                      color: Colors.red,
                    )
                  : const SizedBox(
                      width: 0,
                    )),
              Obx(
                () => AnimatedContainer(
                  duration: const Duration(microseconds: 500),
                  height: showAddNewCustomer.value ? 75 : 0,
                  padding: const EdgeInsets.all(8),
                  child: showAddNewCustomer.value
                      ? Row(
                          children: [
                            Form(
                              key: addCustomerKey,
                              child: Expanded(
                                child: TextFormField(
                                  controller: newCustomerController,
                                  decoration: const InputDecoration(
                                    hintText: 'أدخل اسم العميل',
                                  ),
                                  validator: (v) {
                                    if (v!.isEmpty)
                                      return 'هذا الحقل يجب الا يكون فارغ';
                                    else
                                      return null;
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            CustomButton(
                              text: 'حفظ',
                              onPressed: () async {
                                addCustomerKey.currentState!.save();
                                final val =
                                    addCustomerKey.currentState!.validate();
                                if (val) {
                                  await _homeController.addNewCustomer(
                                      CustomerModel(
                                          name: newCustomerController.text));
                                  showAddNewCustomer(false);
                                  _homeController.loadCustomers();
                                }
                              },
                              backgroundColor: Colors.orange,
                              textSize: 14.0,
                            )
                          ],
                        )
                      : const SizedBox(
                          width: 0,
                        ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Obx(
                () => Text(
                  'Total :  ${uniWeight.value * qnt.value+addition.value}',
                  style: GoogleFonts.acme(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              //qnt
              TextFormField(
                onChanged: (v) {
                  qnt(double.parse(v));
                  print('qnt* ' + qnt.value.toString());
                },
                keyboardType: TextInputType.number,
                controller: quantityController,
                decoration: const InputDecoration(
                  hintText: 'أدخل العدد',
                ),
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'الكمية لا يجب ان تكون فارغة';
                  }
                  if (double.parse(val) == 0) {
                    return 'الكمية يجب ان تكون أكبر من 0';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 16,
              ),
              // qnt
              TextFormField(
                onChanged: (v) {
                  uniWeight(int.parse(v));
                },
                keyboardType: TextInputType.number,
                controller: unitWeightController,
                onSaved: (v) {},
                decoration: const InputDecoration(
                  hintText: 'أدخل وزن الواحدة',
                ),
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'الواحدة لا يجب ان تكون فارغة';
                  }
                  if (int.parse(val) == 0) {
                    return 'الواحدة يجب ان تكون أكبر من 0';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 16,
              ),
              TextFormField(
                onChanged: (v) {
                  var vDouble;
                  var q;

                  if(v.isEmpty) {
                    q=0.0;
                    vDouble=0.0;
                  }
                  else{
                    q = qnt.value;
                    vDouble=double.parse(v);
                  }

                  addition(vDouble);
                  qnt.update((val) {q+ vDouble/uniWeight.value; });
                  quantityController.text=(qnt.value + vDouble/uniWeight.value).toString();

                },
                keyboardType: TextInputType.number,
                controller: additionQntController,
                onSaved: (v) {},
                decoration: const InputDecoration(
                  hintText: 'أدخل الكمية الإضافية إن وجدت',
                ),

              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: Get.width * 0.35,
                    child: CustomButton(
                        text: 'حفظ',
                        backgroundColor:
                            appColors[_appController.appColorIndex],
                        textColor: Colors.white,
                        onPressed: () {
                          if (_homeController.customers.value.isEmpty) {
                            showCustomersListEmpty(true);
                            return;
                          }
                          addKey.currentState!.save();
                          bool isValidate = addKey.currentState!.validate();
                          if (isValidate) {
                            _homeController.addNewItem(ItemCustomerModel(
                                name: data.name,
                                originalQnt: qnt.value,
                                externalItemId: data.id,
                                storeId: _appController.currentStoreId.value,
                                customerId: _homeController.customers.value[currentCustomerIndex.value].id, 
                                insertDate: DateFormat("yyyy-MM-dd").format(
                                    DateTime.parse(DateTime.now().toString())),
                                unit: UnitModel(
                                    typeIndex: data.unit!.typeIndex,
                                    weight: uniWeight.value.toDouble(),
                                    id: data.id,
                                    name: data.name),
                                    customer: CustomerModel(
                                    name: _homeController
                                        .customers
                                        .value[currentCustomerIndex.value]
                                        .name),
                                qnt: qnt.value,
                                placeIndex: index));

                            Get.back();
                          }
                        }),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ).whenComplete(() {
      _homeController.loadInternalItems();
    });
  }

  void showAddNewItemSheet() {
    var typeIndex = 0.obs;

    TextEditingController newItemController = TextEditingController();
    showMaterialModalBottomSheet(
        elevation: 4,
        duration: const Duration(milliseconds: 500),
        context: Get.context!,
        builder: (ctx) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            height: Get.height * 0.5,
            child: ListView(
              children: [
                TextFormField(
                  controller: newItemController,
                  decoration: const InputDecoration(
                    hintText: 'Enter item name here',
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Image.asset(
                            unitTypeImages[0],
                            height: 45,
                            width: 45,
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          BackgroundedText(
                            text: 'كرتونة',
                            textSize: 15.0,
                            backgroundColor: typeIndex.value == 0
                                ? Colors.orange
                                : Colors.grey[300],
                            onTap: () {
                              typeIndex(0);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 18,
                      ),
                      Column(
                        children: [
                          Image.asset(
                            unitTypeImages[1],
                            height: 45,
                            width: 45,
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          BackgroundedText(
                            text: 'كيس',
                            textSize: 15.0,
                            backgroundColor: typeIndex.value == 1
                                ? Colors.orange
                                : Colors.grey[300],
                            onTap: () {
                              typeIndex(1);
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButton(
                        text: 'حفظ',
                        backgroundColor:
                            appColors[_appController.appColorIndex],
                        onPressed: () {
                          ItemCustomerModel item = ItemCustomerModel(
                              name: newItemController.text,
                              unit: UnitModel(typeIndex: typeIndex.value));
                          //print(typeIndex.value);
                          _homeController.addNewItem(item);
                          _homeController.loadExternalItems();
                          Get.back();
                        })
                  ],
                )
              ],
            ),
          );
        });
  }

  Widget popItemDialog({required ItemCustomerModel item}) {
    var showAddNewCustomer = false.obs;
    var currentCustomerIndex = 0.obs;
    var showCustomersListEmpty = false.obs;
    TextEditingController qntController = TextEditingController();
    TextEditingController totalController = TextEditingController();
    final popKey = GlobalKey<FormState>();
    TextEditingController newCustomerController = TextEditingController();

    var total = (item.qnt! * item.unit!.weight!.toDouble()).obs;
    var qnt = 0.0.obs;

    return AlertDialog(
      contentPadding: const EdgeInsets.all(16),
      actionsPadding: const EdgeInsets.all(16),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                'assets/images/spot2.png',
              ))),
              child: Text(
                'سحب مواد',
                style: GoogleFonts.abel(
                    fontWeight: FontWeight.bold, fontSize: 20.0),
              )),
        ],
      ),
      content: Form(
        key: popKey,
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
            height: Get.height * 0.525,
            width: Get.width*0.95,
            child: Column(
              children: [
                itemDetailRow(
                    leftText: 'Item :            ', rightText: item.name!),
                const SizedBox(
                  height: 8,
                ),
                Obx(
                  () => itemDetailRow(
                      leftText: 'Quantity:   ',
                      rightText:
                          '${item.qnt! - double.parse(qnt.value.toString())} x ${item.unit!.weight!.toDouble()}'),
                ),
                const SizedBox(
                  height: 8,
                ),
                Obx(
                  () => itemDetailRow(
                      leftText: 'Total :            ',
                      rightText:
                          Utility.getSeparatedNumber(total.value.toString())),
                ),
                const SizedBox(
                  height: 8,
                ),
                itemDetailRow(
                    leftText: 'Customer :  ', rightText: item.customer!.name!),
                const SizedBox(
                  height: 8,
                ),
                itemDetailRow(
                    leftText: 'Inserted date: ', rightText: item.insertDate!),
                const SizedBox(
                  height: 12,
                ),
                SizedBox(
                    width: Get.width * 0.95,
                    height: Get.height * 0.058,
                    child: Obx(
                      () => ListView.builder(
                          itemCount: _homeController.customers.value.length + 1,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (ctx, index) {
                            return index == 0
                                ? GestureDetector(
                                    onTap: () {
                                      showCustomersListEmpty(false);
                                      showAddNewCustomer(true);
                                    },
                                    child: CircleAvatar(
                                      child: const CustomText(
                                        text: '+',
                                        size: 20.0,
                                        weight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      backgroundColor: appColors[
                                          _appController.appColorIndex],
                                      radius: 20,
                                    ),
                                  )
                                : Obx(() => BackgroundedText(
                                      text: _homeController
                                          .customers.value[index - 1].name!,
                                      onTap: () {
                                        currentCustomerIndex(index - 1);
                                      },
                                      backgroundColor:
                                          currentCustomerIndex.value ==
                                                  index - 1
                                              ? Colors.blue[400]
                                              : Colors.grey[400],
                                    ));
                          }),
                    )),
                const SizedBox(
                  height: 10,
                ),
                Obx(
                  () => AnimatedContainer(
                    duration: const Duration(microseconds: 500),
                    height: showAddNewCustomer.value ? 75 : 0,
                    padding: const EdgeInsets.all(8),
                    child: showAddNewCustomer.value
                        ? Row(
                            children: [
                              Expanded(
                                  child: TextFormField(
                                controller: newCustomerController,
                                decoration: const InputDecoration(
                                  hintText: 'Enter customer name',
                                ),
                              )),
                              const SizedBox(
                                width: 16,
                              ),
                              CustomButton(
                                text: 'حفظ',
                                onPressed: () async {
                                  await _homeController.addNewCustomer(
                                      CustomerModel(
                                          name: newCustomerController.text));
                                  showAddNewCustomer(false);
                                  _homeController.loadCustomers();
                                },
                                backgroundColor: Colors.orange,
                                textSize: 14.0,
                              )
                            ],
                          )
                        : const SizedBox(
                            width: 0,
                          ),
                  ),
                ),
                const SizedBox(
                  height: 18,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: Get.width * 0.3,
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onChanged: (v) {
                          if (v.isEmpty) v = '0';
                          total((item.qnt! * item.unit!.weight!.toDouble()) -
                              double.tryParse(v)!);
                          qntController.text = '${double.tryParse(v)! / item.unit!.weight!}';
                          qnt(double.tryParse(v)! / item.unit!.weight!);
                        },
                        validator: (val) {
                          if (total.value <= 0) {
                            return 'العدد المدخل خاطئ';
                          }
                          return null;
                        },
                        controller: totalController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 4),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Colors.black54),
                          ),
                          hintStyle: TextStyle(
                            fontSize: 11.0,
                          ),
                          hintText: 'أدخل الكمية الكلية',
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    Text(
                      'Or',
                      style: GoogleFonts.acme(
                          fontWeight: FontWeight.bold, fontSize: 18.0),
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    SizedBox(
                      width: Get.width * 0.25,
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (val) {
                          if (total.value <= 0) {
                            return 'العدد المدخل خاطئ';
                          }
                          return null;
                        },
                        onChanged: (v) {
                          if (v.isEmpty) v = '0';
                          totalController.text =
                              '${int.tryParse(v)!.toDouble() * item.unit!.weight!.toDouble()}';
                          qnt(double.tryParse(v));
                          total((item.qnt! * item.unit!.weight!.toDouble()) -
                              (double.tryParse(v)! *
                                  item.unit!.weight!.toDouble()));
                        },
                        controller: qntController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 4),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Colors.black54),
                          ),
                          hintStyle: TextStyle(
                            fontSize: 11.0,
                          ),
                          hintText: 'أدخل العدد',
                        ),
                      ),
                    )
                  ],
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButton(
                      text: 'سحب كل المادة',
                      onPressed: () async {
                        final _item = ItemCustomerModel(
                          outDate: DateFormat("yyyy-MM-dd").format(
                              DateTime.parse(DateTime.now().toString())),
                          insertDate: item.insertDate,
                          id: item.id,
                          height: item.height,
                          unit: item.unit,
                          customer: item.customer,
                          name: item.name,
                          qnt: 0,
                          storeId: _appController.currentStoreId.value,
                          popedCustomerId: _homeController
                              .customers.value[currentCustomerIndex.value].id,
                          customerId: item.customerId,
                          externalItemId: item.externalItemId,
                          popedQnt: item.qnt,
                          originalQnt: item.originalQnt,
                          placeIndex: -2,
                          width: item.width,
                        );
                        await _homeController.updateItem(_item);
                        _item.popedItemId = item.id;
                        await _homeController.addNewItem(_item);

                        _homeController.loadInternalItems();
                        Get.back();
                      },
                      backgroundColor: appColors[_appController.appColorIndex],
                      textSize: 14.0,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        GestureDetector(
            onTap: () async {
              popKey.currentState!.save();
              if (qntController.text.isEmpty || totalController.text.isEmpty) {
                Get.back();
                return;
              }
              final isValid = popKey.currentState!.validate();
              if (isValid) {
                // pop

                final newItem = ItemCustomerModel(
                    width: item.width,
                    placeIndex: item.placeIndex,
                    qnt: item.qnt! - qnt.value,
                    name: item.name,
                    externalItemId: item.externalItemId,
                    customerId: item.customerId,
                    customer: item.customer,
                    unit: item.unit,
                    storeId: _appController.currentStoreId.value,
                    popedCustomerId: _homeController
                        .customers.value[currentCustomerIndex.value].id,
                    originalQnt: item.originalQnt,
                    height: item.height,
                    id: item.id,
                    popedQnt: qnt.value,
                    insertDate: item.insertDate,
                    outDate: DateFormat("yyyy-MM-dd")
                        .format(DateTime.parse(DateTime.now().toString())));
                await _homeController.updateItem(newItem);
                newItem.popedItemId = newItem.id;
                _homeController.addNewItem(newItem);
                _homeController.loadInternalItems();
                Get.back();
              }
            },
            child: const CustomText(
              text: 'تأكيد',
              weight: FontWeight.bold,
            )),
        const SizedBox(
          width: 16,
        ),
        GestureDetector(
            onTap: () {
              Get.back();
              //_homeController.
            },
            child: const CustomText(
              text: 'رجوع',
              weight: FontWeight.bold,
              color: Colors.green,
            )),
      ],
    );
  }

  Widget itemDetailRow({required String leftText, required String rightText}) {
    return Row(
      children: [
        Text(
          '$leftText   ',
          style: GoogleFonts.acme(color: Colors.green[700]),
        ),
        SizedBox(
            width: Get.width * 0.4,
            child: Text(
              rightText,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.acme(
                  color: Colors.grey[700], fontWeight: FontWeight.bold),
            ))
      ],
    );
  }
}
/*
* */

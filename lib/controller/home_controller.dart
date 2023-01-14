
import 'package:factory_organizer_app/controller/app_controller.dart';
import 'package:factory_organizer_app/models/customer_model.dart';
import 'package:factory_organizer_app/models/item_model.dart';
import 'package:factory_organizer_app/models/notice_model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../data/sqllife_db.dart';
import '../models/square_model.dart';

class HomeController extends GetxController{
  final db=FactoryOrganizerDb.instance;
  final AppController _appController=Get.find();


  var externalItems=Rx<List<ItemCustomerModel>>([]);
  var internalItems=Rx<List<ItemCustomerModel>>([]);
  var notices=Rx<List<NoticeModel>>([]);
  var customerPops=Rx<List<ItemCustomerModel>>([]);
  var historyStoreList=Rx<List<ItemCustomerModel>>([]);

  var internalItemsLoaded=false.obs;
  var customerPopsLoaded=false.obs;
  var externalItemsLoaded=false.obs;
  var historyItemsLoaded=false.obs;
  var squaresMap=Rx<List<SquareModel>>([]);
  var squaresLoaded=false.obs;
  var customersLoaded=false.obs;
  var noticesLoaded=false.obs;

  var customers=Rx<List<CustomerModel>>([]);


  ItemCustomerModel? getItemByPlaceIndex({required int placeIndex}){
   // print('getItemByPlaceIndex  $placeIndex');
    ItemCustomerModel item=ItemCustomerModel();
    bool found=false;
    if(internalItemsLoaded.isTrue){
      for (var element in internalItems.value) {
        if(element.placeIndex==placeIndex)
        {
          item=element;
          found = true;
        }
      }
    }
    if(found) return item;
    return null;

  }

  // load
  Future loadHistory()async{
    historyItemsLoaded(false);
    final res=await db.getAllItems(where: '${ItemCustomerFields.placeIndex}!=-1 and ${ItemCustomerFields.popedItemId} ==0');
    final List<ItemCustomerModel> list=[];
    for (var item in res) {
      list.add(ItemCustomerModel.fromJson(item));
    }
    print(res.toString());
    historyStoreList(list);
    historyItemsLoaded(true);
  }
  ItemCustomerModel? getExternalItemById({required int id}){
    // print('getItemByPlaceIndex  $placeIndex');
    ItemCustomerModel item=ItemCustomerModel();
    bool found=false;
    if(externalItemsLoaded.isTrue){
      for (var element in externalItems.value) {
        if(element.id==id)
        {
          item=element;
          found = true;
        }
      }
    }

    if(found) return item;
    return null;

  }
  CustomerModel? getCustomerById({required int id}){
    // print('getItemByPlaceIndex  $placeIndex');
    CustomerModel customer=CustomerModel();
    bool found=false;
    for (var element in customers.value) {
      if(element.id==id)
      {
        customer=element;
        found = true;
      }
    }
    if(found) return customer;
    return null;

  }
  double getTotalQntOfItem({required int id}){
    double  tot=0;
    if(internalItemsLoaded.value){
      for (var element in internalItems.value) {
        if(element.externalItemId==id){
          tot+=element.unit!.weight! * element.qnt!;
        }
      }
    }
    return tot;
  }
  Future loadNotices()async{
    noticesLoaded(false);
    final res=await db.getAllNotices();
    final List<NoticeModel> list=[];
    for (var item in res) {
      list.add(NoticeModel.fromJson(item));
    }
    notices(list);
    noticesLoaded(true);
  }
  Future<List<ItemCustomerModel>> getItemHistoryDetail({required itemId})async{
    final res=await db.getAllItems(where: '${ItemCustomerFields.placeIndex}!=-1  and ${ItemCustomerFields.popedItemId} ==$itemId');
    final List<ItemCustomerModel> list=[];
    for (var item in res) {
      list.add(ItemCustomerModel.fromJson(item));
    }

    return list;
  }
  Future clearData()async{
    await db.wipeData();
  }
  Future loadExternalItems()async{
    externalItemsLoaded(false);
    final res=await db.getAllItems(where: '${ItemCustomerFields.placeIndex} ==-1 and ${ItemCustomerFields.popedItemId} ==0');
    final List<ItemCustomerModel> list=[];
    for (var item in res) {
      list.add(ItemCustomerModel.fromJson(item));
    }
    print(res.toString());
    externalItems(list);
    externalItemsLoaded(true);
  }
  Future loadInternalItems()async{
    internalItemsLoaded(false);
    final res=await db.getAllItems(where: '${ItemCustomerFields.placeIndex} > -1 and ${ItemCustomerFields.popedItemId} ==0 and storeId == ${_appController.currentStoreId.value}');
    final List<ItemCustomerModel> list=[];
    for (var item in res) {
      list.add(ItemCustomerModel.fromJson(item));
    }
    internalItemsLoaded(true);
    print(res.toString());
    internalItems(list);
  }
  Future loadCustomers()async{
    customersLoaded(false);
    final res=await db.getAllCustomers();
    final List<CustomerModel> list=[];
    for (var customer in res) {
      list.add(CustomerModel.fromJson(customer));
    }
    customers(list);
    customersLoaded(true);
  }
  Future loadSquares({required int storeId})async{
    squaresLoaded(false);
    final db=FactoryOrganizerDb.instance;
    final res=await db.getSetupSquares(storeId: storeId);
    final List<SquareModel> list=[];
    for (var sq in res) {
      list.add(SquareModel.fromJson(sq));
    }
    squaresMap(list);
    squaresLoaded(true);
  }

  // delete
  Future deleteItem({required int id})async{
    await db.deleteItem(id:id);
  }
  Future deleteCustomer({required int id})async{
    await db.deleteCustomer(id:id);
  }
  Future deleteNotice({required int id})async{
    await db.deleteNotice(id:id);
  }
  Future deleteItemFromHistory({required int id})async{
    await db.deleteItemFromHistory(id:id);
  }

  // add
  Future addNewCustomer(CustomerModel customer)async{
   await db.insertCustomer(customer);
  }
  Future addNewItem(ItemCustomerModel item)async{
    await db.insertItem(item);
  }
  Future addNewNotice(NoticeModel notice)async{
    await db.insertNotice(notice);
  }


  Future loadCustomerPops({required int customerId})async{
    customerPopsLoaded(false);
    final res=await db.getAllItems(where: '${ItemCustomerFields.popedCustomerId} == $customerId and ${ItemCustomerFields.popedItemId} != 0');
    final List<ItemCustomerModel> list=[];
    for (var item in res) {
      list.add(ItemCustomerModel.fromJson(item));
    }
    customerPopsLoaded(true);
    customerPops(list);
  }


  Future updateItem(ItemCustomerModel item)async{
    await db.updateItem(item);
  }
  Future editCustomer(CustomerModel customer)async{
    await db.editCustomer(customer);
  }
  Future<bool> isBuilt()async{
    final db=FactoryOrganizerDb.instance;
    final res=await db.getSetupSquares();
    if(res.isNotEmpty) return true;

    return false;

  }
  bool isCustomerHasItems({required int id}){
    bool found=false;
    if(internalItemsLoaded.isTrue){
      for (var element in internalItems.value) {
        if(element.customerId==id){
          found=true;
          break;
        }
      }
    }
    return found;
  }
  bool isItemInStore({required int id}){
    bool found=false;
    if(internalItemsLoaded.isTrue){
      for (var element in internalItems.value) {
        if(element.externalItemId==id){
          found=true;
          break;
        }
      }
    }
    return found;
  }
  bool isItemExist({required int id}){
    bool found=false;
    if(externalItemsLoaded.isTrue){
      for (var element in externalItems.value) {
        if(element.id==id){
          found=true;
          break;
        }
      }
    }
    return found;
  }
  bool isCustomerExist({required int id}){
    bool found=false;
    if(customersLoaded.isTrue){
      for (var element in customers.value) {
        if(element.id==id){
          found=true;
          break;
        }
      }
    }
    return found;
  }



}
import 'dart:convert';

import 'package:factory_organizer_app/models/customer_model.dart';
import 'package:factory_organizer_app/models/unit_model.dart';

const String itemTable='ITEM_TABLE';
class ItemCustomerFields{
  static const String id='id';
  static const String customerId='customerId';
  static const String externalItemId='externalItemId';
  static const String customer='customer';
  static const String name='name';
  static const String storeId='storeId';
  static const String popedItemId='popedItemId';
  static const String popedCustomerId='popedCustomerId';
  static const String popedQnt='popedQnt';
  static const String qnt='qnt';
  static const String originalQnt='originalQnt';
  static const String height='height';
  static const String width='width';
  static const String placeIndex='placeIndex';
  static const String unit='unit';
  static const String insertDate='insertDate';
  static const String outDate='outDate';

}
class ItemCustomerModel{

  late int? id;
  late String? name;
  late CustomerModel? customer;
  late double? qnt;
  // original val of item before pop
  late double? originalQnt;
  late int? externalItemId;
  late int? customerId;
  late int? storeId;
  late int? height;
  late int? width;
  // this id is from items which are outside the store (current items)
  late int? popedItemId;
  // who pop this item
  late int? popedCustomerId;
  late double? popedQnt;
  late int? placeIndex; // if it equal -1 that means it is not in store yet
  late UnitModel? unit;
  late String? insertDate;
  late String? outDate;


  ItemCustomerModel(
      {  this.id,
         this.customer,
          this.qnt,
         this.height,
         this.width,
        this.storeId,
         this.originalQnt,
         this.placeIndex,
         this.unit,
        this.popedCustomerId,
         this.name,
         this.popedQnt,
         this.popedItemId,
         this.insertDate,
         this.outDate,
         this.customerId,
         this.externalItemId,
      });

  ItemCustomerModel.fromJson(Map<String,dynamic> json){
    id=json['id']??0;
    customer=json['customer']!=null?CustomerModel.fromJson(jsonDecode(json['customer'])):null;
    qnt = json['qnt'];
    height =json['height']??0;
    width = json['width']??0;
    name =json['name']??'';
    storeId=json['storeId']??0;
    originalQnt=json['originalQnt']??0;
    customerId=json['customerId']??-1;
    popedItemId = json['popedItemId']??0;
    popedQnt = json['popedQnt']??0.0;
    popedCustomerId=json['popedCustomerId']??0;
    externalItemId=json['externalItemId']??-1;
    placeIndex = json['placeIndex']??-1;
    unit =json['unit']!=null? UnitModel.fromJson(jsonDecode(json['unit'])):null;
    insertDate=json['insertDate']??'01-01-2000';
    outDate=json['outDate']??'01-01-2000';

  }

  Map<String,dynamic> toJson()=>
     {
        //ItemFields.id:id,
        ItemCustomerFields.customer:customer!=null?jsonEncode(customer):null,
        ItemCustomerFields.qnt:qnt??0,
        ItemCustomerFields.name:name??'',
        ItemCustomerFields.height:height??0,
       ItemCustomerFields.customerId:customerId??-1,
       ItemCustomerFields.externalItemId:externalItemId??-1,
        ItemCustomerFields.width:width??0,
       ItemCustomerFields.popedQnt:popedQnt??0,
       ItemCustomerFields.storeId:storeId??0,
       ItemCustomerFields.popedItemId:popedItemId??0,
       ItemCustomerFields.popedCustomerId:popedCustomerId??0,
       ItemCustomerFields.originalQnt:originalQnt,
        ItemCustomerFields.placeIndex:placeIndex??-1,
        ItemCustomerFields.unit:unit!=null? jsonEncode(unit):null,
        ItemCustomerFields.insertDate:insertDate??'',
        ItemCustomerFields.outDate:outDate??'',
      };
}
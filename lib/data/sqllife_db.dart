import 'dart:async';
import 'dart:convert';
import 'package:factory_organizer_app/models/app_settings_model.dart';
import 'package:factory_organizer_app/models/customer_model.dart';
import 'package:factory_organizer_app/models/item_model.dart';
import 'package:factory_organizer_app/models/notice_model.dart';
import 'package:factory_organizer_app/models/square_model.dart';
import 'package:factory_organizer_app/models/store_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


class FactoryOrganizerDb {
 static final FactoryOrganizerDb instance=FactoryOrganizerDb._init();

 static Database? _database;

 FactoryOrganizerDb._init();

 Future<Database>get database async{
   if(_database!=null) return _database!;

   _database=await _initDB('factory.db');
   return _database!;
 }
 Future<Database> _initDB(String filePath)async{
   final dbPath = await getDatabasesPath();
   final path = join(dbPath,filePath);

   return await openDatabase(path,version: 3,onCreate: _createDB);
 }
 Future _createDB(Database db , int version)async{
   //INTEGER FOREIGN KEY REFERENCES $itemTable(${ItemFields.id})
   await db.execute('''
   CREATE TABLE $itemTable (
   ${ItemCustomerFields.id} INTEGER PRIMARY KEY AUTOINCREMENT ,
   ${ItemCustomerFields.customer} TEXT,
   ${ItemCustomerFields.height} INTEGER,
   ${ItemCustomerFields.width} INTEGER,
   ${ItemCustomerFields.storeId} INTEGER,
   ${ItemCustomerFields.insertDate} TEXT,
   ${ItemCustomerFields.outDate} TEXT,
   ${ItemCustomerFields.placeIndex} INTEGER,
   ${ItemCustomerFields.qnt} double,
   ${ItemCustomerFields.popedCustomerId} INTEGER,
   ${ItemCustomerFields.customerId} INTEGER,
   ${ItemCustomerFields.originalQnt} double,
   ${ItemCustomerFields.externalItemId} INTEGER,
   ${ItemCustomerFields.popedItemId} INTEGER,
   ${ItemCustomerFields.popedQnt} double,
   ${ItemCustomerFields.unit} TEXT,
   ${ItemCustomerFields.name} TEXT
   )
   '''

   );

   await db.execute('''
   CREATE TABLE $customerTable (
   ${CustomerFields.id} INTEGER PRIMARY KEY AUTOINCREMENT ,
   ${CustomerFields.name} TEXT,
   ${CustomerFields.phone} TEXT
   )
   '''

   );

   await db.execute('''
   CREATE TABLE $appSettingsTable (
   ${AppSettingsTableFields.id} INTEGER PRIMARY KEY AUTOINCREMENT ,
   ${AppSettingsTableFields.name} TEXT,
   ${AppSettingsTableFields.value} TEXT
   )
   '''

   );

   await db.execute('''
   CREATE TABLE $storeTable (
   ${StoreTableFields.id} INTEGER PRIMARY KEY AUTOINCREMENT ,
   ${StoreTableFields.name} TEXT
   )
   '''

   );

   await db.execute('''
   CREATE TABLE $squareTable (
   ${SquareTableFields.id} INTEGER PRIMARY KEY AUTOINCREMENT ,
   ${SquareTableFields.storeId} INTEGER,
   ${SquareTableFields.mapIndex} INTEGER
   )
   '''

   );

   await db.execute('''
   CREATE TABLE $noticeTable (
   ${NoticeFields.id} INTEGER PRIMARY KEY AUTOINCREMENT ,
   ${NoticeFields.title} Text,
    ${NoticeFields.noticeDate} Text,
     ${NoticeFields.noticeText} Text
   )
   '''

   );
 }
 Future close()async{
   final db = await instance.database;

   db.close();
 }
 Future<int> insertItem(ItemCustomerModel item)async{
   final db =await instance.database;
   try{
     return await db.insert(itemTable, item.toJson());
   }
   catch(e){
     return -1;
   }

   //return 0;
 }
 Future<int> updateItem(ItemCustomerModel item)async{
   final db =await instance.database;
   try{
     return await db.update(itemTable,item.toJson(),where: ' id=?' ,whereArgs: [item.id]);
   }
   catch(e){
     return -1;
   }

   //return 0;
 }
 Future<int> insertSquareData(SquareModel square)async{
   final db =await instance.database;
   print(square.toJson());
   return await db.insert(squareTable,square.toJson());

 }
 Future<int> insertNotice(NoticeModel notice)async{
   final db =await instance.database;
   return await db.insert(noticeTable,notice.toJson());

 }
 Future<List<Map<String,dynamic>>> getAllNotices()async{

   final db =await instance.database;
   final res=await db.query(
       noticeTable,
   );

   return res;

 }


 Future<int> insertCustomer(CustomerModel customer)async{
   final db =await instance.database;
   try{
     return await db.insert(customerTable, customer.toJson());
   }
   catch(e){
     return -1;
   }

   //return 0;
 }
 Future<List<Map<String,dynamic>>> getAllCustomers()async{

   final db =await instance.database;
   final res=await db.query(
     customerTable,
     orderBy: '${CustomerFields.id} DESC '
   );
   return res;

 }
 Future<List<Map<String,dynamic>>> getSetupSquares({ int? storeId})async{

   final db =await instance.database;
   final res= storeId!=null? await db.query(
     squareTable,
     where: ' storeId =?',
     whereArgs: [storeId]
   ):await db.query(
       squareTable,
   );
   return res;

 }
 Future<int> writeAppSetting({required String name,required  value})async{
   final db =await instance.database;
   final exist=await db.query(appSettingsTable,where: 'name=?' , whereArgs: [name]);

   try{
     if(exist.isEmpty){
       return await db.insert(appSettingsTable, {'${AppSettingsTableFields.name}':name,'${AppSettingsTableFields.value}':value});

     }
     return db.update(appSettingsTable, {'${AppSettingsTableFields.name}':name,'${AppSettingsTableFields.value}':value},where:'${AppSettingsTableFields.name}=?',whereArgs: [name] );
   }
   catch(e){
     return -1;
   }

   //return 0;
 }

 Future<String?> readSettingValueByName({required String name})async{
   try{
     final db =await instance.database;
     final res=await db.query(
       appSettingsTable,
       where:' ${AppSettingsTableFields.name}=?',
       whereArgs: [name],
     );
     if(res.isNotEmpty) {
       print(res[0]['value']);
       return res[0]['value'].toString();
     }
     return null;
   }
   catch(e){
     return null;
   }
   //return ItemModel.fromJson(res.asStream().first);
 }

 Future<String?> getItem({required int id})async{
   try{
     final db =await instance.database;
     final res=await db.query(
       itemTable,
       where:' ${ItemCustomerFields.id}=?',
       whereArgs: [id],
     );
     if(res.isNotEmpty) {
       return res[0].toString();
     }
     return null;
   }
   catch(e){
     return null;
   }
    //return ItemModel.fromJson(res.asStream().first);
 }
 Future<String?> getStoreById({required int id})async{
   try{
     final db =await instance.database;
     final res=await db.query(
       storeTable,
       where:' ${StoreTableFields.id}=?',
       whereArgs: [id],
     );
     if(res.isNotEmpty) {
       return res[0].toString();
     }
     return null;
   }
   catch(e){
     return null;
   }
   //return ItemModel.fromJson(res.asStream().first);
 }
 Future<List<Map<String,dynamic>>?> getStores()async{
   try{
     final db =await instance.database;
     final res=await db.query(
       storeTable,
     );
     if(res.isNotEmpty) {
       return res;
     }
     return null;
   }
   catch(e){
     return null;
   }
   //return ItemModel.fromJson(res.asStream().first);
 }

 Future<String?> getCustomer({required int id})async{
   try{
     final db =await instance.database;
     final res=await db.query(
       customerTable,
       where:' ${CustomerFields.id}=?',
       whereArgs: [id],
     );
     if(res.isNotEmpty) {
       return res[0].toString();
     }
     return null;
   }
   catch(e){
     return null;
   }
   //return ItemModel.fromJson(res.asStream().first);
 }
 Future<List<Map<String,dynamic>>> getAllItems({String? where})async{

     final db =await instance.database;
     final res=await db.query(
       itemTable,
       where: where
     );
     print(res);

     return res;

 }
 Future wipeData()async{
   final db =await instance.database;
   try{
      await db.execute('delete  from $itemTable');
      await db.execute('delete  from $customerTable');
      db.close();
   }
   catch(e){
     return -1;
   }

   //return 0;
 }

 Future<int> deleteItem({required int id,})async{
   final db =await instance.database;
   try{
     return await db.delete(itemTable,where: ' ${ItemCustomerFields.id}=?' ,whereArgs: [id]);
   }
   catch(e){
     return -1;
   }

 }
 Future<int> deleteNotice({required int id,})async{
   final db =await instance.database;
   try{
     return await db.delete(noticeTable,where: ' ${NoticeFields.id}=?' ,whereArgs: [id]);
   }
   catch(e){
     return -1;
   }

 }

 Future deleteItemFromHistory({required int id,})async{
   final db =await instance.database;
   try{
      await db.delete(itemTable,where: ' ${ItemCustomerFields.id}=?' ,whereArgs: [id]);
      await db.delete(itemTable,where: ' ${ItemCustomerFields.popedItemId}=?' ,whereArgs: [id]);
   }
   catch(e){
     return -1;
   }

 }

 Future<int> deleteCustomer({required int id})async{
   final db =await instance.database;
   try{
     return await db.delete(customerTable,where: ' ${CustomerFields.id}=?' ,whereArgs: [id]);
   }
   catch(e){
     return -1;
   }

   //return 0;
 }
 Future<int> editCustomer(CustomerModel customer)async{
   final db =await instance.database;
   try{
     return await db.update(customerTable, customer.toJson(),where:' ${CustomerFields.id} = ?',whereArgs: [customer.id]);
   }
   catch(e){
     return -1;
   }

   //return 0;
 }

 Future<int> insertStore({required String name})async{
   final db =await instance.database;
   try{
     return await db.insert(storeTable, {'name':name});
   }
   catch(e){
     return -1;
   }

   //return 0;
 }





}




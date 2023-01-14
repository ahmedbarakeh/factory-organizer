const String storeTable = 'STORE_TABLE';

class StoreTableFields{
  static const String id='id';
  static const String name='name';


}
class StoreModel{
  late int? id;
  late String? name;

  StoreModel({this.id, this.name});

  StoreModel.fromJson(Map<String,dynamic> json){
    id = json['id']??'';
    name=json['name']??'';

  }
}

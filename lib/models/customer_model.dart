
const String customerTable='CUSTOMER_TABLE';

class CustomerFields{
  static const id='id';
  static const name='name';
  static const phone='phone';

}

class CustomerModel{
  late int? id;
  late String? name;
  late String? phone;

  CustomerModel({this.id, this.name, this.phone});

  CustomerModel.fromJson(Map<String,dynamic> json){
    id=json['id']??0;
    name=json['name']??'';
    phone = json['phone']??'096547521';
  }

  Map<String,dynamic> toJson()=>
      {
        CustomerFields.name:name,
        CustomerFields.phone:phone,
      };
}
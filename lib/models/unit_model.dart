class UnitModel{
  late int? id;
  late String? name;
  late int? typeIndex;
  late double? weight;

  UnitModel({this.id, this.name, this.typeIndex,this.weight});

  UnitModel.fromJson(Map<String,dynamic> json){
    id=json['id']??0;
    name=json['name']??'';
    typeIndex = json['type']??-1;
    weight=json['weight']??0;
  }

  Map<String,dynamic> toJson()=>
  {
    'id':id,
    'name':name,
    'type':typeIndex,
    'weight':weight,
  };

}
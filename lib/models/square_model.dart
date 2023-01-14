import 'dart:convert';

const String squareTable='SQUARE_TABLE';

class SquareTableFields{
  static const String id='id';
  static const String mapIndex='mapIndex';
  static const String storeId='storeId';


}

class SquareModel{
  late double? height;
  late double? width;
  late int? colorIndex;
  late bool? isExternalSquare;
  late bool? isOccupied;
  late int? index;
  late int? storeId;

  SquareModel({this.height=100,this.storeId=0, this.width=100, this.index,this.colorIndex=0,this.isExternalSquare=false,this.isOccupied=false});

  SquareModel.fromJson(Map<String,dynamic> json){
    //print(jsonDecode(json['mapIndexes']));
    index=json['mapIndex']??-1;
    storeId=json['storeId']??0;
  }
  Map<String,dynamic> toJson(){

     return {
       'mapIndex':'$index',
       'storeId':'$storeId'
     };

}
}
class SquareIndex{
   int? mapIndex;
  SquareIndex({this.mapIndex});

  SquareIndex.fromJson(Map<String,dynamic> json){
    mapIndex = json['mapIndex'];
  }
  Map<String,dynamic> toJson(){
    return {
      'mapIndex':mapIndex
    };
  }
  
}
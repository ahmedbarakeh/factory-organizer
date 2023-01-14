const String noticeTable='NOTICE_TABLE';

class NoticeFields{
  static const String id='id';
  static const String title='title';
  static const String noticeText='noticeText';
  static const String noticeDate='noticeDate';

}

class NoticeModel{
 late String? title;
 late String? noticeText;
 late String? noticeDate;
 late int? id;

 NoticeModel({required this.title,required this.noticeText,required this.noticeDate, this.id});

 NoticeModel.fromJson(Map<String,dynamic> json){
   title = json['title']??'';
   noticeDate=json['noticeDate']??'';
   noticeText=json['noticeText']??'';
   id=json['id']??-1;
 }
 Map<String,dynamic> toJson()=>
     {
       NoticeFields.id:id,
       NoticeFields.noticeText:noticeText,
       NoticeFields.noticeDate:noticeDate,
       NoticeFields.title : title,

     };
}
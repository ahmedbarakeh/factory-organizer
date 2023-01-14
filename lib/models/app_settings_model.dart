const String appSettingsTable = 'APP_SETTINGS_TABLE';

class AppSettingsTableFields{
  static const String id='id';
  static const String name='name';
  static const String value='value';


}
class  AppSettings{
  late int? id;
  late String? name;
  late String? value;

  AppSettings({this.id, this.name,this.value});

  AppSettings.fromJson(Map<String,dynamic> json){
    id = json['id']??'';
    name=json['name']??'';
    value=json['value']??'';

  }
}

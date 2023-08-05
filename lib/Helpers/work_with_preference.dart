import 'package:shared_preferences/shared_preferences.dart';
Future<String> getPreference(String Key)async{
  final prefs = await SharedPreferences.getInstance();
  return  prefs.getString(Key)??'-';
}
 savePreference(String Key, String value)async{
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(Key, value);
}
Future<bool> needRelogon()async {
  var auth_date = await getPreference('auth_date');
  if(auth_date!='-'&&auth_date!='') {
    var lastAuthDate = DateTime.parse(auth_date);
    var dateNow = DateTime.now();
    var difDays = dateNow
        .difference(lastAuthDate)
        .inHours;
    if (difDays >= 18) {
      return true;
    }
  }
  return false;

}
clearSetting()async {
  savePreference('estel_sklad', '-');
  savePreference('uid_user', '');
  savePreference('main_doc', '');
  savePreference('auth_date', '');
  savePreference('last_day', '');
}

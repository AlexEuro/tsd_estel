import 'package:flutter/material.dart';
import 'package:tsd_estel/Helpers/work_with_preference.dart';

import 'package:tsd_estel/UI/home_screen.dart';

import 'package:tsd_estel/UI/auth_New.dart';
import 'package:tsd_estel/helpers/helpers.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsd_estel/Helpers/exchange.dart';





late ObjectBoxBase objectBox;

late String sklad;
late String uid_user;
late String last_update;
late String main_doc;
late String auth_date;
late int warehouse_id;


Future main() async {
debugPrint(DateTime.now().toString());
  await WidgetsFlutterBinding.ensureInitialized();
  sklad = await getPreference('estel_sklad');
  uid_user = await getPreference('uid_user');
  last_update = await getPreference('last_update');
  main_doc = await getPreference('main_doc');
  auth_date = await getPreference('auth_date');

  final relogon =await needRelogon();
debugPrint(DateTime.now().toString());
  if(relogon==true){
    clearSetting();
    sklad = '-';
    }

debugPrint(DateTime.now().toString());
  objectBox = await ObjectBoxBase.init();
debugPrint(DateTime.now().toString());
  load_tovar_from_http();
  load_warehouse_from_http();
debugPrint(DateTime.now().toString());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Order App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3 : true,
      ),

      home: sklad == '-'?LoginPage():const HomeScreen(),

    );
  }
}


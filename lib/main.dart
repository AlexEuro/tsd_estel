import 'package:flutter/material.dart';

import 'package:tsd_estel/UI/home_screen.dart';

import 'package:tsd_estel/UI/Auth_new.dart';
import 'package:tsd_estel/helpers/helpers.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

late ObjectBoxBase objectBox;
late String sklad;
late String uid_user;

Future main() async {

  await WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  sklad = prefs.getString('estel_sklad')??'-';
  uid_user = prefs.getString('uid_user')??'-';
  objectBox = await ObjectBoxBase.init();
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


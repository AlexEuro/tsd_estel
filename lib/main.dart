import 'package:flutter/material.dart';

import 'package:tsd_estel/UI/home_screen.dart';
import 'package:tsd_estel/UI/Auth.dart';
import 'package:tsd_estel/helpers/helpers.dart';

import 'package:shared_preferences/shared_preferences.dart';

late ObjectBoxBase objectBox;
late String sklad;
Future main() async {

  await WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  sklad = prefs.getString('estel_sklad')??'-';
  await prefs.remove('estel_sklad');
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
      ),
      home: sklad == '-'?AuthScreen():const HomeScreen(),
    );
  }
}


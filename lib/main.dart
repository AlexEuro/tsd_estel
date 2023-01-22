import 'package:flutter/material.dart';

import 'package:tsd_estel/home_screen.dart';
import 'package:tsd_estel/helpers/helpers.dart';

late ObjectBoxBase objectBox;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  objectBox = await ObjectBoxBase.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Order App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}


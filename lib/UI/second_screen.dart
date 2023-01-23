
import 'package:flutter/material.dart';

import 'package:tsd_estel/Helpers/tovar.dart';






class LoadTovarScreen extends StatefulWidget {
  const LoadTovarScreen({Key? key}) : super(key: key);

  @override
  State<LoadTovarScreen> createState() => _LoadTovarScreen();
}

class _LoadTovarScreen extends State<LoadTovarScreen> {


  @override
  void initState() {
    super.initState();
    load_tovar_from_base();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('ObjectBox'),
      centerTitle: true,
    ),




  );
}


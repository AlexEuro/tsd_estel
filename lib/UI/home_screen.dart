import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import '../main.dart';

import 'package:tsd_estel/UI/view_tovar.dart';
import 'package:tsd_estel/UI/view_orders.dart';

import 'package:tsd_estel/UI/Auth_new.dart';

import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';

import 'bg_drawer.dart';

import 'package:ota_update/ota_update.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  late OtaEvent currentEvent ;

  String message="";


  late bool visible;

  late String skladCod;
  late String skladNaim;
  late String fio;

  @override
  void initState() {
    super.initState();
    tryOtaUpdate();
    var _str = sklad.split('#');
    if (_str.length>2) {
      skladCod =_str[0];
      skladNaim =_str[1];
      fio =_str[2];}
    else{
      fio ='';
      skladCod ='';
      skladNaim ='';

    }
    tryOtaUpdate();

  }
  @override
  void dispose() {

    super.dispose();
  }

  Future<void> tryOtaUpdate() async {
    String url='';
    try {
      final result = await InternetAddress.lookup('buhserv2008'); //15
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {

        url = 'http://192.168.1.15:3333/getfile';
      }
    } on SocketException catch (_) {

      url = 'http://62.141.114.156:5557/getfile';
    }
    try {
      //LINK CONTAINS APK OF FLUTTER HELLO WORLD FROM FLUTTER SDK EXAMPLES
      OtaUpdate()
          .execute(
        url,
        destinationFilename: 'flutter_hello_world.apk',
        headers: {'ver':'0.2'},
        //FOR NOW ANDROID ONLY - ABILITY TO VALIDATE CHECKSUM OF FILE:
        sha256checksum: 'c3dc2d7bb44ee6f287ca8cbc2d5b7fe3ccb1e89223a9b591db5cf689b429dcb0',
      )
          .listen(
            (OtaEvent event) {
          setState(() => currentEvent = event);
        },
      );
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      print('Failed to make OTA update. Details: $e');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.apps,
                color: Colors.lightBlueAccent, // Change Custom Drawer Icon Color
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        title: const Text('Estel'),
      ),
      body: Center(
             child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                 "Добро пожаловать!",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Text(
                  sklad == null ? '' : 'Склад: $fio ( $skladNaim ) ',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),

              ],
            ),

      ),
      drawer: Drawer(
        child: CustomPaint(
          painter: BackgroundDrawer(),
          child: Column(
            children: [
              Expanded(
                  child: ListView(
                    children: [
                      DrawerHeader(child:
                      UserAccountsDrawerHeader(
                        accountName: Text(skladNaim),
                        accountEmail: Text(fio),
                        currentAccountPicture: const CircleAvatar(
                          backgroundImage: AssetImage('images/logo3.jpg'),
                        ),
                        decoration: const BoxDecoration(),

                      ),
                      ),
                      ListTile(
                        leading: const Icon(Icons.account_balance),
                        title: const Text('Инвентаризации'),
                        subtitle:const Text('открыть список документов'),
                        onTap: (){
                          Navigator.push(    context,      MaterialPageRoute(builder: (context) => const OrdersScreen()),);
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.mail),
                        title: const Text('Список товаров'),
                      onTap:(){Navigator.push( context, MaterialPageRoute(builder: (context) => const TovarScreen()),
                      );},),

                      ListTile(
                        leading: const Icon(Icons.logout),
                        title: const Text('Сменить склад'),
                        subtitle: const Text('Sub title test'),
                      onTap: (){Dialogs.materialDialog(
                          msg: 'Сменить склад?',
                          title: "Авторизация",
                          color: Colors.white,
                          context: context,
                          actions: [
                            IconsOutlineButton(
                              onPressed: () { Navigator.pop(context);},
                              text: 'Нет',
                              iconData: Icons.cancel_outlined,
                              textStyle: TextStyle(color: Colors.grey),
                              iconColor: Colors.grey,
                            ),
                            IconsOutlineButton(
                              onPressed: () {Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) => LoginPage()));},
                              text: 'Да',
                              iconData: Icons.done,
                              color: Colors.red,
                              textStyle: TextStyle(color: Colors.white),
                              iconColor: Colors.white,
                            ),
                          ]);},),
                    ],

                  ))
            ],
          ),
        ),
      ),


    backgroundColor: Colors.blueGrey,);
  }

}



import 'package:flutter/material.dart';
import '../main.dart';

import 'package:tsd_estel/UI/view_tovar.dart';
import 'package:tsd_estel/UI/view_orders.dart';
import 'package:tsd_estel/UI/ResultInventory.dart';
import 'package:tsd_estel/UI/auth_New.dart';
import 'package:tsd_estel/UI/listPrihod.dart';

import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';

import 'bg_drawer.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {



  String message="";


  late bool visible;

  late String skladCod;
  late String skladNaim;
  late String fio;
  late bool ah;
  @override
  void initState() {
    super.initState();
   // tryOtaUpdate();


    var _str = sklad.split('#');

    if (_str.length>2) {
      skladCod =_str[0];
      var skladob = objectBox.getWarehouse(skladCod);
      skladNaim = '-';
      if (skladob ==null){
        warehouse_id =0;
      } else{warehouse_id = skladob.id;
      skladNaim = skladob.naim;
      }



      ah = skladob == null ? '-' : skladob.isAh;
      fio =_str[2];}
    else{
      fio ='';
      skladCod ='';
      skladNaim ='';

    }


  }
  @override
  void dispose() {

    super.dispose();
  }
  Future<String> getVersionNumber() async {


    return '1.1.8';


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
                Text(
                  ah == false ? 'Адресный склад не используется' : 'Адресный склад используется',
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
                        onTap: (){
                          Navigator.push(    context,      MaterialPageRoute(builder: (context) => const OrdersScreen()),);
                        },
                      ),
                      Visibility(child:  ListTile(
                        leading: const Icon(Icons.account_balance),
                        title: const Text('Результат пересчета'),

                        onTap: (){
                          Navigator.push(    context,      MaterialPageRoute(builder: (context) => ResultScreen(mainDoc: main_doc,)),);
                        },
                      ),
                      ),
                      Visibility(visible: ah,
                        child:  ListTile(
                        leading: const Icon(Icons.insert_drive_file_rounded),
                        title: const Text('Приёмка'),

                        onTap: (){
                          Navigator.push(    context,      MaterialPageRoute(builder: (context) => PrihodScreen()),);
                        },
                      ),
                      ),
                      ListTile(
                        leading: const Icon(Icons.mail),
                        title: const Text('Список товаров'),
                      onTap:(){Navigator.push( context, MaterialPageRoute(builder: (context) => const TovarScreen()),
                      );},),

                      ListTile(
                        leading: const Icon(Icons.logout),
                        title: const Text('Сменить склад'),

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

                  )
              ),Container( child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Column(
                    children: <Widget>[
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.info),
                        title: const Text('Версия'),
                        subtitle: FutureBuilder<String>(
                          future: getVersionNumber(),
                          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                            if (snapshot.hasData) {
                              return Text(snapshot.data!);
                            } else {
                              return const CircularProgressIndicator();
                            }
                          },
                        ),
                      ),
                    ],
                  ))),
            ],

          ),
        ),

      ),


    backgroundColor: Colors.blueGrey,);
  }

}



import 'package:flutter/material.dart';
import '../main.dart';

import 'package:tsd_estel/UI/view_tovar.dart';
import 'package:tsd_estel/UI/view_orders.dart';

import 'package:tsd_estel/UI/Auth_new.dart';

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

  @override
  void initState() {
    super.initState();
   // tryOtaUpdate();
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


  }
  @override
  void dispose() {

    super.dispose();
  }
  Future<String> getVersionNumber() async {


    return '1.0.8';


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
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.info),
                        title: Text('Версия'),
                        subtitle: FutureBuilder<String>(
                          future: getVersionNumber(),
                          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                            if (snapshot.hasData) {
                              return Text(snapshot.data!);
                            } else {
                              return CircularProgressIndicator();
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



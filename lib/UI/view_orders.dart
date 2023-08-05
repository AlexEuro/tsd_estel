import 'package:flutter/material.dart';

import 'package:tsd_estel/Helpers/exchange.dart';

import '../main.dart';
import 'package:tsd_estel/model/inventory.dart';

import 'package:tsd_estel/UI/docInventory.dart';
import 'package:tsd_estel/UI/editDocSettings.dart';
import 'package:tsd_estel/UI/auth_New.dart';
import 'package:tsd_estel/Helpers/work_with_preference.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late Stream<List<InventoryModel>> streamUsers;
  late bool allDocs;
   @override
  void initState() {
    super.initState();
    allDocs = true;
    streamUsers = objectBox.getorder(allDocs);
   }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Инвентаризации'),
      centerTitle: true,
    ),
    body:Column(
  mainAxisAlignment:MainAxisAlignment.start,
  crossAxisAlignment:CrossAxisAlignment.center,
  mainAxisSize:MainAxisSize.max,
  children: [
  SwitchListTile(
  autofocus: false,
  title: const Text('Выводить выгруженные'),
  value: allDocs,
  onChanged: (bool value) {
  setState(() {
  allDocs = value;
  streamUsers = objectBox.getorder(allDocs);
  });
  },
  ),
  Expanded(
  flex: 1,
  child:

    StreamBuilder<List<InventoryModel>>(
      stream: streamUsers,
      builder: (context, AsyncSnapshot<List<InventoryModel>> snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          final relogon =needRelogon().then((value) {if(value==true){
            clearSetting();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );};
          });
          final users = snapshot.data!;

          return ListView.separated(
            separatorBuilder: (context, index) => Divider(color: Colors.black),

            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              Color tileColor = user.isSend == true
                  ? Colors.red // Set red color if user.isSend is true
                  : user.ordered == true
                  ? Colors.deepOrangeAccent // Set orange color if user.send is true
                  : Colors.white;
              return ListTile(
                title: Text('Инвентаризация №' +user.id.toString() ),
                subtitle: Text(user.dateDoc+'('+user.items.length.toString()+')'),

                tileColor: user.isSend ==true ?Colors.deepOrangeAccent : Colors.white ,
                onTap: () {
                    if (user.isSend ==true){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DocSettingsScreen(docId: user.id)),
                      );

                    }
                    else{
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DocInventoryScreen(docId: user.id)),
                  );}
                }
                ,onLongPress: (){
                    var j = sendDoc(user).then((value) {
                    String textResult='';

                    if (value==0) {textResult='Выгружено успешно!';}
                        else if(value==-1)
                        {textResult='нет связи. попробуйте позже';}
                        else{textResult='Выгрузка не прошла';}

                      final snackBar = SnackBar(
                        content: Text(textResult),
                        backgroundColor:value==true?Colors.greenAccent:Colors.redAccent,
                        action: SnackBarAction(
                          label: 'отмена',
                          onPressed: () {
                          },
                        ),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    });
                 }
                ,);

            },
          );
        }
      },

    ),)]),
    floatingActionButton: FloatingActionButton.extended(
      splashColor: Colors.blueAccent,
      icon: Icon(Icons.add),
      label: Text('Создать'),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DocInventoryScreen(docId: 0)),
        );
      }

    ),

  );


}


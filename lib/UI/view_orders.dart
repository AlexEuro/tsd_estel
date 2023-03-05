
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:tsd_estel/Helpers/tovar.dart';

import '../main.dart';
import 'package:tsd_estel/model/orders.dart';

import 'package:tsd_estel/UI/docInventory.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late Stream<List<OrderModel>> streamUsers;

  bool _isLoading = false; // This is initially false where no loading stat


  @override
  void initState() {
    super.initState();
    streamUsers = objectBox.getorder();
   }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Инвентаризации'),
      centerTitle: true,
    ),
    body:
    StreamBuilder<List<OrderModel>>(
      stream: streamUsers,
      builder: (context, AsyncSnapshot<List<OrderModel>> snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          final users = snapshot.data!;

          return ListView.separated(
            separatorBuilder: (context, index) => Divider(color: Colors.black),

            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];

              return ListTile(
                title: Text(user.dateDoc),
                subtitle: Text(user.isSend.toString()),

                tileColor: user.isSend ==true ?Colors.deepOrangeAccent : Colors.white ,
                onTap: () {

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DocInventoryScreen(docId: user.id)),
                  );
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
                        backgroundColor: value==true?Colors.greenAccent:Colors.redAccent,
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

    ),
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


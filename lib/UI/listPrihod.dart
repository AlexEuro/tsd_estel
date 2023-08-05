import 'package:flutter/material.dart';

import 'package:tsd_estel/Helpers/exchange.dart';

import '../main.dart';
import 'package:tsd_estel/model/prihod.dart';

import 'package:tsd_estel/UI/docPrihod.dart';
import 'package:tsd_estel/UI/editDocSettings.dart';

class PrihodScreen extends StatefulWidget {
  const PrihodScreen({Key? key}) : super(key: key);

  @override
  State<PrihodScreen> createState() => _PrihodScreenState();
}

class _PrihodScreenState extends State<PrihodScreen> {
  late Stream<List<PrihodModel>> streamUsers;
  late bool allDocs;
  @override
  void initState() {
    super.initState();
    allDocs = true;
    streamUsers = objectBox.getPrihods(allDocs);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Приход'),
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
                streamUsers = objectBox.getPrihods(allDocs);
              });
            },
          ),
          Expanded(
            flex: 1,
            child:
            StreamBuilder<List<PrihodModel>>(
              stream: streamUsers,
              builder: (context, AsyncSnapshot<List<PrihodModel>> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  final users = snapshot.data!;

                  return ListView.separated(
                    separatorBuilder: (context, index) => const Divider(color: Colors.black),

                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      Color tileColor = user.isSend == true
                          ? Colors.red // Set red color if user.isSend is true
                          : user.ordered == true
                          ? Colors.deepOrangeAccent // Set orange color if user.send is true
                          : Colors.white;
                      return ListTile(
                        title: Text('Приёмка №' +user.id.toString() ),
                        subtitle: Text(user.dateDoc+'('+user.items.length.toString()+')'),

                        tileColor: tileColor ,
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
                              MaterialPageRoute(builder: (context) => DocPrihodScreen(docId: user.id)),
                            );}
                        }
                        ,onLongPress: (){
                         sendPrihodDoc(user).then((value) {
                          String textResult='';

                          if (value==0) {textResult='Выгружено успешно!';}
                          else if(value==-1)
                          {textResult='нет связи. попробуйте позже';}
                          else{textResult='Выгрузка не прошла';}

                          final snackBar = SnackBar(
                            content: Text(textResult),
                            backgroundColor:value==0?Colors.greenAccent:Colors.redAccent,
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
            MaterialPageRoute(builder: (context) => const DocPrihodScreen(docId: 0)),
          );
        }

    ),

  );


}


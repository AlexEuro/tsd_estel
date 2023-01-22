
import 'package:flutter/material.dart';

import 'package:tsd_estel/tovar.dart';

import 'main.dart';
import 'package:tsd_estel/model/user.dart';





class TovarScreen extends StatefulWidget {
  const TovarScreen({Key? key}) : super(key: key);

  @override
  State<TovarScreen> createState() => _TovarScreenState();
}

class _TovarScreenState extends State<TovarScreen> {
  late Stream<List<TovarDetail>> streamUsers;
  bool _isLoading = false; // This is initially false where no loading stat


  @override
  void initState() {
    super.initState();
    streamUsers = objectBox.gettovar();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('ObjectBox'),
      centerTitle: true,
    ),
    body:
         StreamBuilder<List<TovarDetail>>(
      stream: streamUsers,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          final users = snapshot.data!;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];

              return ListTile(
                title: Text(user.naim),
                subtitle: Text(user.sh),


 //               trailing: IconButton(
//                  icon: const Icon(Icons.delete),
//                  onPressed: () => print(user.naim),//objectBox.deleteUser(user.naim)   ,
//                ),
                //onTap: () {
                //  user.name = Faker().person.firstName();
                //  user.email = Faker().internet.email();
//
  //                objectBox.insertUser(user);
    //            },
              );
            },
          );
        }
      },
    ),
    floatingActionButton: FloatingActionButton.extended(
      splashColor: Colors.blueAccent,
      icon: _isLoading?Icon(Icons.history):Icon(Icons.sync),
      label: _isLoading?Text('Загружаю'):Text('Загрузить'),
      onPressed: () {
        //setState(() {
          _isLoading = true; // your loader has started to load
        //});
        load_tovar_from_base();
        //setState(() {
          _isLoading = false; // your loder will stop to finish after the data fetch
        print(_isLoading);
        //});
      },

    ),
  );
  }


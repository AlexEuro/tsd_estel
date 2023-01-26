
import 'package:flutter/material.dart';

import 'package:tsd_estel/Helpers/tovar.dart';

import '../main.dart';
import 'package:tsd_estel/model/products.dart';


import 'package:tsd_estel/UI/second_screen.dart';


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
   streamUsers = objectBox.getTovar();

  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Товары'),
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

        setState(() {
          _isLoading = true;
        });
        load_tovar_from_http();
  setState(() {
        _isLoading = false; });

      },

    ),
  );
  }


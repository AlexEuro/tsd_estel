import 'package:flutter/material.dart';

import 'package:tsd_estel/Helpers/tovar.dart';
import 'package:tsd_estel/model/products.dart';



import '../main.dart';


class TovarScreen extends StatefulWidget {
  const TovarScreen({Key? key}) : super(key: key);

  @override
  State<TovarScreen> createState() => _TovarScreenState();
}

class _TovarScreenState extends State<TovarScreen> {
  late Stream<List<TovarDetail>> streamUsers;
  String query ='';
  bool _isLoading = false; // This is initially false where no loading stat
  String buttonLabel = 'Загрузить';

  TextEditingController editingController = TextEditingController();
  @override
  void initState() {
    super.initState();

   streamUsers = objectBox.getTovar();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white54,
    appBar: AppBar(
      title: const Text('Номенклатура'),
      centerTitle: true,
    ),
    body:Container(
  child: Column(
  children: <Widget>[
  Padding(
  padding: const EdgeInsets.all(8.0),
  child: Visibility(
    visible: false,
    child: TextField(
  onChanged: (value) {

  },
  controller: editingController,

  decoration: InputDecoration(
  labelText: "поиск",
  hintText: "поиск",
  prefixIcon: Icon(Icons.search),
  border: OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(25.0)))),
  ),
  ),
  ),
  Expanded(child:
    StreamBuilder<List<TovarDetail>>(
     // initialData: _dataFromQuerySnapShot,
      stream: streamUsers,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
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
                title: Text(user.naim),
                subtitle: Text(user.sh),
              );
            },
          );
        }
      },
    ),
  ),
  ]),
  ),
    floatingActionButton: FloatingActionButton.extended(
      splashColor: Colors.blueAccent,
      icon: _isLoading?Icon(Icons.history):Icon(Icons.sync),
      label: Text(buttonLabel),//isLoading?Text('Загружаю'):Text('Загрузить'),
      onPressed: ()async  {

        setState(() {
          buttonLabel = 'Загружаю';
          _isLoading = true;
          debugPrint(DateTime.now().toString());
        });

         load_tovar_from_http().then((_) {
           setState(() {
             debugPrint(DateTime.now().toString());
             buttonLabel = 'Загрузить';
             _isLoading = false; });
         });


      },

    ),

  );
  }


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

   streamUsers = objectBox.getTovar('');
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
    TextFormField(autofocus: false,
      decoration: InputDecoration(hintText:'поиск'),
      onChanged:(value){
      setState(() {
        streamUsers = objectBox.getTovar(value);
      });
    },
    ),



  Expanded(child:
    StreamBuilder<List<TovarDetail>>(

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

         load_tovar_from_http().then((value) {
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


           setState(() {
             debugPrint(DateTime.now().toString());
             buttonLabel = 'Загрузить';
             _isLoading = false; });
         });


      },

    ),

  );
  }

class EmptyView extends StatelessWidget {
  const EmptyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(
          Icons.error,
          color: Colors.red,
        ),
        Text('no actor is found with this name'),
      ],
    );
  }
}
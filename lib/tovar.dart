import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';

import 'package:tsd_estel/Helpers/helpers.dart';
import 'package:tsd_estel/model/user.dart';
import 'main.dart';

//late ObjectBoxBase _objectBox;

Future load_tovar_from_base() async {

  var connection = PostgreSQLConnection(
      "192.168.1.15", // hostURL
      5432,                                                                               // port
      "spr_tovar",                                                         // databaseName
      username: "test",
      password: "test",
      useSSL: false
  );

  await connection.open();


  // _objectBox = await ObjectBoxBase.init();

  print("Connected");

  List<List<dynamic>> results = await connection.query("SELECT * FROM tovar", substitutionValues: {
    "aValue" : 3
  });

  for (final row in results) {
    var person = TovarDetail(uid: row[0], naim: row[1], ed: row[2],sh: row[3],cod:row[4]);


  var id =objectBox.addTovar(person);

  //  print("Sucessfull inserted an object with $id");
   print(row[0]);
    print(id);
    //var b = row[1];

  }
}

Future load() async {

}

abstract class Load_tovar extends StatelessWidget {
  operation();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Second screen')),
      body: Center(
        child: Text(
          'Barcode callback is not firing here because parent widget isn\'t visible',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );
  }
}
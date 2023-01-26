import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';

import 'package:tsd_estel/model/products.dart';
import '../main.dart';

import 'package:http/http.dart' as http;


//late ObjectBoxBase _objectBox;

void load_tovar_from_base() async {

  final response = await  http.get(Uri.parse('http://192.168.1.15:3333/gettovar'));


  var otvet = jsonDecode(response.body);

  var connection = PostgreSQLConnection(
      "192.168.1.15", // hostURL
      5432,                                                                               // port
      "spr_tovar",                                                         // databaseName
      username: "test",
      password: "test",
      useSSL: false
  );

  await connection.open();

  debugPrint("Connected");

  List<List<dynamic>> results = await connection.query("SELECT * FROM tovar");
  var result_count = results.length;
  List<TovarDetail> addList = [];
  int _tekPosition = 0;

  for (final row in results) {

    var person = TovarDetail(uid: row[0], naim: row[1], ed: row[2],sh: row[3],cod:row[4]);
    addList.add(person);

   // var id =objectBox.addTovar(person);

   // debugPrint(row[3]);
    _tekPosition =results.indexOf(row);

  }
  objectBox.addManyTovar(addList);
  print('!!');
  print(objectBox.getCount());



  connection.close();
  print(DateTime.now());
}

void load_tovar_from_http() async {

  final response = await  http.get(Uri.parse('http://192.168.1.15:3333/gettovar'));




  final List<dynamic> results = jsonDecode(response.body);
   var result_count = results.length;
  List<TovarDetail> addList = [];
  int _tekPosition = 0;

  for (final row in results) {

    var person = TovarDetail(uid: row['uid'], naim: row['naim'], ed: row['ed'],sh: row['shtrihcode'],cod:row['cod']);
    addList.add(person);

    // var id =objectBox.addTovar(person);

    // debugPrint(row[3]);
    _tekPosition =results.indexOf(row);

  }
  objectBox.addManyTovar(addList);
debugPrint(addList.length.toString());
 }

Future load() async {

}

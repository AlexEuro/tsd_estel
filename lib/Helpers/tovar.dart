import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';

import 'package:tsd_estel/model/products.dart';
import '../main.dart';
import 'package:tsd_estel/model/orders.dart';
import 'package:http/http.dart' as http;

import 'dart:io';
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

    var person = TovarDetail(uid: row[0], art: row[5], inPack:row[6],naim: row[1], ed: row[2],sh: row[3],cod:row[4]);
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

Future<bool> load_tovar_from_http() async {
  bool isLocal =false;
   String url='';
  try {
    final result = await InternetAddress.lookup('1s'); //15
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      print('connected');
      isLocal = true;
      url = 'http://192.168.1.15:3333/gettovar';


    }
  } on SocketException catch (_) {
    isLocal = false;
    url = 'http://62.141.114.156:5557/gettovar';
    print('not connected');
  }

    final response = await  http.get(Uri.parse(url));

  if (response.statusCode ==200) {debugPrint('connectes');}


  final List<dynamic> results = jsonDecode(response.body);
   var result_count = results.length;
  List<TovarDetail> addList = [];
  int _tekPosition = 0;

  for (final row in results) {

    var person = TovarDetail(uid: row['uid'], naim: row['naim'], ed: row['ed'],art: row['art'],inPack:row['inPack'],sh: row['shtrihcode'],cod:row['cod']);
    addList.add(person);

    _tekPosition =results.indexOf(row);

  }

  objectBox.addManyTovar(addList);
debugPrint(addList.length.toString());
    return true;
 }


Future<bool> sendDoc(OrderModel doc) async{
  String j;
  j = jsonEncode(doc);
  bool isLocal =false;
  String url='';
  try {
    final result = await InternetAddress.lookup('1s'); //15
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      print('connected');
      isLocal = true;
      url = 'http://192.168.1.15:3333/putdoc';
    }
  } on SocketException catch (_) {
    isLocal = false;
    url = 'http://62.141.114.156:5557/putdoc';
    print('not connected');
  }
  final response = await http.post(Uri.parse(url),
                  body: j,
      headers: {'Accept':'application/json','Content-Type': 'application/json'},
      );
  if (response.statusCode == 200 && response.body=='1'){

    doc.isSend = true;
    objectBox.PutOrder(doc);

  }

  return true;
}

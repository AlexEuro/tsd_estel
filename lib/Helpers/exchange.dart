import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:tsd_estel/Helpers/work_with_preference.dart';
import 'package:tsd_estel/model/Razmeshenie.dart';
import 'package:tsd_estel/model/products.dart';
import 'package:tsd_estel/model/inventory.dart';
import 'package:tsd_estel/model/prihod.dart';
import 'package:tsd_estel/model/warehouse.dart';
import '../main.dart';

import 'package:http/http.dart' as http;

import 'dart:io';




Future<int> load_tovar_from_http() async {

   String url='';
  try {
    final result = await InternetAddress.lookup('buhserv2008'); //15
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {

      url = 'http://192.168.1.15:3333/gettovar';
    }
  } on SocketException catch (_) {

    url = 'http://62.141.114.156:5557/gettovar';
  }

   try {
     final response = await  http.get(Uri.parse(url),headers: {'Accept':'application/json','day':last_update});
     if (response.statusCode == 200) {
     final List<dynamic> results = jsonDecode(response.body);

     List<TovarDetail> addList = [];

     for (final row in results) {

     var person = TovarDetail(uid: row['uid'], naim: row['naim'], ed: row['ed'],art: row['art'],inPack:row['inPack'],sh: row['shtrihcode'],cod:row['cod']);
     addList.add(person);
     }
     objectBox.addManyTovar(addList);
     debugPrint(addList.length.toString());
     savePreference('last_update', DateTime.now().toString());
     return 0;

     }
     else
     {return 1;}
   }
   on Exception catch (e) {return -1;}

 }


Future<int> sendDoc(InventoryModel doc) async{
  String j;
  doc.ordered = true;
  objectBox.PutOrder(doc);
  j = jsonEncode(doc);

  String url='';
  try {
    final result = await InternetAddress.lookup('buhserv2008'); //15
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      url = 'http://192.168.1.15:3333/putdoc';
    }
  } on SocketException catch (_) {
    url = 'http://62.141.114.156:5557/putdoc';
    debugPrint('not connected');
  }
  try {
  final response = await http.post(Uri.parse(url),
                  body: j,
      headers: {'Accept':'application/json','Content-Type': 'application/json'},
      ) ;
    if (response.statusCode == 200 && response.body=='1'){

    doc.isSend = true;
    objectBox.PutOrder(doc);
    return 0;

  }
  else
  {return 1;}
  }
  on Exception catch (e) {return -1;}


}

Future<int> sendPrihodDoc(PrihodModel doc) async{
  String j;
  doc.ordered = true;
  objectBox.PutPrihod(doc);
  j = jsonEncode(doc);

  String url='';
  try {
    final result = await InternetAddress.lookup('buhserv2008'); //15
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      url = 'http://192.168.1.15:3333/putprihod';
    }
  } on SocketException catch (_) {
    url = 'http://62.141.114.156:5557/putprihod';
    debugPrint('not connected');
  }
  try {
    final response = await http.post(Uri.parse(url),
      body: j,
      headers: {'Accept':'application/json','Content-Type': 'application/json'},
    ) ;
    if (response.statusCode == 200 && response.body=='1'){

      doc.isSend = true;
      objectBox.PutPrihod(doc);
      return 0;

    }
    else
    {return 1;}
  }
  on Exception catch (e) {return -1;}


}


Future<int> sendRazmeshenieDoc(RazmeshenieModel doc) async{
  String j;
  doc.finished = true;
  objectBox.PutRazmeshenie(doc);
  j = jsonEncode(doc);

  String url='';
  try {
    final result = await InternetAddress.lookup('buhserv2008'); //15
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      url = 'http://192.168.1.15:3333/putrazmeshenie';
    }
  } on SocketException catch (_) {
    url = 'http://62.141.114.156:5557/putrazmeshenie';
    debugPrint('not connected');
  }
  try {
    final response = await http.post(Uri.parse(url),
      body: j,
      headers: {'Accept':'application/json','Content-Type': 'application/json'},
    ) ;
    if (response.statusCode == 200 && response.body=='1'){

      doc.isSend = true;
      objectBox.PutRazmeshenie(doc);
      return 0;

    }
    else
    {return 1;}
  }
  on Exception catch (e) {return -1;}


}

Future<int> load_warehouse_from_http() async {

  String url='';
  try {
    final result = await InternetAddress.lookup('buhserv2008'); //15
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {

      url = 'http://192.168.1.15:3333/getwarehouse';
    }
  } on SocketException catch (_) {

    url = 'http://62.141.114.156:5557/getwarehouse';
  }

  try {
    final response = await  http.get(Uri.parse(url),headers: {'Accept':'application/json','day':last_update});
    if (response.statusCode == 200) {
      final List<dynamic> results = jsonDecode(response.body);

      List<WarehoseModel> addList = [];

      for (final row in results) {

        var person = WarehoseModel(uid: row['cod'], naim: row['naim'], isAh: row['itAh'],simpleAh: row['simpleAh']);
        addList.add(person);
      }
      objectBox.addManyWarehouse(addList);
      debugPrint(addList.length.toString());
      savePreference('last_update', DateTime.now().toString());
      return 0;

    }
    else
    {return 1;}
  }
  on Exception catch (e) {return -1;}

}

Future<int> load_transaction_from_http() async {
var max_day=objectBox.getDay();
final now = DateTime.now();
if (now.compareTo(max_day)>0){

};



  var url = 'http://192.168.1.15:3333/getwarehouse';


  try {
    final response = await  http.get(Uri.parse(url),headers: {'Accept':'application/json','day':last_update});
    if (response.statusCode == 200) {
      final List<dynamic> results = jsonDecode(response.body);

      List<WarehoseModel> addList = [];

      for (final row in results) {

        var person = WarehoseModel(uid: row['cod'], naim: row['naim'], isAh: row['itAh'],simpleAh: row['simpleAh']);
        addList.add(person);
      }
      objectBox.addManyWarehouse(addList);
      debugPrint(addList.length.toString());
      savePreference('last_update', DateTime.now().toString());
      return 0;

    }
    else
    {return 1;}
  }
  on Exception catch (e) {return -1;}

}
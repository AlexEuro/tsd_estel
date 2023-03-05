import 'dart:convert';

import 'package:flutter/material.dart';


import 'package:tsd_estel/model/products.dart';
import '../main.dart';
import 'package:tsd_estel/model/orders.dart';
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
     final response = await  http.get(Uri.parse(url));
     if (response.statusCode == 200) {
     final List<dynamic> results = jsonDecode(response.body);

     List<TovarDetail> addList = [];

     for (final row in results) {

     var person = TovarDetail(uid: row['uid'], naim: row['naim'], ed: row['ed'],art: row['art'],inPack:row['inPack'],sh: row['shtrihcode'],cod:row['cod']);
     addList.add(person);
     }
     objectBox.addManyTovar(addList);
     debugPrint(addList.length.toString());
     return 0;

     }
     else
     {return 1;}
   }
   on Exception catch (e) {return -1;};

 }


Future<int> sendDoc(OrderModel doc) async{
  String j;
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

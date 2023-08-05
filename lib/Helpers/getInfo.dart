import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:io';




  Future <List<Info>> getInfo(String doc) async {
    var res = <Info>[];
//    res.add(Info(art: '-', name: '-', onAccount: 1, onWarehouse: 1,diff:1));
    String url='';
    try {
      final result = await InternetAddress.lookup('buhserv2008'); //15
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {

        url = 'http://192.168.1.15:3333/getresult';
      }
    } on SocketException catch (_) {

      url = 'http://62.141.114.156:5557/getresult';
    }

    try {
      final response = await  http.get(Uri.parse(url),headers: {'Accept':'application/json','UK_doc':doc});
      if (response.statusCode == 200) {
        final List<dynamic> results = jsonDecode(response.body);

        List<Info> addList = [];

        for (final row in results) {
            var art=row['art'];
        var naim = row['naim'];

          var _info = Info(art: art==null?'-':art, naim: naim==null?'-':naim, onAccount: row['onAccount'],onWarehouse: row['onWarehouse'],diff: row['diff']);
          res.add(_info);
        }

        debugPrint(addList.length.toString());
        return res;

      }
      else
      {return res;}
    }
    on Exception catch (e) {return res;}

    //return res;
   }





class Info{
  String art ='';
  String naim ='';
  int onAccount =0;
  int onWarehouse =0;
  int diff =0;
  Info({
    required this.art,
    required this.naim,
    required this.onAccount,
    required this.onWarehouse,
    required this.diff

  });


}
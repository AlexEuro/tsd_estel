import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

import 'package:ota_update/ota_update.dart';
import 'package:path/path.dart';

class UpdateInfo {
  String url='';
  String hash='';
  String ver='';

  UpdateInfo({
    required this.url,
    required this.hash,
    required this.ver
  });
}

Future <UpdateInfo>GetInfoUpdate()async {
  UpdateInfo otvet=UpdateInfo(url:'',hash: '',ver:'');
  String url='';
  url = await GetUrl();

if (url!='') {
  try {
    final response = await http.get(Uri.parse(url + '/getlastversion'));
    if (response.statusCode == 200) {
      otvet.hash = response.headers['hash'].toString();
      otvet.ver = response.headers['ver'].toString();
      otvet.url = url + '/getfile';
    }
    else {
      return otvet;
    }
  }
  on Exception catch (e) {
    return otvet;
  };
}
  return otvet;
}

Future<void>tryOtaUpdate() async{
  late String url,hash,ver;
  hash ='';
  url ='';
  UpdateInfo updateInfo;
  updateInfo=await GetInfoUpdate();
  url = updateInfo.url;
  hash = updateInfo.hash;
  ver = updateInfo.ver;

    if (ver!='0.04'){
      try {
        debugPrint(url);
        OtaUpdate()
            .execute(
          url,
          destinationFilename: 'estel_tsd.apk',
         // sha256checksum: hash,
        )
            .listen(
              (OtaEvent event) {
          },
        );
        // ignore: avoid_catches_without_on_clauses
      } catch (e) {
        if (kDebugMode) {
          print('Failed to make OTA update. Details: $e');
        }
      }
    };
}

Future<String>GetUrl() async{

  String url='';
  try {
    final result = await InternetAddress.lookup('buhserv2008'); //15
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      url = 'http://192.168.1.15:3333';
    }
  } on SocketException catch (_) {
    url = 'http://62.141.114.156:5557';
  }

  return url;
}
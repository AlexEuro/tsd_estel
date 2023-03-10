import 'package:http/http.dart' as http;
import 'dart:io';

import 'package:ota_update/ota_update.dart';

class UpdateInfo {
  String url='';
  String hash='';

  UpdateInfo({
    required this.url,
    required this.hash
  });
}

Future <UpdateInfo>GetInfoUpdate()async {
  UpdateInfo otvet=UpdateInfo(url:'',hash: '');
  String url='';
  try {
    final result = await InternetAddress.lookup('buhserv2008'); //15
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      url = 'http://192.168.1.15:3333';
    }
  } on SocketException catch (_) {
    url = 'http://62.141.114.156:5557';
  }
  try {
    final response = await  http.get(Uri.parse(url+'/getlastversion'));
    if (response.statusCode == 200) {
      otvet.hash=response.headers['hash'].toString();
      otvet.url = url+'/getfile';

    }
    else
    {return otvet;}
  }
  on Exception catch (e) {return otvet;};




  return otvet;
}

Future<void> tryOtaUpdate() async {
  String url = '';
  var r= GetInfoUpdate();
  try {

    OtaUpdate()
        .execute(
      url+'/getfile',
      destinationFilename: 'estel_tsd.apk',
      headers: {'ver':'0.2'},
      //FOR NOW ANDROID ONLY - ABILITY TO VALIDATE CHECKSUM OF FILE:
      sha256checksum: 'c3dc2d7bb44ee6f287ca8cbc2d5b7fe3ccb1e89223a9b591db5cf689b429dcb0',
    )
        .listen(
          (OtaEvent event) {

      },
    );
    // ignore: avoid_catches_without_on_clauses
  } catch (e) {
    print('Failed to make OTA update. Details: $e');
  }
}
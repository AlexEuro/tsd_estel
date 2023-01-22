import 'dart:io';
import '../objectbox.g.dart';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'package:tsd_estel/model/user.dart';


class ObjectBoxBase {
  late final Store _store;
  //
  late final Box<TovarDetail> _personDetailBox;


  ObjectBoxBase._init(this._store) {
     _personDetailBox = Box<TovarDetail>(_store);
  }

  static Future<ObjectBoxBase> init() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final syncServerIp = Platform.isAndroid ? '10.0.2.2' : '127.0.0.1';
    final store = await openStore(directory: p.join(docsDir.path, "obx-example3"));
    Sync.client(
      store,
      'ws://$syncServerIp:9999', // wss for SSL, ws for unencrypted traffic
      SyncCredentials.none(),
    ).start();
    return ObjectBoxBase._init(store);
  }


 // User? getUser(int id) => _userBox.get(id);

  //Stream<List<User>> getUsers() => _userBox
//      .query()
//      .watch(triggerImmediately: true)
//      .map((query) => query.find());

  Stream<List<TovarDetail>> gettovar() => _personDetailBox
      .query()
      .watch(triggerImmediately: true)
      .map((query) => query.find());

//  int insertUser(User user) => _userBox.put(user);
  int addTovar(TovarDetail tovarDetail) => _personDetailBox.put(tovarDetail);

  getinfo(String sh) {
     final res = _personDetailBox.query(TovarDetail_.sh.equals(sh)).build().findFirst();

        return res == null ? 'Не найден' : 'Товар: '+res.naim;

  }
  closeStore(){_store.close();
  return _store.isClosed();}
   //  bool deleteUser(int id) => _userBox.remove(id);

}
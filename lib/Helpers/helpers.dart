import 'dart:io';
import '../objectbox.g.dart';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'package:tsd_estel/model/products.dart';
import 'package:tsd_estel/model/doc_inventory.dart';
import 'package:tsd_estel/model/inventory_line.dart';


class ObjectBoxBase {
  late final Store _store;
  //
  late final Box<TovarDetail> _personDetailBox;
  late final Box<DocInventoryModel> _docInventoryBox;
  late final Box<Inventory_line_Model> _lineInventoryBox;

  ObjectBoxBase._init(this._store) {
     _personDetailBox = Box<TovarDetail>(_store);
     _docInventoryBox = Box<DocInventoryModel>(_store);
     _lineInventoryBox = Box<Inventory_line_Model>(_store);

   //  _personDetailBox.removeAll();
  }

  static Future<ObjectBoxBase> init() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final syncServerIp = Platform.isAndroid ? '10.0.2.2' : '127.0.0.1';
    final store = await openStore(directory: p.join(docsDir.path, "obx-example6"));
    Sync.client(
      store,
      'ws://$syncServerIp:9999', // wss for SSL, ws for unencrypted traffic
      SyncCredentials.none(),
    ).start();
    return ObjectBoxBase._init(store);
  }



  Stream<List<TovarDetail>> getTovar() => _personDetailBox
      .query()
      .watch(triggerImmediately: true)
      .map((query) => query.find());

//  int insertUser(User user) => _userBox.put(user);

  int addTovar(TovarDetail tovarDetail) => _personDetailBox.put(tovarDetail);
  List addManyTovar(List<TovarDetail> tovarDetail) => _personDetailBox.putMany(tovarDetail);

  getCount() {
    return _personDetailBox.count();
  }

  getinfo(String sh) {
     final res = _personDetailBox.query(TovarDetail_.sh.equals(sh)).build().findFirst();

        return res == null ? 'Не найден' : 'Товар: '+res.naim;

  }
  closeStore(){_store.close();
  return _store.isClosed();}
   //  bool deleteUser(int id) => _userBox.remove(id);

  int addInventory(String docdate, String docUser) {
    var _doc =DocInventoryModel(dateDoc: docdate,user: docUser);
   return _docInventoryBox.put(_doc);
  }

}
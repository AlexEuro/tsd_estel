import 'dart:io';
import 'dart:math';
import 'package:tsd_estel/main.dart';

import '../objectbox.g.dart';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'package:tsd_estel/model/products.dart';



import 'package:tsd_estel/model/orders.dart';


class ObjectBoxBase {
  late final Store _store;
  //
  late final Box<TovarDetail> _personDetailBox;


  late final Box<OrderModel> _docInventoryBoxPlus;
  late final Box<ItemModel> _docInventoryLineBox;

  ObjectBoxBase._init(this._store) {
     _personDetailBox = Box<TovarDetail>(_store);

     _docInventoryBoxPlus = Box<OrderModel>(_store);

     _docInventoryLineBox = Box<ItemModel>(_store);

  }

  static Future<ObjectBoxBase> init() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final syncServerIp = Platform.isAndroid ? '10.0.2.2' : '127.0.0.1';
    final store = await openStore(directory: p.join(docsDir.path, "database_tsd"));
    Sync.client(
      store,
      'ws://$syncServerIp:9999', // wss for SSL, ws for unencrypted traffic
      SyncCredentials.none(),
    ).start();
    return ObjectBoxBase._init(store);
  }



  Stream<List<TovarDetail>> getTovar(String searchText)
  {
    if (searchText =='') {
      return _personDetailBox
          .query()
          .watch(triggerImmediately: true)
          .map((query) => query.find());
    }else{
      return _personDetailBox
          .query(TovarDetail_.sh.contains(searchText))
          .watch(triggerImmediately: true)
          .map((query) => query.find());
    }

  }



  List<TovarDetail> getTovar_list() => _personDetailBox
      .query().build().find();

  Stream<List<OrderModel>> getorder() => _docInventoryBoxPlus
      .query()
      .watch(triggerImmediately: true)
      .map((query) => query.find()
  );


  Stream<List<ItemModel>> getLineorder(int orderModel) => _docInventoryLineBox
      .query(ItemModel_.orderModel.equals(orderModel)).order(ItemModel_.id )
      .watch(triggerImmediately: true)
      .map((query) {
        var res = query.find();
        if (res.length ==0) {return res;}
        else{
          //return res.getRange(max (res.length-5,0),res.length ).toList();}}
          return res.getRange(0,res.length ).toList();}}
  );


  Stream<List<ItemModel>> getLineorder_limit(int orderModel) => _docInventoryLineBox
      .query(ItemModel_.orderModel.equals(orderModel)).order(ItemModel_.id)
      .watch(triggerImmediately: true)
      .map((query) {  final qr=query.find();  return qr.getRange(0, max(0, qr.length -5)).toList();}
  );

  List<OrderModel> getorder_list() => _docInventoryBoxPlus.
      query().build().find();

    int PutOrder(OrderModel orderModel) => _docInventoryBoxPlus.put(orderModel);

    int linePutOrder(ItemModel itemModel) {return _docInventoryLineBox.put(itemModel); }
//  int insertUser(User user) => _userBox.put(user);

  int addTovar(TovarDetail tovarDetail) => _personDetailBox.put(tovarDetail);
  List addManyTovar(List<TovarDetail> tovarDetail) => _personDetailBox.putMany(tovarDetail);

  getCount() {
    return _personDetailBox.count();
  }

  getinfo(String sh,String cod) {
    if (cod =='') {
      return _personDetailBox.query(TovarDetail_.sh.equals(sh)).build().findFirst();
    }else{
      return _personDetailBox.query(TovarDetail_.cod.equals(cod)).build().findFirst();
    }

  }
  closeStore(){
    _store.close();
  return _store.isClosed();
  }


  getOrder(int number ){
    if (number ==0 ){
      var idDoc = _docInventoryBoxPlus.put(OrderModel(dateDoc: DateTime.now().toString(),user: sklad));
      return _docInventoryBoxPlus.get(idDoc);
    }
    else {
      return _docInventoryBoxPlus.get(number);
    }

  }


}
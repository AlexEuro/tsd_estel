import 'dart:io';
//import 'dart:js_interop';
import 'dart:math';

import 'package:tsd_estel/main.dart';
import 'package:tsd_estel/model/warehouse.dart';
import 'package:tsd_estel/model/ah_transaction.dart';
import '../objectbox.g.dart';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'package:tsd_estel/model/products.dart';
import 'package:tsd_estel/model/Razmeshenie.dart';
import 'package:tsd_estel/model/prihod.dart';


import 'package:tsd_estel/model/inventory.dart';


class ObjectBoxBase {
  late final Store _store;
  //
  late final Box<TovarDetail> _personDetailBox;
  late final Box<WarehoseModel> _warehoseModelDetailBox;


  late final Box<InventoryModel> _docInventoryBoxPlus;
  late final Box<ItemModel> _docInventoryLineBox;

  late final Box<PrihodModel> _docPrihodBoxPlus;
  late final Box<ItemPrihodModel> _docPrihodLineBox;
  late final Box<RazmeshenieModel> _docRazmeshenieBoxPlus;
  late final Box<ItemRazmeshenieModel> _docRazmeshenieLineBox;
  late final Box<TransactionModel> _TransactionModelBox;
  ObjectBoxBase._init(this._store) {
     _personDetailBox = Box<TovarDetail>(_store);
     _warehoseModelDetailBox = Box<WarehoseModel>(_store);
     _docInventoryBoxPlus = Box<InventoryModel>(_store);

     _docInventoryLineBox = Box<ItemModel>(_store);

     _docPrihodBoxPlus = Box<PrihodModel>(_store);

     _docPrihodLineBox = Box<ItemPrihodModel>(_store);
     _docRazmeshenieBoxPlus = Box<RazmeshenieModel>(_store);

     _docRazmeshenieLineBox = Box<ItemRazmeshenieModel>(_store);
     _TransactionModelBox = Box<TransactionModel>(_store);
  }

  static Future<ObjectBoxBase> init() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final syncServerIp = Platform.isAndroid ? '10.0.2.2' : '127.0.0.1';
    final store = await openStore(directory: p.join(docsDir.path, "database_tsd_2023_04"));
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

  Stream<List<InventoryModel>> getorder(bool all) {
    if (all==true){
    return _docInventoryBoxPlus
      .query()
      .watch(triggerImmediately: true)
      .map((query) => query.find());}
    else{
      return _docInventoryBoxPlus
        .query(InventoryModel_.isSend.equals(false))
        .watch(triggerImmediately: true)
        .map((query) => query.find());}
  }


  Stream<List<ItemModel>> getLineorder(int inventoryModel) => _docInventoryLineBox
      .query(ItemModel_.inventoryModel.equals(inventoryModel)).order(ItemModel_.id )
      .watch(triggerImmediately: true)
      .map((query) {
        var res = query.find();
        if (res.length ==0) {return res;}
        else{
          //return res.getRange(max (res.length-5,0),res.length ).toList();}}
          return res.getRange(0,res.length ).toList();}}
  );


  Stream<List<ItemModel>> getLineorder_limit(int inventoryModel) => _docInventoryLineBox
      .query(ItemModel_.inventoryModel.equals(inventoryModel)).order(ItemModel_.id)
      .watch(triggerImmediately: true)
      .map((query) {  final qr=query.find();  return qr.getRange(0, max(0, qr.length -5)).toList();}
  );

  List<InventoryModel> getorder_list() => _docInventoryBoxPlus.
      query().build().find();

    int PutOrder(InventoryModel inventoryModel) => _docInventoryBoxPlus.put(inventoryModel);

    int linePutOrder(ItemModel itemModel) {return _docInventoryLineBox.put(itemModel); }

  int addTovar(TovarDetail tovarDetail) => _personDetailBox.put(tovarDetail);

    List addManyTovar(List<TovarDetail> tovarDetail) => _personDetailBox.putMany(tovarDetail);

  List addManyWarehouse(List<WarehoseModel> tovarDetail) => _warehoseModelDetailBox.putMany(tovarDetail);

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


  getOrder(int number ,String main_doc){
    if (number ==0 ){
      var idDoc = _docInventoryBoxPlus.put(InventoryModel(dateDoc: DateTime.now().toString(),user: sklad,mainDocUID: main_doc));

      return _docInventoryBoxPlus.get(idDoc);
    }
    else {
      return _docInventoryBoxPlus.get(number);
    }

  }


  getPrihod(int number ,String main_doc){
    if (number ==0 ){
      var idDoc = _docPrihodBoxPlus.put(PrihodModel(dateDoc: DateTime.now().toString(),user: sklad,mainDocUID: main_doc));

      return _docPrihodBoxPlus.get(idDoc);
    }
    else {
      return _docPrihodBoxPlus.get(number);
    }

  }
  Stream<List<PrihodModel>> getPrihods(bool all) {
    if (all==true){
      return _docPrihodBoxPlus
          .query()
          .watch(triggerImmediately: true)
          .map((query) => query.find());}
    else{
      return _docPrihodBoxPlus
          .query(PrihodModel_.isSend.equals(false))
          .watch(triggerImmediately: true)
          .map((query) => query.find());}
  }

  Stream<List<RazmeshenieModel>> getRazmeshenies(bool all) {
    if (all==true){
      return _docRazmeshenieBoxPlus
          .query()
          .watch(triggerImmediately: true)
          .map((query) => query.find());}
    else{
      return _docRazmeshenieBoxPlus
          .query(RazmeshenieModel_.isSend.equals(false))
          .watch(triggerImmediately: true)
          .map((query) => query.find());}
  }


  Stream<List<ItemPrihodModel>> getLinePrihod(int prihodModel) => _docPrihodLineBox
      .query(ItemPrihodModel_.prihodModel.equals(prihodModel)).order(ItemPrihodModel_.id )
      .watch(triggerImmediately: true)
      .map((query) {
    var res = query.find();
    if (res.length ==0) {return res;}
    else{

      return res.getRange(0,res.length ).toList();}}
  );

  int PutPrihod(PrihodModel prihodModel) => _docPrihodBoxPlus.put(prihodModel);
  int PutRazmeshenie(RazmeshenieModel razmeshenieModel) => _docRazmeshenieBoxPlus.put(razmeshenieModel);

  getWarehouse(String cod){
    return _warehoseModelDetailBox.query(WarehoseModel_.uid.equals(cod)).build().findFirst();
  }

  Stream<List<ItemRazmeshenieModel>> getLineRazmeshenie(int razmeshenieModel) => _docRazmeshenieLineBox
      .query(ItemRazmeshenieModel_.razmeshenieModel.equals(razmeshenieModel)).order(ItemRazmeshenieModel_.id )
      .watch(triggerImmediately: true)
      .map((query) {
    var res = query.find();
    if (res.length ==0) {return res;}
    else{

      return res.getRange(0,res.length ).toList();}}
  );

  getRazmeshenie(int number ){
    if (number ==0 ){
      var idDoc = _docRazmeshenieBoxPlus.put(RazmeshenieModel(dateDoc: DateTime.now().toString(),user: sklad));

      return _docRazmeshenieBoxPlus.get(idDoc);
    }
    else {
      return _docRazmeshenieBoxPlus.get(number);
    }
  }

  getSumm(int number,String cell ){
    var query = _TransactionModelBox.query(TransactionModel_.cell_uid.equals(cell)).build();
    var pq=query.property(TransactionModel_.count);
    return pq.sum();
  }
  getDay(){
    var query = _TransactionModelBox.query().build();
    var pq=query.property(TransactionModel_.timeTransaction);
    var res = pq.max();
    if (res==null){return DateTime(2023,01,01);}{return res;}
  }


  deleteFromTransaction(){
    var day = DateTime.now();
    var startOfDay = DateTime(day.year,day.month,day.day).millisecondsSinceEpoch;
    var list_id = _TransactionModelBox.query(TransactionModel_.timeTransaction.lessThan(startOfDay)).build().findIds();
    _TransactionModelBox.removeMany(list_id);
  }

  getTransactionToSync(){
    return _TransactionModelBox.query(TransactionModel_.sended.equals(true)).build().find();
  }
  int PutTransaction(TransactionModel model) => _TransactionModelBox.put(model);
  //-
}
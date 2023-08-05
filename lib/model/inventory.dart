import 'package:objectbox/objectbox.dart';


@Entity()
@Sync()

class InventoryModel {
  int id = 0;
  bool ordered = false;
  String dateDoc= '';
  String user= '';
  bool isSend = false;
  String comment= '';
  String mainDocUID= '';
  bool isfinalCount =  false;

  @Backlink()
  final items = ToMany<ItemModel>();
  InventoryModel({
    required this.dateDoc,
    required this.user,
    required this.mainDocUID

  });
  Map<String, dynamic> toJson() => {
    'id': id,
    'ordered': ordered,
    'isSend': isSend,
    'dateDoc': dateDoc,
    'user': user,
    'comment': comment,
    'mainDocUID': mainDocUID,
    'isfinalCount': isfinalCount,
    'items': items,
  };
}

@Entity()
@Sync()
class ItemModel {
  int id = 0;
  String sh;
  String itemName;
  int itemCount;

  String uid='';


  final inventoryModel = ToOne<InventoryModel>();

  ItemModel({
    required this.sh,
    required this.uid,
    required this.itemCount,
    required this.itemName,
  });
  Map<String, dynamic> toJson() => {
    'id': id,
    'sh': sh,
    'uid': uid,
    'itemName': itemName,
    'itemCount': itemCount,
  };
}

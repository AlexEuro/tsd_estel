import 'package:objectbox/objectbox.dart';

@Entity()
@Sync()
class PrihodModel {
  int id = 0;
  bool ordered = false;
  String dateDoc= '';
  String user= '';
  bool isSend = false;
  String comment= '';
  String mainDocUID= '';

  @Backlink()
  final items = ToMany<ItemPrihodModel>();
  PrihodModel({
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
    'items': items,
  };
}

@Entity()
@Sync()
class ItemPrihodModel {
  int id = 0;
  String sh;
  String pallet;
  String itemName;
  int itemCount;

  String uid='';
  final prihodModel = ToOne<PrihodModel>();
  ItemPrihodModel({
    required this.sh,
    required this.pallet,
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

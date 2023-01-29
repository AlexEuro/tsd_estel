import 'package:objectbox/objectbox.dart';


@Entity()
@Sync()

class OrderModel {
  int id = 0;
  bool ordered = false;
  String dateDoc= '';
  String user= '';

  @Backlink()
  final items = ToMany<ItemModel>();
  OrderModel({
    required this.dateDoc,
    required this.user,
  });
  Map<String, dynamic> toJson() => {
    'id': id,
    'ordered': ordered,
    'dateDoc': dateDoc,
    'user': user,
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

  final orderModel = ToOne<OrderModel>();

  ItemModel({
    required this.sh,
    required this.itemCount,
    required this.itemName,
  });
  Map<String, dynamic> toJson() => {
    'id': id,
    'itemName': itemName,
    'itemCount': itemCount,
  };
}



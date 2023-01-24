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
}

@Entity()
@Sync()
class ItemModel {
  int id = 0;
  String itemName;
  int itemCount;

  final orderModel = ToOne<OrderModel>();

  ItemModel({
    required this.itemCount,
    required this.itemName,
  });
}
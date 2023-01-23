import 'package:objectbox/objectbox.dart';

import 'doc_inventory.dart';

@Entity()
class Inventory_line_Model {
  int id = 0;
  String itemCod='';
  int itemCount=0;

  final doc = ToOne<DocInventoryModel>();
}
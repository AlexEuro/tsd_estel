import 'package:objectbox/objectbox.dart';

import 'doc_Inventory.dart';

@Entity()
class Inventory_line_Model {
  int id = 0;
  String itemCod='';
  String uid='';
  String shtirhcod='';
  int itemCount=0;

 //final doc = ToOne<DocInventoryModelPlus>();

  Inventory_line_Model({this.id=0,
    required this.itemCod,
    required this.itemCount,
    required this.uid,
    required this.shtirhcod
     });
}
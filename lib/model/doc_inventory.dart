import 'package:objectbox/objectbox.dart';
import 'package:tsd_estel/model/inventory_line.dart';


@Entity()
class DocInventoryModel {
  int id = 0;
  String dateDoc= '';
  String user= '';

  //final item = ToOne<Inventory_line_Model>();
  DocInventoryModel({this.id=0,
    required this.dateDoc,
    required this.user
    });
  }
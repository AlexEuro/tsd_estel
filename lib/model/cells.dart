import 'package:objectbox/objectbox.dart';

@Entity()
class CellsModel {
  int id = 0;
  String uid= '';
  String naim= '';
  String uidWarehouse= '';
  String defaultPallet= '';


  CellsModel({this.id=0,
    required this.uid,
    required this.naim,
    required this.uidWarehouse,
    required this.defaultPallet,

  });
}
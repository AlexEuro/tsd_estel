import 'package:objectbox/objectbox.dart';

@Entity()
class WarehoseModel {
  int id = 0;
  String uid= '';
  String naim= '';

  WarehoseModel({this.id=0,
    required this.uid,
    required this.naim
  });
}
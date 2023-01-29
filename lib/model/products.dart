import 'package:objectbox/objectbox.dart';

@Entity()
class TovarDetail {
  int id;
  String uid;
  String naim;
  String art;
  int inPack;
  String ed;
  @Index()
  @Unique(onConflict: ConflictStrategy.replace)
  String sh;
  String cod;

  TovarDetail({this.id=0,
    required this.uid,
    required this.naim,
    required this.art,
    required this.inPack,
    required this.ed,
    required this.sh,
    required this.cod});
}
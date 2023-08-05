import 'package:objectbox/objectbox.dart';
@Entity()
@Sync()

class RazmeshenieModel{
  int id = 0;
  bool finished = false;
  bool isSend = false;
  String dateDoc= '';
  String user= '';


  @Backlink()
  final items = ToMany<ItemRazmeshenieModel>();
  RazmeshenieModel({
    required this.dateDoc,
    required this.user


  });
  Map<String, dynamic> toJson() => {
    'id': id,
    'finished': finished,
    'isSend': isSend,
    'dateDoc': dateDoc,
    'user': user,


    'items': items,
  };
}

@Entity()
@Sync()
class ItemRazmeshenieModel {
  int id = 0;
  String sh_yacheika;
  String uid_yacheika;
  String naim_yacheika;
  String sh;
  String pallet;

  final razmeshenieModel = ToOne<RazmeshenieModel>();

  ItemRazmeshenieModel({
    required this.sh_yacheika,
    required this.uid_yacheika,
    required this.naim_yacheika,
    required this.sh,
    required this.pallet,

  });
  Map<String, dynamic> toJson() => {
    'id': id,
    'sh_Yacheika': sh_yacheika,
    'uidYacheika': uid_yacheika,
    'naimYacheika': naim_yacheika,
    'sh': sh,
    'pallet': pallet,

  };
}



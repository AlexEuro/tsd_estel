import 'package:objectbox/objectbox.dart';

@Entity()
class TransactionModel {
  int id = 0;
  @Property(type: PropertyType.date)
  DateTime timeTransaction;
  String user= '';
  @Index()
  String sklad_uid= '';
  @Index()
  String cell_uid= '';
  @Index()
  String pallet= '';
  @Index()
  String party_uid= '';
  @Index()
  String product_uid= '';
  int count= 0;
  @Index()
  bool sended= false;


  TransactionModel({this.id=0,
    required this.timeTransaction,
    required this.user,
    required this.sklad_uid,
    required this.cell_uid,
    required this.pallet,
    required this.party_uid,
    required this.product_uid,
    required this.count,
    required this.sended,
  });
  Map<String, dynamic> toJson() => {
    'id': id,
    'timeTransaction': timeTransaction,
    'cell_uid': cell_uid,
    'pallet': pallet,
    'party_uid': party_uid,
    'product_uid': product_uid,
    'count': count,

  };
}
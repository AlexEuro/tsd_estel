import 'package:flutter/material.dart';
import 'package:tsd_estel/model/orders.dart';



import 'package:visibility_detector/visibility_detector.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';

import '../main.dart';

class DocInventoryScreen extends StatefulWidget {
  const DocInventoryScreen({Key? key,
    required this.docId,
  }) : super(key: key);

  final int docId;

  @override
  State<DocInventoryScreen> createState() => _DocInventoryScreenState();
}

class _DocInventoryScreenState extends State<DocInventoryScreen> {

  FocusNode _focusNode = FocusNode();
  late OrderModel docInventory;
  late Stream<List<ItemModel>> streamUsers;

  final TextEditingController _controller = TextEditingController();

  String? _barcode;
  String? _tovar;
  late bool visible;


  int _idDoc=0;



  @override
  void initState() {
    super.initState();


    docInventory =  objectBox.getOrder(widget.docId);
    streamUsers = objectBox.getLineorder(docInventory.id );
    _controller.addListener(() {
      final String text = _controller.text.toLowerCase();
      _controller.value = _controller.value.copyWith(
        text: text,
        selection:
        TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
    });
  }
  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white54,
      appBar: AppBar(
        title: const Text('Estel'),
      ),
      body:
      Container(

        margin:EdgeInsets.all(0),
        padding:EdgeInsets.all(0),
        width:MediaQuery.of(context).size.width,
        height:MediaQuery.of(context).size.height,

        child:
        Column(
          mainAxisAlignment:MainAxisAlignment.start,
          crossAxisAlignment:CrossAxisAlignment.center,
          mainAxisSize:MainAxisSize.max,
          children: [
            Expanded(
              flex: 1,
              child:
              Container(
                child: Column(
                  children:
                  [
                    Expanded(
                      child:
                      StreamBuilder<List<ItemModel>>(
                        stream: streamUsers,
                        builder: (context, AsyncSnapshot<List<ItemModel>> snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            final users = snapshot.data!;

                            
                         return DataTable(columns: [
                         DataColumn(label: Text('ШК')),
                          DataColumn(label: Text('Наименование')),
                          DataColumn(label: Text('Количество')),

                         ],
                           rows: snapshot.data!
                               .map(
                                 (data) => DataRow(
                               cells: [
                                 DataCell(Text(data.sh)),
                                 DataCell(Text(data.itemName)),
                                 DataCell(Text(data.itemCount.toString())),
                                 // ...
                               ],
                             ),
                           )
                               .toList(),
                         );// ..., rows: rows)
                            
                            return ListView.separated(
                              separatorBuilder: (context, index) => Divider(color: Colors.black),
                              itemCount: users.length,
                              itemBuilder: (context, index) {
                                final user = users[index];
                                return ListTile(
                                  title: Text(user.itemName),
                                  subtitle: Text(user.itemCount.toString()),

                                  );

                              },
                            );
                          }
                        },

                      ),
                    ),
                    Center(

                      child:

                      Text(
                        _barcode == null ? 'Отсканируйте товар' : 'Товар: $_barcode ',
                        textAlign: TextAlign.center,
                        overflow:TextOverflow.clip,
                        style: Theme.of(context).textTheme.headlineSmall,

                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin:EdgeInsets.all(0),
              padding:EdgeInsets.all(0),
              width:MediaQuery.of(context).size.width,
              height:MediaQuery.of(context).size.height * 0.10,

              child:
              BarcodeKeyboardListener(
                  useKeyDownEvent: true,

                  bufferDuration: Duration(milliseconds: 400),
                  onBarcodeScanned: (barcode) {
                   if (barcode == '' ) {barcode = _controller.text;}
                    var split_barcode = barcode.split('#');
                    //todo
                    _controller.clear();


                    var tovar_info = objectBox.getinfo(barcode);
                    String itemName;
                    int itemCount;
                    if (tovar_info == null || tovar_info=='') {
                      itemName = '-';
                      itemCount =1;
                    } else{
                      itemName = tovar_info.art;
                      itemCount =tovar_info.inPack;
                    }
                    var str = ItemModel(sh: barcode, itemCount: itemCount,itemName: itemName);
                    docInventory.items.add(str);
                    objectBox.PutOrder(docInventory);
                   setState(() {
                     _focusNode.requestFocus();
                   });



                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      TextFormField(        controller: _controller,
                        autofocus: true,
                        focusNode: _focusNode,
                        onFieldSubmitted: (_) => _focusNode.requestFocus(),
                        decoration: const InputDecoration(border: OutlineInputBorder()),

                      ),
                    ],
                  ),
                ),
                       ),
          ],
        ),
      ),
    );
  }

}



import 'package:flutter/material.dart';
import 'package:tsd_estel/model/orders.dart';

import '../main.dart';

import 'package:audioplayers/audioplayers.dart';
import 'package:data_table_2/data_table_2.dart';

class DocInventoryScreen extends StatefulWidget {
  const DocInventoryScreen({Key? key,
    required this.docId,
  }) : super(key: key);

  final int docId;

  @override
  State<DocInventoryScreen> createState() => _DocInventoryScreenState();
}

class _DocInventoryScreenState extends State<DocInventoryScreen> {
final AudioPlayer audioPlayer = AudioPlayer();
  late int tekStage;

  late OrderModel docInventory;
  late Stream<List<ItemModel>> streamUsers;

  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late bool needcol;
  late bool visible;
  late double screenWidth;
  late FocusNode _focusNode ;
  int editLine = -1;
  @override
  void initState() {
    super.initState();


    tekStage = 1;
    needcol = false;
    _focusNode =FocusNode();


    docInventory =  objectBox.getOrder(widget.docId);

    streamUsers = objectBox.getLineorder(docInventory.id );
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void afterscan(String bar){

    if (tekStage == 1) {

      if (bar == '') {
        bar = _controller.text;
      }
      int itemCount;
      itemCount =0;
      var splitBarcode = bar.split('#');
      _controller.clear();
      String tovarCod;
      if (splitBarcode.length == 5 || splitBarcode.length == 6) {
        tovarCod = splitBarcode[0];
        itemCount =int.parse(splitBarcode[4]);
      } else {
        tovarCod = '';
      };

      var tovarInfo = objectBox.getinfo(bar, tovarCod);
      String itemName;
      String itemUid;

      if (tovarInfo == null || tovarInfo == '') {
        itemName = '-';

        audioPlayer.setVolume(100);
        audioPlayer.play(AssetSource('error.mp3'));

        itemUid = "";
        if (itemCount==0){
        itemCount = 1;}
      } else {
        itemName = tovarInfo.art;
        itemUid = tovarInfo.uid;
        if (itemCount==0){
        itemCount = tovarInfo.inPack;
        }
      }
      var str = ItemModel(sh: bar, itemCount: itemCount, itemName: itemName,uid:itemUid);



      docInventory.items.add(str);
      editLine = docInventory.items.length-1;
      objectBox.PutOrder(docInventory);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut,
          );
        }
      });
      if (needcol == true&&tekStage == 1) {
        setState(() {

          tekStage =2;})
        ;}

    }
    else{
      if (bar.length>6){
        audioPlayer.setVolume(100);
        audioPlayer.play(AssetSource('error.mp3'));
      }else{
        var lastLine =docInventory.items[editLine];
        lastLine.itemCount =  int.parse(bar);

        docInventory.items.add(lastLine);
        objectBox.PutOrder(docInventory);
        setState(() {tekStage = 1;});
      }
    }
    _controller.clear();
    _focusNode.requestFocus();
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(resizeToAvoidBottomInset:false,
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
            SwitchListTile(
              autofocus: false,
              title: const Text('Запрашивать количество'),
              value: needcol,
              onChanged: (bool value) {
                setState(() {
                  if (value==false){tekStage=1;}
                  needcol = value;
                  _focusNode.requestFocus();
                });
              },
            ),
            Expanded(
              flex: 1,
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
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (_scrollController.hasClients) {
                                _scrollController.animateTo(
                                  _scrollController.position.maxScrollExtent,
                                  duration: Duration(milliseconds: 50),
                                  curve: Curves.easeOut,
                                );
                              }
                            });
                            return

                              Padding(
                                  padding: const EdgeInsets.all(16),
                                  child:
                                  DataTable2(
                                    scrollController: _scrollController,
                                dataTextStyle: const TextStyle(color: Colors.lightGreenAccent),
                                  columnSpacing: 16,
                                  border: TableBorder.all(width: 1),

                                  headingRowColor:
                                  MaterialStateColor.resolveWith((states) => Colors.blue),

                                columns: <DataColumn2>[
                                  DataColumn2(
                                    size:ColumnSize.L,
                                    label: const Text('ШК', style: TextStyle(fontStyle: FontStyle.italic)),
                                  ),

                                  DataColumn2(
                                    label: const Text(                                  'Артикул',
                                      style: TextStyle(fontStyle: FontStyle.italic),
                                    ),
                                    numeric: false,
                                  ),
                                  DataColumn2(
                                      size:ColumnSize.S,
                                    label: const Text(
                                      'Кол',
                                      style: TextStyle(fontStyle: FontStyle.italic),
                                    ),
                                    numeric: true
                                  ),
                                ],
                                rows: users.asMap()
                                    .map((index, item) => MapEntry(
                                  index,
                                  DataRow(
                                    color: MaterialStateColor.resolveWith((Set<MaterialState> states) => states.contains(MaterialState.selected)
                                      ? Colors.grey
                                      : Colors.blueGrey
                                  ),

                                    onLongPress:(){
                                      //editLine = docInventory.items.singleWhere((id) => id = item.id);
                                      
                                    //if (docInventory.items.length>5)
                                    //{editLine =  docInventory.items.length -5+index;}
                                    //else{editLine =  index;}
                                      editLine =  index;
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            ListTile(
                                              leading: const Icon(Icons.edit),
                                              title: const Text('Поправить'),
                                              onTap: () {
                                                Navigator.pop(context);
                                                tekStage = 2;
                                                editLine = docInventory.items.indexWhere((value)=>value.id==item.id);

                                                _controller.text = item.itemCount.toString();
                                                _focusNode.requestFocus();

                                                _controller.selection = TextSelection.fromPosition(TextPosition(offset: _controller.text.length));
                                              },
                                            ),
                                            ListTile(
                                              leading: const Icon(Icons.delete),
                                              title: const Text('Удалить'),
                                              onTap: () {
                                                setState(() {
                                                  Navigator.pop(context);
                                                  var findIndex = docInventory.items.indexWhere((value)=>value.id==item.id);
                                                  docInventory.items.removeAt(findIndex);
                                                  docInventory.items.applyToDb();
                                                });
                                                    },
                                            ),

                                          ],
                                        );
                                      },
                                    );
                                  },

                                    cells: [
                                      DataCell(Text(item.sh)),
                                      DataCell(Text(item.itemName)),
                                      DataCell(Text(item.itemCount.toString())),
                                    ],
                                  ),
                                ))
                                    .values
                                    .toList() )

                          );

                          }
                        }),
            ),


            Container(
              margin:EdgeInsets.all(0),
              padding:EdgeInsets.all(0),
              width:MediaQuery.of(context).size.width,
              height:MediaQuery.of(context).size.height * 0.11,

              child:
              TextFormField(
                      focusNode: _focusNode,
                      autofocus: true,
                      onFieldSubmitted: (value) {
                        if (value.isNotEmpty){
                          afterscan(value);
                        _controller.clear();}
                        },
                        //textInputAction: TextInputAction.go,
                      controller: _controller,
                        decoration: InputDecoration(hintText: tekStage==1? 'Отсканируйте штрихкод' : 'Введите количество'),

                    ),
               // ),

                       ),
          ],
        ),
      ),


    );
  }

}

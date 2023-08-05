
import 'package:flutter/material.dart';
import 'package:tsd_estel/model/prihod.dart';
import 'package:vibration/vibration.dart';

import '../main.dart';

//import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';


import 'package:audioplayers/audioplayers.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:tsd_estel/UI/editDocSettings.dart';

class DocPrihodScreen extends StatefulWidget {
  const DocPrihodScreen({Key? key,
    required this.docId,
  }) : super(key: key);

  final int docId;

  @override
  State<DocPrihodScreen> createState() => _DocPrihodScreenState();
}

class _DocPrihodScreenState extends State<DocPrihodScreen> {
final AudioPlayer audioPlayer = AudioPlayer();
  late int tekStage;
  late int docID;
  late PrihodModel docPrihod;
  late Stream<List<ItemPrihodModel>> streamUsers;

  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late bool needcol;
  late bool needPallet;
  late bool visible;
  late double screenWidth;
  late FocusNode _focusNode ;
  String pallet='';
  List<String> textHint=['Отсканируйте паллет','Штрих-код номенклатуры','Введите количество'];
  int editLine = -1;
  @override
  void initState() {
    super.initState();

    tekStage = 1;
    needcol = false;
    needPallet = false;
    _focusNode =FocusNode();

    _controller.addListener(() {

      if (_focusNode.hasFocus==false){
        _focusNode.requestFocus();
      }});

    docPrihod =  objectBox.getPrihod(widget.docId,main_doc);

    streamUsers = objectBox.getLinePrihod(docPrihod.id );
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
        Vibration.vibrate(duration: 1000

        );
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
      var str = ItemPrihodModel(sh: bar, itemCount: itemCount, itemName: itemName,uid:itemUid,pallet: '-');
      docPrihod.items.add(str);
      editLine = docPrihod.items.length-1;
      objectBox.PutPrihod(docPrihod);
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
        var lastLine =docPrihod.items[editLine];
        lastLine.itemCount =  int.parse(bar);

        docPrihod.items.add(lastLine);
        objectBox.PutPrihod(docPrihod);
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
      appBar: AppBar(actions: <Widget>[


        IconButton(
          icon: const Icon(Icons.settings),
          tooltip: 'Свойства',
          onPressed: () {
            Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>DocSettingsScreen(docId: docPrihod.id))
            ,
          ).then((value) {_focusNode.requestFocus();});},
        ),
      ],
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
            ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(
                      color: Colors.teal,
                      width: 2.0,
                    ),
                  ),
                ),
              ),
              child: Text('Сменить паллет'),
              onPressed: () {
                if(tekStage==1){
                  setState(() {
                    tekStage=0;
                    pallet ='';
                  });
                }
              },
            ),
            Expanded(
              flex: 1,
              child:
                      StreamBuilder<List<ItemPrihodModel>>(
                        stream: streamUsers,

                        builder: (context, AsyncSnapshot<List<ItemPrihodModel>> snapshot) {

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
                                  duration: const Duration(milliseconds: 50),
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
                                                editLine = docPrihod.items.indexWhere((value)=>value.id==item.id);

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
                                                  var findIndex = docPrihod.items.indexWhere((value)=>value.id==item.id);
                                                  docPrihod.items.removeAt(findIndex);
                                                  docPrihod.items.applyToDb();
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
              child:Focus(onFocusChange: (focused) {
                  _focusNode.requestFocus();
                },
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
                        decoration: InputDecoration(hintText: textHint[tekStage]),

                    ),
                )
              ),
               // ),



          ],
        ),
      ),
    );


  }

}

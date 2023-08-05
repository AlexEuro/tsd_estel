
import 'package:flutter/material.dart';
import 'package:tsd_estel/model/Razmeshenie.dart';
import 'package:vibration/vibration.dart';

import '../main.dart';


import 'package:audioplayers/audioplayers.dart';
import 'package:data_table_2/data_table_2.dart';


class DocRazmeshenieScreen extends StatefulWidget {
  const DocRazmeshenieScreen({Key? key,
    required this.docId,
  }) : super(key: key);

  final int docId;

  @override
  State<DocRazmeshenieScreen> createState() => _DocRazmeshenieScreenState();
}

class _DocRazmeshenieScreenState extends State<DocRazmeshenieScreen> {
  final AudioPlayer audioPlayer = AudioPlayer();
  late int tekStage;
  late int docID;
  late RazmeshenieModel docRazmeshenie;
  late Stream<List<ItemRazmeshenieModel>> streamUsers;

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

    docRazmeshenie =  objectBox.getPrihod(widget.docId,main_doc);

    streamUsers = objectBox.getLineRazmeshenie(docRazmeshenie.id );
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
      var str = ItemRazmeshenieModel(sh_yacheika:'',uid_yacheika:'',sh: bar, pallet: '-',naim_yacheika: '');
      docRazmeshenie.items.add(str);
      editLine = docRazmeshenie.items.length-1;
      objectBox.PutRazmeshenie(docRazmeshenie);
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
        var lastLine =docRazmeshenie.items[editLine];


        docRazmeshenie.items.add(lastLine);
        objectBox.PutRazmeshenie(docRazmeshenie);
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
        title: const Text('Размещение'),
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
              StreamBuilder<List<ItemRazmeshenieModel>>(
                  stream: streamUsers,

                  builder: (context, AsyncSnapshot<List<ItemRazmeshenieModel>> snapshot) {

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
                                    label: const Text(                                  'Ячейка',
                                      style: TextStyle(fontStyle: FontStyle.italic),
                                    ),
                                    numeric: false,
                                  ),
                                  DataColumn2(
                                      size:ColumnSize.S,
                                      label: const Text(
                                        'Паллет',
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



                                    cells: [
                                      DataCell(Text(item.sh)),
                                      DataCell(Text(item.naim_yacheika)),
                                      DataCell(Text(item.pallet)),
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

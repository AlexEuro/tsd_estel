import 'package:flutter/material.dart';
import 'package:tsd_estel/model/orders.dart';

import 'package:flutter/services.dart';

import 'package:visibility_detector/visibility_detector.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';
import 'package:input_with_keyboard_control/input_with_keyboard_control.dart';
import 'package:numeric_keyboard/numeric_keyboard.dart';
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

  late int tekStage;

  late OrderModel docInventory;
  late Stream<List<ItemModel>> streamUsers;

  final TextEditingController _controller = TextEditingController();
  late bool needcol;
  late bool visible;
  late InputWithKeyboardControlFocusNode _focusNode ;
  @override
  void initState() {
    super.initState();


    tekStage = 1;
    needcol = false;
    _focusNode =InputWithKeyboardControlFocusNode();

    _focusNode.addListener((){
      ///Whether the currently listening TextFeild has gained the input focus
      bool hasFocus = _focusNode.hasFocus;
      ///Whether the current focusNode has been added
      bool hasListeners = _focusNode.hasListeners;

      print("focusNode hasFocus:$hasFocus hasListeners:$hasListeners");
    });

    docInventory =  objectBox.getOrder(widget.docId);
    streamUsers = objectBox.getLineorder(docInventory.id );

    _controller.addListener(() {
    //  SystemChannels.textInput.invokeMethod('TextInput.hide');
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

    super.dispose();
  }

  void afterscan(String bar){

    if (tekStage == 1) {

      if (bar == '') {
        bar = _controller.text;
      }
      var split_barcode = bar.split('#');
      _controller.clear();
      String tovar_cod;
      if (split_barcode.length == 5 || split_barcode.length == 6) {
        tovar_cod = split_barcode[0];
      } else {
        tovar_cod = '';
      };
      var tovar_info = objectBox.getinfo(bar, tovar_cod);
      String itemName;
      int itemCount;
      if (tovar_info == null || tovar_info == '') {
        itemName = '-';
        itemCount = 1;
      } else {
        itemName = tovar_info.art;
        itemCount = tovar_info.inPack;
      }
      var str = ItemModel(sh: bar, itemCount: itemCount, itemName: itemName);
      docInventory.items.add(str);
      if (tekStage ==1&&needcol ==true){tekStage =2;}
    }else{
      var allItems = docInventory.items;

      docInventory.items[allItems.length-1].itemCount =  int.parse(bar);
      tekStage = 1;   }

    objectBox.PutOrder(docInventory);



   // SystemChannels.textInput.invokeMethod('TextInput.hide');
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
                  needcol = value;
                });
              },
            ),
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
                            return
                              ListView.builder(

                                itemCount: users.length,
                                itemBuilder: (context, index) {
                                  final user = users[index];

                                  return ListTile(
                                    title: Text(user.sh +'('+user.itemName+')'),
                                    subtitle: Text(user.itemCount.toString()),

                                  );
                                },
                              );
                          }
                        }),)
                  ],
                ),
              ),
            ),
            Container(
              margin:EdgeInsets.all(0),
              padding:EdgeInsets.all(0),
              width:MediaQuery.of(context).size.width,
              height:MediaQuery.of(context).size.height * 0.11,

              child:
              BarcodeKeyboardListener(

                  useKeyDownEvent: true,

                  bufferDuration: Duration(milliseconds: 400),

                  onBarcodeScanned: (barcode) {

                    afterscan(barcode);
                    _controller.clear();
                    _focusNode.unfocus();
                    FocusScope.of(context).requestFocus(_focusNode);

                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[


                      InputWithKeyboardControl(
                      focusNode: _focusNode,
                      onSubmitted: (value) {
                  //print(value);

                      },
                      autofocus: true,
                      controller: _controller,
                      width: 300,
                      startShowKeyboard: false,
                      buttonColorEnabled: Colors.blue,
                      buttonColorDisabled: Colors.black,
                      underlineColor: Colors.black,
                      showUnderline: true,
                      showButton: false,
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

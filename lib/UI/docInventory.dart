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

  late FocusNode myFocusNode;
  final docInventory = objectBox.getOrder( 0);//widget.docId;


  final TextEditingController _controller = TextEditingController();

  String? _barcode;
  String? _tovar;
  late bool visible;


  int _idDoc=0;



  @override
  void initState() {
    super.initState();

    myFocusNode = FocusNode();

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
    myFocusNode.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estel'),
      ),
      body:Container(
        margin:EdgeInsets.all(0),
        padding:EdgeInsets.all(0),
        width:MediaQuery.of(context).size.width,
        height:MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color:Color(0x1f000000),
          shape:BoxShape.rectangle,
          borderRadius:BorderRadius.zero,
          border:Border.all(color:Color(0x4d9e9e9e),width:1),
        ),
        child:

        Column(
          mainAxisAlignment:MainAxisAlignment.start,
          crossAxisAlignment:CrossAxisAlignment.center,
          mainAxisSize:MainAxisSize.max,
          children: [
            Expanded(
              flex: 1,
              child:
              Center(

                child:
                Text(
                  _barcode == null ? 'Отсканируйте товар' : 'Товар: $_barcode ',
                  textAlign: TextAlign.center,
                  overflow:TextOverflow.clip,
                  style: Theme.of(context).textTheme.headlineSmall,

                ),
              ),
            ),
            Container(
              margin:EdgeInsets.all(0),
              padding:EdgeInsets.all(0),
              width:MediaQuery.of(context).size.width,
              height:MediaQuery.of(context).size.height * 0.10,

              child:
              VisibilityDetector(
                onVisibilityChanged: (VisibilityInfo info) {
                  visible = info.visibleFraction > 0;
                },
                key: Key('visible-detector-key'),
                child: BarcodeKeyboardListener(
                  useKeyDownEvent: true,

                  bufferDuration: Duration(milliseconds: 400),

                  onBarcodeScanned: (barcode) {
                    if (!visible) return;
                    //if (docInventory == null) docInventory = objectBox.getOrder(0);//widget.docId
                    if (barcode == '' ) {barcode = _controller.text;}
                    var split_barcode = barcode.split('#');
                    //todo

                    var str = ItemModel(itemCount: 1,itemName: barcode);
                    docInventory.items.add(str                  );


                    if (split_barcode.length == 3) {

                      //-todo
                    }
                    else {
                      _controller.clear();
                      myFocusNode.unfocus();

                      myFocusNode.requestFocus();
                    }


                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      TextFormField(        controller: _controller,
                        autofocus: true,
                        focusNode: myFocusNode,
                        decoration: const InputDecoration(border: OutlineInputBorder()),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],),
      ),
    );
  }

}

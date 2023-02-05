import 'package:flutter/material.dart';
import 'package:tsd_estel/model/orders.dart';


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

    //_controller.addListener(() {
    //  SystemChannels.textInput.invokeMethod('TextInput.hide');
    //      final String text = _controller.text.toLowerCase();
    //  _controller.value = _controller.value.copyWith(
    //    text: text,
    //    selection:
    //    TextSelection(baseOffset: text.length, extentOffset: text.length),
    //    composing: TextRange.empty,
    //  );
    //});
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
      editLine = docInventory.items.length-1;
      objectBox.PutOrder(docInventory);
      if (needcol == true&&tekStage == 1) {
        setState(() {

          tekStage =2;})
        ;}

    }
    else{



       var lastLine =docInventory.items[editLine];
       lastLine.itemCount =  int.parse(bar);
       tekStage = 1;
       docInventory.items.add(lastLine);
       objectBox.PutOrder(docInventory);


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
                            return
                              ListView.separated(
                                separatorBuilder: (context, index) => Divider(color: Colors.black),
                                itemCount: users.length,
                                itemBuilder: (context, index) {
                                  final user = users[index];
                                  return ListTile(
                                    title: Text(user.sh +'('+user.itemName+')'),
                                    subtitle: Text(user.itemCount.toString()),
                                    trailing:
                                      IconButton(onPressed: (){
                                        setState(() {
                                          tekStage = 2;
                                          _controller.text = user.itemCount.toString();
                                        if (docInventory.items.length>5)
                                        {editLine =  docInventory.items.length -5+index;}
                                          else{editLine =  index;}
                                          _focusNode.requestFocus();
                                        });
                                        debugPrint(index.toString());}, icon: Icon(Icons.edit)),


                                    );
                                },
                              );
                          }
                        }),),


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

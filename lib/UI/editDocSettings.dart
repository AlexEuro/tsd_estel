

import 'package:flutter/material.dart';
import 'package:tsd_estel/model/inventory.dart';

import '../main.dart';
import 'package:flutter/services.dart';

class DocSettingsScreen extends StatefulWidget {
  const DocSettingsScreen({Key? key,
    required this.docId,
  }) : super(key: key);

  final int docId;

  @override
  State<DocSettingsScreen> createState() => _DocSettingsScreenState();
}

class _DocSettingsScreenState extends State<DocSettingsScreen> {

  late int tekStage;

  late InventoryModel docInventory;


  final TextEditingController _controller = TextEditingController();
  final TextEditingController _controllerComment = TextEditingController();
  late bool needcol;
  late bool visible;
  late double screenWidth;


  @override
  void initState() {
    docInventory = objectBox.getOrder(widget.docId,main_doc);

    super.initState();
    afterStart();

  }

  void afterStart() async{
    setState(() {
      needcol = docInventory.isfinalCount;
      _controllerComment.text = docInventory.comment;
      _controller.text = docInventory.mainDocUID;
    });
  }
  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
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
              title: const Text('Проверка результата'),
              value: needcol,

              onChanged: (bool value) {
                docInventory.isfinalCount = value;
                objectBox.PutOrder(docInventory);
                setState(() {
                  needcol = value;
                });
              },
            ),
            Text('Документ по данным 1с'),

                TextFormField(
              controller: _controller,
              onChanged: (value){ docInventory.mainDocUID = value;
              objectBox.PutOrder(docInventory);},
              decoration: InputDecoration(hintText:'Отсканируйте штрихкод пересчета товаров 1С'),

            ),
            Text('Комментарий'),
            TextFormField(

             controller: _controllerComment,
              onChanged: (value){ docInventory.comment = value;
              objectBox.PutOrder(docInventory);},
              onTap: (){SystemChannels.textInput.invokeMethod('TextInput.show');},
              decoration: InputDecoration(hintText:'Комментарий'),

            ),



          ],
        ),
      ),


    );
  }

}

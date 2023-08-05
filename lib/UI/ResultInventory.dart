
import 'package:flutter/material.dart';
import 'package:tsd_estel/Helpers/getInfo.dart';
import 'package:tsd_estel/main.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({Key? key,
    required this.mainDoc,
  }) : super(key: key);

  final String mainDoc;

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {

 final TextEditingController _controller = TextEditingController();
  late List<Info> resList=<Info>[];
  late double screenWidth;
  late String doc = '';


  @override
  void initState() {
  super.initState();
  getInfo(main_doc).then((result) {
    setState(() {
      resList = result;
    });
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
        title: const Text('Результат инвентаризации'),
      ),
      body:
      SingleChildScrollView(
        child:
        Column(
          mainAxisAlignment:MainAxisAlignment.start,
          crossAxisAlignment:CrossAxisAlignment.center,
          mainAxisSize:MainAxisSize.max,
          children: [
            const Text('Документ по данным 1с'),

            TextFormField(
              controller: _controller,

              onChanged: (value){
                          getInfo(value).then((result){
                setState(() {
                resList=result;
            });}
          );
              },
              decoration: const InputDecoration(hintText:'Отсканируйте штрихкод пересчета товаров 1С'),
            ),
            SingleChildScrollView(child:
            DataTable(headingRowHeight:0,
                columns: const <DataColumn>[
              DataColumn(label: Text('Артикул', style: TextStyle(fontStyle: FontStyle.italic)),),
              DataColumn(

                label: Text('Наименование', style: TextStyle(fontStyle: FontStyle.italic)),
              ),DataColumn(

                label: Text('Разница', style: TextStyle(fontStyle: FontStyle.italic)),
              ),]

          ,
                rows:  resList.map((data) => DataRow(cells: [
                  DataCell(Text(data.art)),
                  DataCell( Text(data.naim)),
                  DataCell(Text(data.diff.toString())),
                ])).toList()
            )
            )
          ],
        ),
      ),


    );
  }

}
List<DataRow> getRows(List<Info> users) => users.map((Info user) {
  final cells = [user.art, user.naim, user.diff];

  return DataRow(cells: getCells(cells));
}).toList();

List<DataCell> getCells(List<dynamic> cells) =>
    cells.map((data) => DataCell(Text('$data'))).toList();


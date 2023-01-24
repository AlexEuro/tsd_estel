import 'package:flutter/material.dart';
import 'package:tsd_estel/UI/docInventory.dart';



import 'package:visibility_detector/visibility_detector.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';

import '../main.dart';

import 'package:tsd_estel/UI/view_tovar.dart';
import 'package:tsd_estel/UI/view_orders.dart';
import 'package:tsd_estel/UI/Auth.dart';





class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  final TextEditingController _controller = TextEditingController();

  String? _barcode;
  String? _tovar;
  late bool visible;
  int _selectedIndex = 0;
  int _idDoc=0;
  void _onItemTapped(int index) {
   // if (index == 1){operation();}
    if (index == 1){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const TovarScreen()),
      );}
    if (index == 2){
     // final docInventory = objectBox.getOrder();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const DocInventoryScreen(docId: 0)),
      );

    }
    if (index == 4){
      Navigator.pushReplacement(
          context,
          new MaterialPageRoute(
              builder: (BuildContext context) => new AuthScreen()));
    }
    if (index == 3){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const OrdersScreen()),
      );
    }
    setState(() {
      _selectedIndex = index;
    });
  }


  @override
  void initState() {
    super.initState();

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

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Estel '+sklad),
      ),
      body: Center(
        // Add visiblity detector to handle barcode
        // values only when widget is visible
        child: VisibilityDetector(
          onVisibilityChanged: (VisibilityInfo info) {
            visible = info.visibleFraction > 0;
          },
          key: Key('visible-detector-key'),
          child: BarcodeKeyboardListener(
            bufferDuration: Duration(milliseconds: 300),
            onBarcodeScanned: (barcode) {
              if (!visible) return;
              var tovar = objectBox.getinfo(barcode);

              print(barcode);
              print(tovar);

              setState(() {
                _barcode = barcode;
                _tovar = tovar;
              });
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  _barcode == null ? 'Отсканируйте товар' : 'Штрихкод: $_barcode ',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Text(
                  _tovar == null ? '' : 'Товар: $_tovar ',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                TextFormField(        controller: _controller,
                  decoration: const InputDecoration(border: OutlineInputBorder()),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mail),
            label: 'Товары',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_document),
            label: 'Создать Документ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.exit_to_app),
            label: 'Документы',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.exit_to_app),
            label: 'Сменить склад',
          ),

         ],
        currentIndex: _selectedIndex,
        backgroundColor: Colors.lightBlue,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }

}

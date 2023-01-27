import 'package:flutter/material.dart';

import 'package:visibility_detector/visibility_detector.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';
import '../main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tsd_estel/UI/home_screen.dart';
class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {


  final TextEditingController _controller = TextEditingController();

  String? _barcode;

  late bool visible;

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
  void save_sklad(String _sklad) async{
    sklad = _sklad;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('estel_sklad', _sklad);

}
  void _doOpenPage() {
    Navigator.pushReplacement(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) => new HomeScreen()));
    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text('Estel'),

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
            bufferDuration: Duration(milliseconds: 400),
            onBarcodeScanned: (barcode) {

              if (!visible) return;
              if (barcode=='') {barcode = _controller.text;}
              setState(() {
                var _str = barcode.split('#');

                save_sklad(barcode);
                _doOpenPage();
              });
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  _barcode == null ? 'Отсканируйте qr для авторизации' : 'Склад: $_barcode ',
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

    );
  }

}

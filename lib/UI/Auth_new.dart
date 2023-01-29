import 'package:flutter/material.dart';

import 'package:visibility_detector/visibility_detector.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';

import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import 'package:tsd_estel/UI/home_screen.dart';

import 'bg_drawer.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State {
  final TextEditingController _controller = TextEditingController();
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
      body: CustomPaint(
        painter: BackgroundDrawer(),//BackgroundSignIn(),
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: <Widget>[
                  _getHeader(),
                  _getHeader_dop(),
                  VisibilityDetector(
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
                                                    save_sklad(barcode);
                          _doOpenPage();
                        });
                      },
                      child:_getInputs(_controller),
                    ),
                  ),
                  //_getSignIn(),
                  //_getBottomRow(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

_getHeader() {
  return Expanded(
    flex: 1,
    child: Container(
      alignment: Alignment.bottomCenter,
      child: Text(
        'Добро пожаловать',

        style: TextStyle(color: Colors.white, fontSize: 37),
      ),

    ),
  );
}
_getHeader_dop() {
  return Expanded(
    flex: 2,
    child: Container(
      alignment: Alignment.bottomCenter,
      child: Text(
        'Отсканируйте QR для начала работы',
        style: TextStyle(color: Colors.white, fontSize: 37),
      ),

    ),
  );
}
_getInputs(_controller) {
  return Expanded(
    flex: 4,
    child: Column(

      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        TextFormField(        controller: _controller,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        const SizedBox(
          width: 200.0,
          height: 10,

        )
      ],
    ),
  );
}




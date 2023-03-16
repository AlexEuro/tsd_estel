import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import 'package:tsd_estel/UI/home_screen.dart';
import 'package:uuid/uuid.dart';


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

  late bool showInput;
  @override
  void initState() {
    super.initState();
    showInput = false;

  }

      @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }
  @override
  void save_sklad(String _sklad) async{
    sklad = _sklad;

    uid_user = Uuid().v1();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('estel_sklad', _sklad);
    await prefs.setString('uid_user', uid_user);

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

                  Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[   Row(
                        mainAxisAlignment:MainAxisAlignment.start,
                        crossAxisAlignment:CrossAxisAlignment.center,
                        mainAxisSize:MainAxisSize.max,
                        children:[

                          Expanded(
                            flex: 1,
                            child:
                            TextFormField(   autofocus: true,autocorrect: false,
                              controller: _controller,
                              textInputAction:  TextInputAction.newline,
                              decoration: const InputDecoration(border: OutlineInputBorder()),
                              style: TextStyle(color: Colors.white),
                              onFieldSubmitted: (barcode) {
                              if (barcode=='') {barcode = _controller.text;}
                              var _str = barcode.split('#');
                              if (_str.length ==3){
                                setState(() {
                                save_sklad(barcode);
                                _doOpenPage();
                                });
      _controller.clear();
      };

                          } ,
                            ),

                          ),

                        ],
                      ),
                      ]
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

import 'package:flutter/material.dart';

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


  String message="";


  late bool visible;
  int _selectedIndex = 0;
    void _onItemTapped(int index) {

    if (index == 1){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const TovarScreen()),
      );}
    if (index == 2){
     // final docInventory = objectBox.getOrder();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const OrdersScreen()),
      );

    }
    if (index == 3){
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => AuthScreen()));
    }
    if (index == 4){

    }
    setState(() {
      _selectedIndex = index;
    });
  }


  @override
  void initState() {
    super.initState();


  }
  @override
  void dispose() {

    super.dispose();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Estel '+sklad),
      ),
      body: Center(
             child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                 "Добро пожаловать!",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Text(
                  sklad == null ? '' : 'Склад: $sklad ',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),

              ],
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
            icon: Icon(Icons.account_balance),
            label: 'Документы',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.exit_to_app),
            label: 'Сменить склад',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.connecting_airports),
            label: 'Go',
          ),
         ],
        currentIndex: _selectedIndex,
        backgroundColor: Colors.lightBlue,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    backgroundColor: Colors.blueGrey,);
  }

}

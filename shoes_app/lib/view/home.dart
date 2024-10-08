import 'package:flutter/material.dart';
import 'app_home.dart';
import 'cart.dart';
import 'orders.dart';

class HomePage extends StatefulWidget {

  int? sIdx = 0;




  HomePage({
    super.key,
    this.sIdx = 0
    });

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late int _selectedIndex;
  
  static const List<Widget> _widgetOptions = <Widget>[
    AppHome(),
    CartPage(),
    Orders(),
  ];



  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.sIdx!;
  }


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: '장바구니',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: '구매내역',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue, // 선택된 항목의 색상
        unselectedItemColor: Colors.grey, // 선택되지 않은 항목의 색상
        backgroundColor: Colors.deepPurple[50], // 네비게이션 바의 배경색
        onTap: _onItemTapped,
      ),
    );
  }
}

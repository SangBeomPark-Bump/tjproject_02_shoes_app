import 'package:flutter/material.dart';
import 'package:shoes_app/view/management/m_branch.dart';
import 'package:shoes_app/view/management/m_customer.dart';
import 'package:shoes_app/view/management/m_date.dart';
import 'package:shoes_app/view/management/m_product.dart';

class MHome extends StatefulWidget {
  const MHome({super.key});

  @override
  _MHomeState createState() => _MHomeState();
}

class _MHomeState extends State<MHome> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    MBranch(),
    MDate(),
    MCustomer(),
    MProduct()
  ];

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
            label: '지점별',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: '날짜별',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '손님별',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.production_quantity_limits),
            label: '상품별',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,  // 선택된 항목의 색상
        unselectedItemColor: Colors.grey,  // 선택되지 않은 항목의 색상
        backgroundColor: Colors.white,  // 네비게이션 바의 배경색
        onTap: _onItemTapped,
      ),
    );
  }
}

// m_home.dart

import 'package:flutter/material.dart';
import 'package:shoes_app/view/management/m_branch.dart';
import 'package:shoes_app/view/management/m_customer.dart';
import 'package:shoes_app/view/management/m_date.dart';
import 'package:shoes_app/view/management/m_product.dart';

class MHome extends StatefulWidget {
  const MHome({super.key});

  @override
  MHomeState createState() => MHomeState();
}

class MHomeState extends State<MHome> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const MBranch(),   // MBranch는 정확한 StatefulWidget 또는 StatelessWidget이어야 합니다.
    const MDate(),     // MDate도 정확한 StatefulWidget 또는 StatelessWidget이어야 합니다.
    const MCustomer(), // MCustomer도 정확한 StatefulWidget 또는 StatelessWidget이어야 합니다.
    const MProduct()   // MProduct도 정확한 StatefulWidget 또는 StatelessWidget이어야 합니다.
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
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}

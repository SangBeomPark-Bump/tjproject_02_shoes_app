import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shoes_app/model/branch.dart';
import 'package:shoes_app/model/customer.dart';
import 'package:shoes_app/model/made_order_psb.dart';
import 'package:shoes_app/model/order.dart';
import 'package:shoes_app/model/shoes.dart';
import 'package:shoes_app/vm/database_handler.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  // Property
  late DatabaseHandler handler;

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('테스트 입니다!'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  pressed();
                },
                child: const Text('신발')),
            ElevatedButton(
                onPressed: () {
                  pressed2();
                },
                child: const Text('손님')),
            ElevatedButton(
                onPressed: () {
                  pressed3();
                },
                child: const Text('지점')),
            ElevatedButton(
                onPressed: () {
                  pressed4();
                },
                child: const Text('주문')),
          ],
        ),
      ),
    );
  }

  pressed() async {
    // 변환하고자 하는 이미지 경로
    List imageList = [
      await loadAssetAsBinary('images/newb_red.png'),
      await loadAssetAsBinary('images/newb_white.png'),
      await loadAssetAsBinary('images/nike_black.png'),
      await loadAssetAsBinary('images/nike_red.png'),
      await loadAssetAsBinary('images/prosp_black.png'),
      await loadAssetAsBinary('images/prosp_red.png'),
    ];
    List<Shoes> shoes = [
      Shoes(
          shoesname: 'Newbalance Red',
          price: 100000,
          image: imageList[0],
          size: 265,
          brand: 'newBalance'),
      Shoes(
          shoesname: 'Newbalance White',
          price: 100000,
          image: imageList[1],
          size: 255,
          brand: 'newBalance'),
      Shoes(
          shoesname: 'NIKE Black',
          price: 120000,
          image: imageList[2],
          size: 265,
          brand: 'NIKE'),
      Shoes(
          shoesname: 'NIKE Red',
          price: 120000,
          image: imageList[3],
          size: 255,
          brand: 'NIKE'),
      Shoes(
          shoesname: 'Prospecs Black',
          price: 130000,
          image: imageList[4],
          size: 265,
          brand: 'prosPecs'),
      Shoes(
          shoesname: 'Prospecs Red',
          price: 130000,
          image: imageList[5],
          size: 255,
          brand: 'prosPecs'),
    ];
    for (Shoes shoe in shoes) {
      handler.insertShoe(shoe);
    }

    List<Shoes> result = await (handler.queryShoes());
    print(result);
  }

//FUnctions
  Future<Uint8List> loadAssetAsBinary(String assetPath) async {
    // assetPath는 Asset 이미지의 경로 예: 'assets/images/sample.png'
    ByteData byteData = await rootBundle.load(assetPath); // 이미지 로드
    Uint8List imageBytes =
        byteData.buffer.asUint8List(); // ByteData를 Uint8List로 변환
    return imageBytes;
  }

  pressed2() async {
    List<Customer> customers = [
      Customer(
          id: 'yubee',
          password: '123',
          name: '유비',
          phone: '010-1234-5678',
          email: 'yubee@naver.com',
          rnumber: '621004-1'),
      Customer(
          id: 'gwanwoo',
          password: '123',
          name: '관우',
          phone: '010-1234-5678',
          email: 'gwanwoo@naver.com',
          rnumber: '151104-1'),
      Customer(
          id: 'jannbee',
          password: '123',
          name: '장비',
          phone: '010-1234-5678',
          email: 'jannbee@naver.com',
          rnumber: '830806-1'),
      Customer(
          id: 'yeopho',
          password: '123',
          name: '여포',
          phone: '010-1234-5678',
          email: 'yeopho@naver.com',
          rnumber: '951114-1'),
      Customer(
          id: 'choseon',
          password: '123',
          name: '초선',
          phone: '010-1234-5678',
          email: 'choseon@naver.com',
          rnumber: '890715-2'),
      Customer(
          id: 'heonje',
          password: '123',
          name: '헌제',
          phone: '010-1234-5678',
          email: 'heonje@naver.com',
          rnumber: '000121-1'),
    ];

    for (Customer customer in customers) {
      handler.insertCustomer(customer);
    }
    List<Customer> result = await (handler.queryCustomer());
    print(result);
  }

  pressed3() async {
    List<Branch> branches = [
      Branch(branchname: '강남점'),
      Branch(branchname: '신도림점'),
      Branch(branchname: '노원점'),
    ];

    for (Branch branches in branches) {
      handler.insertBranch(branches);
    }
    List<Customer> result = await (handler.queryCustomer());
    print(result);
  }

  pressed4() async {
    List<Customer> customers = [
      Customer(
          id: 'yubee',
          password: '123',
          name: '유비',
          phone: '010-1234-5678',
          email: 'yubee@naver.com',
          rnumber: '621004-1'),
      Customer(
          id: 'gwanwoo',
          password: '123',
          name: '관우',
          phone: '010-1234-5678',
          email: 'gwanwoo@naver.com',
          rnumber: '151104-1'),
      Customer(
          id: 'jannbee',
          password: '123',
          name: '장비',
          phone: '010-1234-5678',
          email: 'jannbee@naver.com',
          rnumber: '830806-1'),
      Customer(
          id: 'yeopho',
          password: '123',
          name: '여포',
          phone: '010-1234-5678',
          email: 'yeopho@naver.com',
          rnumber: '951114-1'),
      Customer(
          id: 'choseon',
          password: '123',
          name: '초선',
          phone: '010-1234-5678',
          email: 'choseon@naver.com',
          rnumber: '890715-2'),
      Customer(
          id: 'heonje',
          password: '123',
          name: '헌제',
          phone: '010-1234-5678',
          email: 'heonje@naver.com',
          rnumber: '000121-1'),
    ];

    for (Customer customer in customers) {
      handler.insertCustomer(customer);
    }
    List<Customer> result = await (handler.queryCustomer());
    print(result);
  }
}//End
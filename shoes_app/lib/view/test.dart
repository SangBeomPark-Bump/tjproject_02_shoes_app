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
    handler.initializeDB();
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
            ElevatedButton(
                onPressed: () {
                  seqMaker();
                },
                child: const Text('프린트')),
            ElevatedButton(
                onPressed: () {
                  initButton();
                },
                child: const Text('주문목록 초기화')),
          ],
        ),
      ),
    );
  }

//7e80af51e89yu83


//Functions
  pressed() async {
    handler.initializeDB();
    // 변환하고자 하는 이미지 경로
    List<Shoes> shoes = await MadeOrderPsb().shoes();
    for (Shoes shoe in shoes) {
      handler.insertShoe(shoe);
    }

    List<Shoes> result = await (handler.queryShoes());
    print(result.length);
  }

  Future<Uint8List> loadAssetAsBinary(String assetPath) async {
    // assetPath는 Asset 이미지의 경로 예: 'assets/images/sample.png'
    ByteData byteData = await rootBundle.load(assetPath); // 이미지 로드
    Uint8List imageBytes =
        byteData.buffer.asUint8List(); // ByteData를 Uint8List로 변환
    return imageBytes;
  }

  pressed2() async {
    handler.initializeDB();

    List<Customer> customers = MadeOrderPsb().customer();

    for (Customer customer in customers) {
      handler.insertCustomer(customer);
    }
    List<Customer> result = await (handler.queryCustomer());
    print(result.length);
  }

  pressed3() async {
    handler.initializeDB();
    List<Branch> branches = MadeOrderPsb().branch();

    for (Branch branches in branches) {
      handler.insertBranch(branches);
    }
    List<Branch> result = await (handler.queryBranch());
    print(result.length);
  }

  pressed4() async {
    handler.initializeDB();
    List<Order> orders = MadeOrderPsb().order();

    for (Order order in orders) {
      handler.insertOrder(order);
      order.seqMaker();
    }
    List<Order> result = await (handler.queryOrder());
    print(result.length);
  }

  seqMaker()async{
    List<Order> aaa = await handler.queryOrder();
    for ( Order i in aaa){
      print(i.pickuptime);
    }
  }

  initButton(){
    handler.removeOrdered();
  }

}//End

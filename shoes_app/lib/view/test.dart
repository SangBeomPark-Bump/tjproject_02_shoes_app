import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shoes_app/model/branch.dart';
import 'package:shoes_app/model/customer.dart';
import 'package:shoes_app/model/made_order_psb.dart';
import 'package:shoes_app/model/order.dart';
import 'package:shoes_app/model/shoes.dart';
import 'package:shoes_app/view/home.dart';
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
        actions: [
          ElevatedButton(onPressed: () => Get.to(HomePage()), child: Icon(Icons.home_outlined))
        ],
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
    List<Shoes> shoes = await MadeOrderPsb().shoes();
    for (Shoes shoe in shoes) {
      handler.insertShoe(shoe);
    }

    List<Shoes> result = await (handler.queryShoes());
    print(result);
  }

//Functions
  Future<Uint8List> loadAssetAsBinary(String assetPath) async {
    // assetPath는 Asset 이미지의 경로 예: 'assets/images/sample.png'
    ByteData byteData = await rootBundle.load(assetPath); // 이미지 로드
    Uint8List imageBytes =
        byteData.buffer.asUint8List(); // ByteData를 Uint8List로 변환
    return imageBytes;
  }

  pressed2() async {
    List<Customer> customers = MadeOrderPsb().customer();

    for (Customer customer in customers) {
      handler.insertCustomer(customer);
    }
    List<Customer> result = await (handler.queryCustomer());
    print(result);
  }

  pressed3() async {
    List<Branch> branches = MadeOrderPsb().branch();

    for (Branch branches in branches) {
      handler.insertBranch(branches);
    }
    List<Branch> result = await (handler.queryBranch());
    print(result);
  }

  pressed4() async {
    List<Order> orders = MadeOrderPsb().order();

    for (Order order in orders) {
      handler.insertOrder(order);
      order.seqMaker();
    }
    List<Order> result = await (handler.queryOrder());
    print(result.length);
  }

  seqMaker(){
    Order order = Order(branch_branchcode: 2, customer_id: 'ff', shoes_seq: 3, order_seq: 1, quantity: 60, paymenttime: DateTime.now());
    order.seqMaker();
    print(order.seq);
  }

}//End

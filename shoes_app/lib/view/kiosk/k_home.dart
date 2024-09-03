import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shoes_app/model/kiosk.dart';
import 'package:shoes_app/model/order.dart';
import 'package:shoes_app/view/orders.dart';
import 'package:shoes_app/vm/database_handler_management.dart';
import 'package:shoes_app/vm/database_kiosk_handler.dart';

class KHome extends StatefulWidget {
  const KHome({super.key});

  @override
  State<KHome> createState() => _KHomeState();
}

class _KHomeState extends State<KHome> {
  late TextEditingController orderSeqController;
  DatabaseKioskHandler kioskHandler = DatabaseKioskHandler();
  final box = GetStorage();
  late List<Map<String,dynamic>> myshoes;
  late String orderNum;
  late int branchcode;
  Kiosk? curKiosk;

  @override
  void initState() {
    super.initState();
    orderSeqController = TextEditingController();
    box.read('kioskID');
    myshoes =[];
    orderNum = "";
    branchcode =3;
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/shoes_kiosk.png'),
          fit: BoxFit.fill
          )
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: const Text("제품 수령",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 40
            ),
            ),
          ),
          body: SingleChildScrollView(
            child: Center(
                child: Column(
              children: [
                          Padding(
                  padding: const EdgeInsets.only(top: 130,right: 200, left: 200),
                  child: TextField(
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9a-z]'))
                    ],
                    controller: orderSeqController,
                    decoration: const InputDecoration(
                      labelStyle: TextStyle(fontSize: 25),
                      labelText: "주문번호",
                      ), 
                    maxLength: 15,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 30,
                    ),
                  ),
                ),
                Padding(
                  padding: const  EdgeInsets.only(top: 20, bottom: 10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(200, 55),
                      backgroundColor: Colors. indigoAccent
                    ),
                      //조회버튼
                      onPressed: () async {
                        if (orderSeqController.text.trim().length == 15) {
                          // 일치
                          Kiosk kiosk = Kiosk(
                              seq: orderSeqController.text.trim(),
                              customer_id: box.read('kioskID'),
                              branchcode: branchcode);
                          curKiosk = kiosk;
                          myshoes = await kioskHandler.kioskqueryOrder(
                              kiosk); // 주문번호 일치 확인(16자리까지 입력, 해당 목록 모두 보이게하기)
                          if (myshoes.isNotEmpty) {
                            //일치 주문번호
                            orderNum =
                                myshoes.first['seq'].toString().substring(0, 15);
                          } else {
                            //불일치
                            errorDialog('경고', '일치하는 주문번호가 없습니다.');
                            orderNum = orderSeqController.text.trim();
                          }
                        } else {
                          //15자리 아닐때
                          errorSnackBar('경고', '주문번호 15자리를 모두 입력하세요.');
                          orderNum = "";
                        }
                        setState(() {});
                      },
                      
                      child: const Text("조회",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black
                      )
                      )
                      ),
                ),  
                  // const Text('수령가능 목록',
                  //   style: TextStyle(
                  //     fontSize: 30
                  //   ),
                  //   ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "주문번호  $orderNum",
                        style:  const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold
                        ),
                        ),
                    ),
                    Container(
                      width: 700,
                      height: 600,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 4)
                      ),
                      child: ListView.builder(
                        itemCount: myshoes.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15), //모서리
                              ),
                              elevation: 5, //그림자
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                    Image.memory(myshoes[index]['image'],
                                    width: 100,
                                    ),
                                  
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '제품명 : ${myshoes[index]['shoesname']}',
                                        style: const TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 13),
                                    child: Text(
                                      '수량 : ${myshoes[index]['quantity']}',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black54
                                        ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blueAccent,
                                    foregroundColor: Colors.white,
                                  ),
                                    onPressed: () {
                                      pickUpDialog(index);
                                    },
                                    child: const Text('수령하기'),
                                    ),
                              ),
                            ],
                              ),
                            ),
                          );
                        },
                        ),
                    )
              ],
            )),
          ),
        ),
      ),
    );
  }

//FFFFFFFFFFFFFF
//수령하기 버튼
  pickUpDialog(index) {
    Get.defaultDialog(
        title: "수령확인",
        middleText: '수령하시겠습니까?',
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        barrierDismissible: false,
        actions: [
          TextButton(
              onPressed: () async{
                Kiosk kiosk = Kiosk(
                  seq: myshoes[index]['seq'],
                  pickuptime: DateTime.now(),
                  customer_id: box.read('kioskID'),
                  branchcode: branchcode
                  );
                  int result = await kioskHandler.updateOrder(kiosk);
                  if(result == 0){
                    errorDialog('경고', '문제가 발생했습니다. \n 관리자에게 문의하세요');
                  }else{
                    
                    myshoes = await kioskHandler.kioskqueryOrder(curKiosk!);
                    Get.back();
                  }
                  setState(() {
                  });
              },
              child: const Text('수령')
          ),
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('취소')
            )
        ]);
  }

//로그인후 주문번호 틀릴때
errorSnackBar(title,message){ //get package SnackBar
  Get.snackbar(
    title,
   message,
   snackPosition: SnackPosition.TOP,   //기본값 = top
   duration: const Duration(seconds: 2),
   backgroundColor: Theme.of(context).colorScheme.error,
   );
}

//불일치 dialog
  errorDialog(title,message) {
    Get.defaultDialog(
        title: title,
        middleText: message,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        barrierDismissible: false,
        actions: [
          TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('확인'))
        ]);
  }





} //End

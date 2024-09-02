import 'package:flutter/material.dart';
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
  late String shoesCount;

  @override
  void initState() {
    super.initState();
    orderSeqController = TextEditingController();
    box.read('kioskID');
    myshoes =[];
    orderNum = "";
    shoesCount="";
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("제품 수령"),
      ),
      body: Center(
          child: Column(
        children: [
                    Padding(
            padding: const EdgeInsets.only(top: 150,right: 200, left: 200),
            child: TextField(
              controller: orderSeqController,
              decoration: const InputDecoration(labelText: "주문번호"), 
              maxLength: 15,
            ),
          ),
                    ElevatedButton(
              onPressed: () async{
                if(orderSeqController.text.trim().length == 15){ // 일치
                  Kiosk kiosk = Kiosk(
                  seq: orderSeqController.text.trim(),
                  customer_id: box.read('kioskID'),
                  );
                  myshoes = await kioskHandler.kioskqueryOrder(kiosk); // 주문번호 일치 확인(16자리까지 입력, 해당 목록 모두 보이게하기)
                  if(myshoes.isNotEmpty){ //일치 주문번호
                  orderNum = myshoes.first['seq'].toString().substring(1,15); 
                  }
                  else{ //불일치
                  errorSnackBar('경고','일치하는 주문번호가 없습니다.');
                  }
                }else{ //15자리 아닐때
                  errorSnackBar('경고', '주문번호 15자리를 모두 입력하세요.');
                  orderNum = "";
                }
                setState(() {});
              },

              child: const Text("조회")),  
              const SizedBox(
                height: 60,
              ),
                            const Text('수령가능 목록',
              style: TextStyle(
                fontSize: 30
              ),
              ),
              // 주문번호 1번? 각각?
              Text(
                "주문번호  $orderNum",
                style:  const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
                ),
                // Text(orderNum),
                
                if(orderSeqController.text.trim().length == 15 )
              Expanded(
                child: SizedBox(
                  width: 700,
                  height: 500,
                  child: ListView.builder(
                    itemCount: myshoes.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Card(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.memory(myshoes[index]['image'],
                              width: 140,
                              ),
                              Column(
                                children: [
                                  // Text("주문번호 : ${myshoes[index]['seq'].toString().substring(1,15)}"),
                                  // Text("주문번호 : ${myshoes[index]['seq'].toString().substring(1,15)}"),
                                  Text(
                                    '제품명 : ${myshoes[index]['shoesname']}',
                                    style: const TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 15),
                                    child: Text(
                                      '수량 : ${myshoes[index]['quantity']}',
                                      style: const TextStyle(
                                        fontSize: 17
                                      ),
                                      ),
                                  ),
                                ],
                              ),
                                                                ElevatedButton(
                                    onPressed: (){
                                      pickUpDialog(index);
                                      }, 
                                      child: const Text('수령하기')),

                            ],
                          ),
                        ),
                      );
                    },
                    ),
                ),
                  
              ),


        ],
      )),
    );
  }

//FFFFFFFFFFFFFF
  pickUpDialog(index) {
    Get.defaultDialog(
        title: "확인",
        middleText: '카운터에서 제품을 수령해주세요',
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        barrierDismissible: false,
        actions: [
          TextButton(
              onPressed: () async{
                Kiosk kiosk = Kiosk(
                  seq: myshoes[index]['seq'],
                  pickuptime: DateTime.now(),
                  customer_id: box.read('kioskID')
                  );
                  int result = await kioskHandler.updateOrder(kiosk);
                  if(result == 1){
                    await kioskHandler.updateOrder(kiosk);
                  Get.back();
                  }
              },
              child: const Text('확인'))
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




} //End

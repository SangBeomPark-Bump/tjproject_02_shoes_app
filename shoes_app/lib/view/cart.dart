
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shoes_app/model/order.dart';
import 'package:shoes_app/vm/database_carthandler.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartState();
}

class _CartState extends State<CartPage> {
  //지점 dropdownbutton 리스트 
  var item;
  late String dropdownValue; // dropdownbutton 선택
  final box = GetStorage(); // get Stroage
  late List<int> wishSeq; //제품번호 리스트 ??
  late List<String> wishShoesname; // 장바구니 신발 이름 
  late List<int> wishPrice; // 장바구니 신발 가격
  late List<Uint8List> wishImage; //장바구니 신발 이미지
  late List<int> wishSize; //장바구니 신발 사이즈
  late List<String> wishBrand; // 장바구니 신발 브랜드
  DatabaseCarthandler carthandler = DatabaseCarthandler();
  @override
  void initState() {
    super.initState();
    // item = ["강남점", "신도림점", "노원점"];
    item = carthandler.queryBranch();
    dropdownValue = "강남점";

    // GetStorage에서 장바구니 데이터 읽어오기
    wishSeq = box.read<List<int>>('wishSeq') ?? [];
    wishShoesname = box.read<List<String>>('wishShoesname') ?? [];
    wishPrice = box.read<List<int>>('wishPrice') ?? [];
    wishImage = box.read<List<Uint8List>>('wishImage') ?? [];
    wishSize = box.read<List<int>>('wishSize') ?? [];
    wishBrand = box.read<List<String>>('wishBrand') ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('장바구니'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 50),
                  child: Text('수령장소', style: TextStyle()),
                ),
                DropdownButton<String>( //지점 드랍다운 버튼
                  dropdownColor: Theme.of(context).colorScheme.primaryContainer,
                  value: dropdownValue,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: item.map((String item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      dropdownValue = value!;
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded( //장바구니 목록 
            child: ListView.builder(
              itemCount: wishSeq.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Row(
                    children: [
                      Image.memory(wishImage[index], width: 70),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(wishShoesname[index]),
                            Text("Size: ${wishSize[index]}"),
                            Text("${wishPrice[index]}₩")
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 30),
                child: 
                ElevatedButton( //구매 버튼
                  onPressed: () {
                    purchaseDialog(); //구매 확인 다이얼로그
                  },
                  child: const Text("구매"),
                ),
              ),
              ElevatedButton( //취소 버튼
                onPressed: () {
                  //
                },
                child: const Text('취소'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  purchaseDialog() {
    Get.defaultDialog(
      title: "구매 하시겠습니까?",
      middleText: "수령장소 : $dropdownValue",
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      barrierDismissible: false,
      actions: [
        TextButton(
          onPressed: () {
            // 구매 처리 로직
            Get.back(); // 다이얼로그 닫기
          },
          child: const Text('예'),
        ),
        TextButton(
          onPressed: () {
            Get.back(); // 다이얼로그 닫기
          },
          child: const Text('아니오'),
        ),
      ],
    );
  }


//구매 다이얼로그 클릭시 order테이블 저장
// insertOrderClick(){
//   Order order = Order(
//     branch_branchcode: 1,
//     customer_id: , 
//     shoes_seq: , 
//     order_seq: order_seq, 
//     quantity: quantity, 
//     paymenttime: paymenttime
//     );
// }






}//End

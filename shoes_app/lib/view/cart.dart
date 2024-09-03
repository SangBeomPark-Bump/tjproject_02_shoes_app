
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shoes_app/model/order.dart';
import 'package:shoes_app/view/detail.dart';
import 'package:shoes_app/view/home.dart';
import 'package:shoes_app/view/orders.dart';
import 'package:shoes_app/vm/database_cart_handler.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartState();
}

class _CartState extends State<CartPage> {
  //지점 dropdownbutton 리스트 
  late List<String> item;
  late String dropdownValue; // dropdownbutton 선택
  final box = GetStorage(); // get Stroage
  late List<int> wishSeq; //제품번호 리스트 ??
  late List<String> wishShoesname; // 장바구니 신발 이름 
  late List<int> wishPrice; // 장바구니 신발 가격
  late List<Uint8List> wishImage; //장바구니 신발 이미지
  late List<int> wishSize; //장바구니 신발 사이즈
  late List<String> wishBrand; // 장바구니 신발 브랜드
  late List<int> wishQuantity; //장바구니 수량
  late int wishOrderseq; //order_seq
  DatabaseCarthandler carthandler = DatabaseCarthandler(); //장바구니용 handler




  @override
  void initState() {
    super.initState();
    item = [];
    // item = ["강남점", "신도림점", "노원점"];
    dropdownValue = "";
    wishOrderseq=1;
    readcartBox();
    readBranch();
  }


  readcartBox(){
    // GetStorage에서 장바구니 데이터 읽어오기
    wishSeq = box.read<List<int>>('wishSeq') ?? [];
    wishShoesname = box.read<List<String>>('wishShoesname') ?? [];
    wishPrice = box.read<List<int>>('wishPrice') ?? [];
    wishImage = box.read<List<Uint8List>>('wishImage') ?? [];
    wishSize = box.read<List<int>>('wishSize') ?? [];
    wishBrand = box.read<List<String>>('wishBrand') ?? [];
    wishQuantity = box.read<List<int>>('wishQuantity') ?? [] ;
  }

//dropdown branch
readBranch()async{
  item = await carthandler.queryBranch();
  dropdownValue = item[0];
  setState(() {
  });
}
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
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
                  DropdownButton<String>(
                    dropdownColor: const Color.fromARGB(255, 226, 224, 224),
                    borderRadius: BorderRadius.circular(10),
                    elevation: 10,
                    underline: Container(
                      height: 2,
                      color: Colors.redAccent,
                    ),
                    value: dropdownValue,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: item.map((String item){
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(item)
                        );
                    }).toList(),
                  onChanged: (value) {
                    setState(() {
                      dropdownValue = value!;
                    });
                  },
                  )
              ],
            ),
          ),
          wishSeq.isEmpty ? 
          const Center(child: Text('장바구니에 담긴 물건이 없습니다.'),)
          :
          Expanded( //장바구니 목록 
            child: ListView.builder(
              itemCount: wishSeq.length,
              itemBuilder: (context, index) {
                return Slidable(
                  endActionPane: ActionPane(
                    motion: const BehindMotion(),
                  children: [
                    SlidableAction(
                      backgroundColor: Colors.red,
                      icon: Icons.delete,
                      onPressed: (context) {
                        deleteDialog1(index,wishShoesname[index]);
                      },
                      )
                  ]
                  ),
                  child: SizedBox(
                    width: 800,
                    height: 150,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        color: const Color.fromARGB(255, 251, 250, 250),
                        shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(5),
                        side: const BorderSide(width: 1),
                        ),
                        elevation: 2,
                        child: Row(
                          children: [
                            Image.memory(wishImage[index], width: 120), //신발 이미지
                            SizedBox(
                              width: 130,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(wishShoesname[index], //신발 이름
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20
                                  ),
                                  ),
                                  Text("Size: ${wishSize[index]}"), //사이즈
                                  Text("${wishPrice[index] * wishQuantity[index]}₩",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20
                                  ),
                                  ) //가격
                                ],
                              ),
                            ),
                                Column(
                                  children: [
                                    ElevatedButton( //신발 수량 -
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                                        iconColor: Colors.blue
                                      ),
                                      onPressed: () {
                                        if(wishQuantity[index]>=2) {
                                          wishQuantity[index]--;
                                        }
                                      setState(() {});
                                    },
                                    child: const Icon(Icons.remove)
                                    ),
                                    
                                    Text("수량 : ${wishQuantity[index]}",
                                    style: const TextStyle(
                                      fontSize: 15
                                    ),
                                    ), //신발 수량
                                    
                                    ElevatedButton( //신발 수량 +
                                    style: ElevatedButton.styleFrom(
                                      iconColor: Colors.red,
                                      backgroundColor:  const Color.fromARGB(255, 255, 255, 255),
                                    ),
                                      onPressed: () {
                                        wishQuantity[index]++;
                                        setState(() {});
                                      },
                                      child: const Icon(Icons.add)
                                    ),
                                  ],
                                ),
                                  
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(80),
                child: 
                ElevatedButton( //구매 버튼
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(200, 50),
                  backgroundColor:const Color.fromARGB(255, 34, 193, 195),
                ),
                  onPressed: () {
                    wishSeq.isEmpty ? 
                    erorrSnackBar() 
                    :purchaseDialog(); //구매 확인 다이얼로그
                  },
                  child: const Text("구매",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


//구매 다이얼로그
  purchaseDialog() {
    Get.defaultDialog(
      title: "구매 하시겠습니까?",
      middleText: "수령장소 : $dropdownValue",
      barrierDismissible: false,
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.grey
          ),
          onPressed: () {
            // 구매 처리 로직
            cartInsertOrder();
            deleteCart();
            readcartBox(); //화면 다시 그리기
            Get.back(); // 다이얼로그 닫기
            setState(() {
            });
          },
          child: const Text('예'),
        ),
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.amber
          ),
          onPressed: () {
            Get.back(); // 다이얼로그 닫기
          },
          child: const Text('아니오'),
        ),
      ],
    );
  }

//장바구니 선택 삭제
selectedDelete(index){
  wishSeq.removeAt(index);
  wishShoesname.removeAt(index);
  wishSize.removeAt(index);
  wishImage.removeAt(index);
  wishQuantity.removeAt(index);
  wishBrand.removeAt(index);
  wishPrice.removeAt(index);
  setState(() {
  });
}
//장바구니 구매후 초기화
deleteCart(){
  String id = box.read('userId');
  box.erase();
  box.write("userId",id);
  setState(() {
    
  });
}




//구매 다이얼로그 클릭시 order테이블 저장
  cartInsertOrder(){
    for(int i=0 ; i <= wishSeq.length-1 ; i++){
      Order orders = Order(
        branch_branchcode: item.indexOf(dropdownValue)+1,
        // dropdown 수정 or if문
        customer_id: box.read('userId'), 
        shoes_seq: wishSeq[i],
        order_seq: wishOrderseq++, 
        quantity: wishQuantity[i], 
        paymenttime: DateTime.now()
        );
        orders.seqMaker();
        carthandler.insertOrder(orders);
        setState(() {
          
        });
      
    }
  }







//삭제 다이얼로그
deleteDialog1(index,title){
  Get.defaultDialog(
    title: title,
    middleText: '항목을 삭제 하시겠습니까?',
    actions: [
      TextButton(
        onPressed: () => Get.back(), 
        child: const Text('취소')
        ),
      TextButton(
        onPressed: () {
          selectedDelete(index);
          setState(() {});
          Get.back();
        },
        child: const Text('삭제')
        )
    ]
  );
}

//장바구니 없이 그냥 클릭
erorrSnackBar(){ //get package SnackBar
  Get.snackbar(
  "경고",
  "담은 물건이 없습니다.",
  snackPosition: SnackPosition.BOTTOM,   //기본값 = top
  duration: const Duration(seconds: 2),
  backgroundColor: Theme.of(context).colorScheme.error,
  colorText: Theme.of(context).colorScheme.onError
  );
}








}//End

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shoes_app/view/cart.dart';
import 'package:shoes_app/vm/database_handler.dart';

class Detail extends StatefulWidget {
  const Detail({super.key});

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  late DatabaseHandler handler;
  late int? seq; //신발 코드
  late String shoesname; //신발 이름
  late int price; //신발 가격
  late Uint8List image; //신발 이미지
  late int size; //신발 사이즈
  late String brand; //신발 브랜드
  var value = Get.arguments ?? [];
  int quantity = 0; //신발 수량 count
  final box = GetStorage();
  //-------장바구니-----------
  late List<int> wishSeq;
  late List<String> wishShoesname;
  late List<int> wishPrice;
  late List<Uint8List> wishImage;
  late List<int> wishSize;
  late List<String> wishBrand;
  late List<int> wishQuantity;

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    seq = value[0] as int?;
    shoesname = value[1] as String;
    price = value[2] as int;
    image = value[3] as Uint8List;
    size = value[4] as int;
    brand = value[5] as String;

    //장바구니 담은 목록 가져오기
    readBox();
  }

  readBox() {
    wishSeq = box.read<List<int>>('wishSeq') ?? [];
    wishShoesname = box.read<List<String>>('wishShoesname') ?? [];
    wishPrice = box.read<List<int>>('wishPrice') ?? [];
    wishImage = box.read<List<Uint8List>>('wishImage') ?? [];
    wishSize = box.read<List<int>>('wishSize') ?? [];
    wishBrand = box.read<List<String>>('wishBrand') ?? [];
    wishQuantity = box.read<List<int>>('wishQuantity') ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
                onTap: () => Get.to(CartPage()),
                child: Icon(Icons.shopping_cart)),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 300,
                color: Colors.grey,
                child: Image.memory(image, width: 100),
              ),
              Text(brand,
                  style:
                      TextStyle(fontSize: 15, fontWeight: FontWeight.normal)),
              //브랜드 값 가져옴
              Text(shoesname,
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              //제품명 값 가져옴
              Text("${price.toString()}원",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.red)),
              //가격 값 가져옴
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //사이즈 선택하는 컨테이너
                  Container(
                    width: 150,
                    height: 120,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.7),
                            blurRadius: 5.0,
                            spreadRadius: 0.0,
                            offset: Offset(0, 5))
                      ],
                      borderRadius: BorderRadius.circular(15),
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //신발 아이콘 이미지 삽입?
                        Icon(Icons.skateboarding, size: 60),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('SIZE',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
                            Text("$size")
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  Column(
                    children: [
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  if (quantity > 0) quantity -= 1;
                                });
                              },
                              icon: Icon(Icons.remove,
                                  color:
                                      const Color.fromARGB(255, 122, 163, 195)),
                            ),
                            Text("$quantity"),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  quantity += 1;
                                });
                              },
                              icon: Icon(Icons.add, color: Colors.red),
                            ),
                          ],
                        ),
                        width: 150,
                        height: 60,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.7),
                                blurRadius: 5.0,
                                spreadRadius: 0.0,
                                offset: Offset(0, 5))
                          ],
                          borderRadius: BorderRadius.circular(15),
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          if (quantity != 0) {
                            addToCart();
                            Get.back();
                          } else {}
                        },
                        child: Text('장바구니 담기',
                            style: TextStyle(color: Colors.black87)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 215, 215, 215),
                          fixedSize: Size(150, 40),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  addToCart() {
    //장바구니 여러종류 담기
    // Add new items to the cart
    wishSeq.add(seq!);
    wishShoesname.add(shoesname);
    wishPrice.add(price);
    wishImage.add(image);
    wishSize.add(size);
    wishBrand.add(brand);
    wishQuantity.add(quantity);
    saveStorage();
  }

  saveStorage() {
    //장바구니
    box.write('wishSeq', wishSeq);
    box.write('wishShoesname', wishShoesname);
    box.write('wishPrice', wishPrice);
    box.write('wishImage', wishImage);
    box.write('wishSize', wishSize);
    box.write('wishBrand', wishBrand);
    box.write('wishQuantity', wishQuantity);
  }
}

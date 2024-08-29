import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoes_app/vm/database_handler.dart';

class Detail extends StatefulWidget {
  const Detail({super.key});

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  late DatabaseHandler handler;
  late int? seq;
  late String shoesname;
  late int price;
  late Uint8List image;
  late int size;
  late String brand;
  var value = Get.arguments ?? "__";
  int num = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    handler = DatabaseHandler();
    seq = value[0];
    shoesname = value[1];
    price = value[2];
    image = value[3];
    size = value[4];
    brand = value[5];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.shopping_cart),
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
                child: Image.memory(
                  image,
                  width: 100,
                ),
              ),
              Text(
                brand,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
              ),
              // 브랜드 값 가져옴
              Text(
                shoesname,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              // 제품명 값 가져옴
              Text(
                "${price.toString()}원",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
              // 가격 값 가져옴
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 사이즈 선택하는 컨테이너
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
                        // 신발아이콘이미지 삽입?
                        Icon(
                          Icons.skateboarding,
                          size: 60,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'SIZE',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // 가격 값 가져옴
                            Text("$size")
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  // 신발 수량 증가 감소 컨테이너
                  Column(
                    children: [
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                                onPressed: () {
                                  setState(() {});
                                  if (num <= 0) {
                                    num = 0;
                                  } else {
                                    num -= 1;
                                  }
                                },
                                icon: Icon(
                                  Icons.remove,
                                  color:
                                      const Color.fromARGB(255, 122, 163, 195),
                                )),
                            Text("$num"), // 구매수량
                            IconButton(
                                onPressed: () {
                                  setState(() {});
                                  if (num >= 0) {
                                    num += 1;
                                  }
                                },
                                icon: Icon(
                                  Icons.add,
                                  color: Colors.red,
                                )),
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
                      SizedBox(
                        height: 16,
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        child: Text(
                          '장바구니 담기',
                          style: TextStyle(color: Colors.black87),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 215, 215, 215),
                            fixedSize: Size(150, 40)),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

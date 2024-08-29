import 'package:flutter/material.dart';

class Detail extends StatefulWidget {
  const Detail({super.key});

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  final valueList = ["250", "255", "260", "265", "270"];
  var selectValue = '260';
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
                // 이미지 메모리에서 가져옴
                //Image.memory(snapshot.data![index].image,width: 100,),
              ),
              Text(
                '',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
              ),
              // 브랜드 값 가져옴
              //Text(snapshot.data![index].brand)
              Text(
                'Nike',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
              ),
              // 브랜드 값 가져옴
              //Text(snapshot.data![index].brand)
              Text(
                'NIKE AIR MAX',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              // 제품명 값 가져옴
              //Text(snapshot.data![index].shoesname)
              Text(
                '100,000원',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
              // 가격 값 가져옴
              //Text(snapshot.data![index].price)
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
                            //Text(snapshot.data![index].price)
                            // 신발 사이즈 선택 드랍다운 버튼
                            DropdownButton(
                              value: selectValue,
                              items: valueList.map(
                                (value) {
                                  return DropdownMenuItem(
                                    value: value,
                                    child: Text(value),
                                  );
                                },
                              ).toList(),
                              onChanged: (value) {
                                selectValue = value!;
                                setState(() {});
                              },
                            ),
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
                                onPressed: () {},
                                icon: Icon(
                                  Icons.remove,
                                  color: Colors.blue,
                                )),
                            Text('숫자'),
                            IconButton(
                                onPressed: () {},
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

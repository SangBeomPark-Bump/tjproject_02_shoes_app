import 'package:flutter/material.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  final valueList = ["선택하세요", "24년 6월", "24년 7월", "24년 8월", "24년 9월"];
  var selectValue = "선택하세요";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body:
          /*FutureBuilder(
          future: future,
          builder: (context, snapshot) {
            if(snapshot.hasData){
              return ListView.builder(itemBuilder: itemBuilder)
            }
          },
          */
          Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 100, right: 100),
            child: DropdownButtonFormField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[300],
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.black, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.black, width: 1),
                ),
              ),
              value: selectValue,
              items: valueList.map(
                (value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(
                      "    $value",
                      style: TextStyle(fontSize: 20),
                    ),
                  );
                },
              ).toList(),
              onChanged: (value) {
                selectValue = value!;
                setState(() {});
              },
            ),
          ),
          Align(alignment: Alignment.centerLeft, child: Text('주문번호')),
          Container(
            decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(20)),
            width: 350,
            height: 150,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 100,
                  child: Icon(
                    Icons.skateboarding,
                    size: 50,
                  ),
                ),
                // 이미지 메모리에서 가져옴
                //Image.memory(snapshot.data![index].image,width: 100,),
                SizedBox(
                  width: 30,
                ),
                Container(
                  width: 170,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '8.21 16:30 구매',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.normal),
                      ),
                      // 구매시간 값 가져옴
                      //Text(snapshot.data![index].paymenttime)
                      Text(
                        '8.22 16:30 수령',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.normal),
                      ),
                      // 구매시간 값 가져옴
                      //Text(snapshot.data![index].paymenttime)
                      Text(
                        'Nike',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.normal),
                      ),
                      // 브랜드 값 가져옴
                      //Text(snapshot.data![index].brand)
                      Text(
                        'NIKE AIR MAX',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      // 제품명 값 가져옴
                      //Text(snapshot.data![index].shoesname)
                      Text(
                        '100,000원',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // 구매취소됨, 취소하기, 픽업완료
                      Align(
                        alignment: Alignment.bottomRight,
                        child: TextButton(
                            onPressed: () {},
                            child: Text(
                              '취소하기',
                              style: TextStyle(
                                  fontSize: 12,
                                  color:
                                      const Color.fromARGB(255, 207, 45, 34)),
                            )),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

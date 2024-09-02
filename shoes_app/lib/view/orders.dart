import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:shoes_app/vm/database_handler_order.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  late DatabaseHandlerOrder handler;
  final valueList = ["선택하세요", "24년 6월", "24년 7월", "24년 8월", "24년 9월"];
  var selectValue = "선택하세요";
  late String userID;
  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandlerOrder();
    initStorage();
  }

  initStorage() {
    userID = box.read('userId') ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
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
                  setState(() {
                    selectValue = value!;
                  });
                },
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: handler.queryUser(userID),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    print(snapshot.error);
                    return Center(
                      child: Text('에러 발생: ${snapshot.error}'),
                    );
                  } else if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final ordered = snapshot.data![index];
                        return Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text("주문번호: ${ordered.seq}"),
                            ),
                            Container(
                              decoration: BoxDecoration(color: Colors.white),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.memory(ordered.image, width: 120),
                                  SizedBox(width: 20),
                                  Container(
                                    width: 170,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          DateFormat('yyyy-MM-dd HH:mm:ss')
                                              .format(DateTime.parse(
                                                  "${ordered.paymenttime}")),
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.normal),
                                        ),
                                        Text(
                                          ordered.pickuptime != null
                                              ? DateFormat(
                                                      'yyyy-MM-dd HH:mm:ss')
                                                  .format(ordered.pickuptime!)
                                              : (ordered.canceltime == null
                                                  ? ""
                                                  : DateFormat(
                                                          'yyyy-MM-dd HH:mm:ss')
                                                      .format(DateTime.parse(
                                                          "${ordered.canceltime}"))),
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.normal,
                                            color: ordered.canceltime != null
                                                ? Colors.red
                                                : Colors.green,
                                          ),
                                        ),
                                        Text(
                                          "수령장소: ${ordered.branchName}",
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.normal),
                                        ),
                                        Text(
                                          ordered.shoesName,
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          '구매가격: ${ordered.totalPrice}원',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          '구매수량: ${ordered.quantity}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            if (ordered.pickuptime == null &&
                                                ordered.canceltime == null) {
                                              Get.defaultDialog(
                                                  title: '구매취소',
                                                  middleText: '구매를 취소하시겠습니까?',
                                                  radius: 20,
                                                  textCancel: '네',
                                                  onCancel: () async {
                                                    await handler.cancelShoe(
                                                        DateTime.now()
                                                            .toString(),
                                                        ordered.seq);
                                                    setState(() {});
                                                    Get.back();
                                                  },
                                                  textConfirm: '아니요',
                                                  onConfirm: () => Get.back());
                                            }
                                          },
                                          child: Align(
                                            alignment: Alignment.bottomRight,
                                            child: Text(
                                              ordered.pickuptime != null
                                                  ? "수령완료"
                                                  : (ordered.canceltime != null
                                                      ? "구매취소됨"
                                                      : "구매취소"),
                                              style: TextStyle(
                                                fontSize: 12,
                                                color:
                                                    ordered.pickuptime == null
                                                        ? const Color.fromARGB(
                                                            255, 207, 45, 34)
                                                        : Color.fromARGB(
                                                            255, 27, 168, 69),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: Text('데이터가 없습니다'),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

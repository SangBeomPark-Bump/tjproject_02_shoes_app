

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import 'package:shoes_app/view/sign/sign_in.dart';
import 'package:shoes_app/vm/database_handler_order.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  late DatabaseHandlerOrder handler;
  String selectedMonth = DateFormat('yyyy-MM')
      .format(DateTime.now().subtract(const Duration(days: 20)));
  bool isDatabaseInitialized = false;
  late bool monthInitial;
  late String userID;
  final box = GetStorage();
  late List<String> availableMonths;



  @override
  void initState() {
    super.initState();
    handler = DatabaseHandlerOrder();
    monthInitial = true;
    initStorage();
    availableMonths = [];
    functionAvailable();

  }

  initStorage() {
    userID = box.read('userId') ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('구매 내역'),
        leading: IconButton(
          icon: const Icon(Icons.exit_to_app),
          onPressed: () {
            _showLogoutConfirmationDialog(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: availableMonths == []
            ? const CircularProgressIndicator()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 80, right: 80),
                    child: DropdownButtonFormField(
                      iconEnabledColor: const Color.fromARGB(255, 0, 15, 46),
                      borderRadius:
                          BorderRadius.circular(20), // dropDown border radius
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(15)),
                        prefixIcon: const Icon(Icons.format_list_bulleted),
                        prefixIconColor: const Color.fromARGB(255, 0, 15, 46),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 209, 234, 240),
                      ),
                      dropdownColor: const Color.fromARGB(255, 209, 234, 240),
                      value: selectedMonth,
                      items: availableMonths.map(
                        (String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              "  $item",
                              style: const TextStyle(fontSize: 20),
                            ),
                          );
                        },
                      ).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedMonth = value!;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: FutureBuilder(
                      future: handler.queryOrderByQuery(userID, selectedMonth),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
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
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    decoration: const BoxDecoration(
                                        color:
                                            Color.fromARGB(255, 240, 248, 255)),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20, bottom: 5, top: 5),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                                "주문번호: ${ordered.seq.substring(0, 15)}"),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.memory(
                                              ordered.image,
                                              width: 120,
                                            ),
                                            const SizedBox(width: 20),
                                            SizedBox(
                                              width: 170,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    DateFormat(
                                                            'yyyy-MM-dd HH:mm:ss')
                                                        .format(DateTime.parse(
                                                            "${ordered.paymenttime}")),
                                                    style: const TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                  Text(
                                                    ordered.pickuptime != null
                                                        ? DateFormat(
                                                                'yyyy-MM-dd HH:mm:ss')
                                                            .format(ordered
                                                                .pickuptime!)
                                                        : (ordered.canceltime ==
                                                                null
                                                            ? ""
                                                            : DateFormat(
                                                                    'yyyy-MM-dd HH:mm:ss')
                                                                .format(DateTime
                                                                    .parse(
                                                                        "${ordered.canceltime}"))),
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color: ordered
                                                                  .canceltime !=
                                                              null
                                                          ? const Color.fromARGB(
                                                              255, 207, 45, 34)
                                                          :const  Color.fromARGB(
                                                              255, 0, 153, 0),
                                                    ),
                                                  ),
                                                  Text(
                                                    "수령장소: ${ordered.branchName}",
                                                    style: const TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                  Text(
                                                    ordered.shoesName,
                                                    style: const TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    '구매가격: ${ordered.totalPrice}원',
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    '구매수량: ${ordered.quantity}',
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.bottomRight,
                                                    child: TextButton(
                                                      onPressed: () {
                                                        if (ordered.pickuptime ==
                                                                null &&
                                                            ordered.canceltime ==
                                                                null) {
                                                          Get.defaultDialog(
                                                              title: '구매취소',
                                                              middleText:
                                                                  '구매를 취소하시겠습니까?',
                                                              radius: 20,
                                                              textCancel: '네',
                                                              onCancel:
                                                                  () async {
                                                                await handler.cancelShoe(
                                                                    DateTime.now()
                                                                        .toString(),
                                                                    ordered
                                                                        .seq);
                                                                setState(() {});
                                                                Get.back();
                                                              },
                                                              textConfirm:
                                                                  '아니요',
                                                              onConfirm: () =>
                                                                  Get.back());
                                                        }
                                                      },
                                                      child: Text(
                                                        ordered.pickuptime !=
                                                                null
                                                            ? "수령완료"
                                                            : (ordered.canceltime !=
                                                                    null
                                                                ? "구매취소됨"
                                                                : "구매취소"),
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color:
                                                              ordered.pickuptime ==
                                                                      null
                                                                  ? const Color
                                                                      .fromARGB(
                                                                      255,
                                                                      207,
                                                                      45,
                                                                      34)
                                                                  : const Color
                                                                      .fromARGB(
                                                                          255,
                                                                          0,
                                                                          153,
                                                                          0),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          return const Center(
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

// 로그아웃 버튼
void _showLogoutConfirmationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('로그아웃'),
        content: const Text('로그아웃하시겠습니까?'),
        actions: <Widget>[
          TextButton(
            child: const Text('아니오'),
            onPressed: () {
              Navigator.of(context).pop(); // 대화 상자 닫기
            },
          ),
          TextButton(
            child: const Text('예'),
            onPressed: () {
              Navigator.of(context).pop(); // 대화 상자 닫기
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const SignInPage()), // SignInPage로 이동
              );
            },
          ),
        ],
      );
    },
  );
}









  Future<void> functionAvailable() async {
    availableMonths = await handler.loadAvailableMonth();
    if (monthInitial && availableMonths.isNotEmpty) {
      monthInitial = false;
      selectedMonth = availableMonths[availableMonths.length - 1];

    } else{

    }
    setState(() {});
  }
}// End

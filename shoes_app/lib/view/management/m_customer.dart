import 'package:flutter/material.dart';
import 'package:shoes_app/model/order.dart';
import 'package:shoes_app/vm/database_handler_management.dart';


class MCustomer extends StatefulWidget {
  const MCustomer({super.key});

  @override
  State<MCustomer> createState() => _MCustomerState();
}

class _MCustomerState extends State<MCustomer> {
  late DatabaseHandler handler;
  List<Order> orders = []; // 초기화
  List<Order> filteredOrders = []; // 초기화
  TextEditingController searchController = TextEditingController();
  String selectedFilter = '고객 ID'; // 기본 검색 필터 설정

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    orders = await handler.queryOrder();
    filteredOrders = orders;
    setState(() {});
  }

  void _filterOrders(String query) {
    setState(() {
      filteredOrders = orders.where((order) {
        switch (selectedFilter) {
          case '고객 ID':
            return order.customer_id.contains(query);
          case '제품명':
            return true; // 제품명 검색은 아래에서 처리
          case '결제 날짜':
            return order.paymenttime.toString().contains(query);
          case '지점명':
            return true; // 지점명 검색은 아래에서 처리
          default:
            return false;
        }
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("고객관리"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: DropdownButton<String>(
                        value: selectedFilter,
                        items: <String>['고객 ID', '제품명', '결제 날짜', '지점명'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedFilter = value!;
                            searchController.clear(); // 필터 변경 시 검색어 초기화
                            _filterOrders(''); // 초기화된 검색어로 다시 필터링
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 5,
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          labelText: '검색',
                          hintText: '$selectedFilter 검색',
                          prefixIcon: const Icon(Icons.search),
                          border: const OutlineInputBorder(),
                        ),
                        onChanged: _filterOrders,
                      ),
                    ),
                  ],
                ),
              ),
              if (filteredOrders.isEmpty)
                const Center(
                  child: Text('검색된 데이터가 없습니다.'),
                )
              else
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('고객 ID')),
                      DataColumn(label: Text('성별')),
                      DataColumn(label: Text('나이')),
                      DataColumn(label: Text('제품명')),
                      DataColumn(label: Text('결제 시간')),
                      DataColumn(label: Text('지점명')),
                      DataColumn(label: Text('총매출')),
                    ],
                    rows: filteredOrders.map((order) {
                      return DataRow(
                        cells: [
                          DataCell(Text(order.customer_id)), // 고객 ID
                          DataCell(Text(_calculateGender(order.customer_id))), // 성별 계산
                          DataCell(Text(_calculateAge(order.customer_id))), // 나이 계산
                          DataCell(FutureBuilder<String?>(
                            future: handler.getShoeName(order.shoes_seq), // 신발 이름 가져오기
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return const Text('Unknown Product');
                              } else {
                                return Text(snapshot.data ?? 'Unknown Product');
                              }
                            },
                          )),
                          DataCell(Text(order.paymenttime.toString())), // 결제 시간
                          DataCell(FutureBuilder<String?>(
                            future: handler.getBranchName(order.branch_branchcode), // 지점명 가져오기
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return const Text('Unknown Branch');
                              } else {
                                return Text(snapshot.data ?? 'Unknown Branch');
                              }
                            },
                          )),
                          DataCell(FutureBuilder<double?>(
                            future: _calculateTotalSales(order), // 총매출 계산
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return const Text('0.0');
                              } else {
                                return Text(snapshot.data?.toStringAsFixed(2) ?? '0.00');
                              }
                            },
                          )),
                        ],
                      );
                    }).toList(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // 총매출 계산 함수 (주문 항목 별로 가격을 곱하여 합산)
  Future<double> _calculateTotalSales(Order order) async {
    final double? price = await handler.getShoePrice(order.shoes_seq);
    return (price ?? 0.0) * order.quantity;
  }

  // 성별 계산 함수 (예제)
  String _calculateGender(String customerId) {
    try {
      return customerId.endsWith('1') || customerId.endsWith('3') ? '남성' : '여성';
    } catch (e) {
      return '알 수 없음';
    }
  }

  // 나이 계산 함수 (예제)
  String _calculateAge(String customerId) {
    try {
      String birthYear = '19' + customerId.substring(0, 2);
      int age = DateTime.now().year - int.parse(birthYear);
      return age.toString();
    } catch (e) {
      return '알 수 없음';
    }
  }
}

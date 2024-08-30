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
  List<Order> orders = [];
  Map<String, List<Order>> groupedOrders = {};
  TextEditingController searchController = TextEditingController();
  String selectedFilter = '고객 ID';
  bool showPaymentAmount = false; // 결제 금액 표시 여부를 결정하는 변수
  bool isSearching = false; // 검색 중인지 여부를 결정하는 변수

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    try {
      orders = await handler.queryOrder();
      _groupOrdersByCustomerId();
      setState(() {});
    } catch (e) {
      print("Error loading orders: $e");
    }
  }

  void _groupOrdersByCustomerId() {
    groupedOrders = {};
    for (var order in orders) {
      String? customerId = order.customer_id;
      if (customerId != null) {
        if (groupedOrders.containsKey(customerId)) {
          groupedOrders[customerId]!.add(order);
        } else {
          groupedOrders[customerId] = [order];
        }
      }
    }
  }

  void _filterOrders(String query) {
    final filteredOrders = <String, List<Order>>{};

    groupedOrders.forEach((key, value) {
      final filteredList = <Order>[];

      for (var order in value) {
        bool matches = false;
        switch (selectedFilter) {
          case '고객 ID':
            matches = order.customer_id?.contains(query) ?? false;
            break;
          case '제품명':
            matches = order.shoes_seq.toString().contains(query);
            break;
        }
        if (matches) {
          filteredList.add(order);
        }
      }

      if (filteredList.isNotEmpty) {
        filteredOrders[key] = filteredList;
      }
    });

    setState(() {
      groupedOrders = filteredOrders;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("고객관리"),
        actions: [
          if (!isSearching)
            Row(
              children: [
                Switch(
                  value: showPaymentAmount,
                  onChanged: (value) {
                    setState(() {
                      showPaymentAmount = value;
                      _groupOrdersByCustomerId(); // 스위치를 켜거나 끌 때 데이터를 다시 그룹화
                    });
                  },
                ),
                const Text('결제 금액 보기'),
              ],
            ),
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
                if (!isSearching) {
                  searchController.clear();
                  _filterOrders(''); // 검색 종료 시 모든 항목 표시
                }
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (isSearching)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: '$selectedFilter 검색',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        prefixIcon: const Icon(Icons.search),
                      ),
                      onChanged: _filterOrders,
                      autofocus: true,
                    ),
                  ),
                  const SizedBox(width: 10),
                  DropdownButton<String>(
                    value: selectedFilter,
                    items: <String>['고객 ID', '제품명']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedFilter = value!;
                        searchController.clear();
                        _filterOrders('');
                      });
                    },
                  ),
                ],
              ),
            ),
          Expanded(
            child: ListView(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: [
                      const DataColumn(label: Text('고객 ID')),
                      const DataColumn(label: Text('성별')),
                      const DataColumn(label: Text('나이')),
                      const DataColumn(label: Text('제품명')),
                      if (showPaymentAmount)
                        const DataColumn(label: Text('총 결제 금액')), // 결제 금액 열 추가
                    ],
                    rows: showPaymentAmount
                        ? [
                            for (var entry in groupedOrders.entries)
                              _buildGroupedDataRow(entry.key, entry.value),
                          ]
                        : [
                            for (var entry in groupedOrders.entries)
                              for (var order in entry.value)
                                _buildIndividualDataRow(entry.key, order),
                          ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  DataRow _buildGroupedDataRow(String customerId, List<Order> customerOrders) {
    return DataRow(
      cells: [
        DataCell(Text(customerId)),
        DataCell(Text(_calculateGender(customerId))),
        DataCell(Text(_calculateAge(customerId))),
        DataCell(
          FutureBuilder<String>(
            future: _getProductNamesWithQuantities(customerOrders),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text('Loading...');
              } else if (snapshot.hasError || !snapshot.hasData) {
                return const Text('Error');
              } else {
                return Text(snapshot.data!);
              }
            },
          ),
        ),
        DataCell(
          FutureBuilder<double>(
            future: _calculateTotalAmount(customerOrders),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text('Loading...');
              } else if (snapshot.hasError || !snapshot.hasData) {
                return Text('0 원');  // 오류 발생 시 기본값을 0원으로 설정
              } else {
                return Text('${snapshot.data!.toStringAsFixed(2)} 원');
              }
            },
          ),
        ),
      ],
    );
  }

  DataRow _buildIndividualDataRow(String customerId, Order order) {
    return DataRow(
      cells: [
        DataCell(Text(customerId)),
        DataCell(Text(_calculateGender(customerId))),
        DataCell(Text(_calculateAge(customerId))),
        DataCell(
          FutureBuilder<String?>(
            future: handler.getShoeName(order.shoes_seq), // 제품명을 데이터베이스에서 가져옴
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text('Loading...');
              } else if (snapshot.hasError || !snapshot.hasData) {
                return const Text('Error');
              } else {
                return Text('${snapshot.data ?? 'Unknown'} x ${order.quantity}');
              }
            },
          ),
        ),
      ],
    );
  }

  Future<String> _getProductNamesWithQuantities(List<Order> customerOrders) async {
    final Map<String, int> productCounts = {};

    for (var order in customerOrders) {
      try {
        String? productName = await handler.getShoeName(order.shoes_seq);
        if (productName != null) {
          if (productCounts.containsKey(productName)) {
            productCounts[productName] = productCounts[productName]! + order.quantity;
          } else {
            productCounts[productName] = order.quantity;
          }
        }
      } catch (e) {
        print("Error getting product name: $e");
      }
    }

    return productCounts.entries
        .map((entry) => '${entry.key} x ${entry.value}개')
        .join(', ');
  }

Future<double> _calculateTotalAmount(List<Order> customerOrders) async {
    double totalAmount = 0.0;
    for (var order in customerOrders) {
        try {
            final dynamic price = await handler.getShoePrice(order.shoes_seq);  // 가격을 DB에서 가져옴

            // 타입에 따라 처리
            if (price is int) {
                totalAmount += order.quantity * price.toDouble(); // int 타입을 double로 변환
            } else if (price is double) {
                totalAmount += order.quantity * price; // double 타입은 그대로 사용
            } else {
                print("Unexpected price type: $price");
            }
        } catch (e) {
            print("Error calculating total amount: $e");
            totalAmount += 0;  // 오류 발생 시 합산에 0을 추가
        }
    }
    return totalAmount;
}


  String _calculateGender(String customerId) {
    try {
      return customerId.endsWith('1') || customerId.endsWith('3') ? '남성' : '여성';
    } catch (e) {
      return '알 수 없음';
    }
  }

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

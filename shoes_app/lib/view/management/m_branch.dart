import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // To get the current month
import 'package:pie_chart/pie_chart.dart'; // To display the pie chart
import 'package:shoes_app/view/sign/sign_in.dart';
import 'package:sqflite/sqflite.dart'; // To interact with the database
import 'package:path/path.dart';

class MBranch extends StatefulWidget {
  const MBranch({super.key});

  @override
  State<MBranch> createState() => _MBranchState();
}

class _MBranchState extends State<MBranch> {
  late Database _database;
  String selectedMonth = DateFormat('MM').format(DateTime.now());
  bool isDatabaseInitialized = false;
  final List<String> availableMonths = ['05', '06', '07', '08'];

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
    if (!availableMonths.contains(selectedMonth)) {
      selectedMonth = '05'; // 기본적으로 5월로 설정
    }
  }

  Future<void> _initializeDatabase() async {
    String path = await getDatabasesPath();
    _database = await openDatabase(
      join(path, 'shoesmarket.db'),
    );
    setState(() {
      isDatabaseInitialized = true;
    });
  }

  Future<Map<String, double>> _loadBranchSalesData() async {
    if (!isDatabaseInitialized) {
      return {};
    }

    try {
      List<Map<String, dynamic>> rawData = await _database.rawQuery('''
        SELECT b.branchname, SUM(o.quantity) as total_sales
        FROM ordered o
        JOIN branch b ON o.branch_branchcode = b.branchcode
        WHERE strftime('%m', o.paymenttime) = ?
        GROUP BY b.branchname
      ''', [selectedMonth]);

      return {
        for (var data in rawData)
          data['branchname'].toString(): (data['total_sales'] as num).toDouble(),
      };
    } catch (e) {
      print("Error loading branch sales data: $e");
      return {'데이터 없음': 1.0};
    }
  }

  void _onMonthChanged(String newMonth) {
    if (availableMonths.contains(newMonth)) {
      setState(() {
        selectedMonth = newMonth;
      });
    }
  }

  void _onPreviousMonth() {
    int currentMonthIndex = availableMonths.indexOf(selectedMonth);
    if (currentMonthIndex > 0) {
      _onMonthChanged(availableMonths[currentMonthIndex - 1]);
    }
  }

  void _onNextMonth() {
    int currentMonthIndex = availableMonths.indexOf(selectedMonth);
    if (currentMonthIndex < availableMonths.length - 1) {
      _onMonthChanged(availableMonths[currentMonthIndex + 1]);
    }
  }

  @override
  Widget build(BuildContext context) {
    String currentMonthName = DateFormat('MMMM').format(DateFormat('MM').parse(selectedMonth));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Branch Sales'),
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SignInPage()), // Navigate to SignInPage
            );
          },
        ),
      ),
      body: isDatabaseInitialized
          ? FutureBuilder<Map<String, double>>(
              future: _loadBranchSalesData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error loading data'));
                } else if (snapshot.hasData) {
                  final salesData = snapshot.data!;
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(Icons.arrow_back),
                              onPressed: _onPreviousMonth,
                              color: availableMonths.indexOf(selectedMonth) > 0
                                  ? Colors.black
                                  : Colors.grey, // 비활성화 색상 적용
                            ),
                            DropdownButton<String>(
                              value: selectedMonth,
                              items: availableMonths.map((month) {
                                return DropdownMenuItem(
                                  value: month,
                                  child: Text('$month 월'),
                                );
                              }).toList(),
                              onChanged: (newMonth) => _onMonthChanged(newMonth!),
                            ),
                            IconButton(
                              icon: Icon(Icons.arrow_forward),
                              onPressed: _onNextMonth,
                              color: availableMonths.indexOf(selectedMonth) < availableMonths.length - 1
                                  ? Colors.black
                                  : Colors.grey, // 비활성화 색상 적용
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          '$currentMonthName 매출 데이터',
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),
                        PieChart(
                          dataMap: salesData,
                          chartRadius: MediaQuery.of(context).size.width / 2,
                          legendOptions: const LegendOptions(
                            showLegends: true,
                            legendPosition: LegendPosition.bottom,
                          ),
                          chartValuesOptions: const ChartValuesOptions(
                            showChartValuesInPercentage: true,
                          ),
                        ),
                        const SizedBox(height: 20),
                        if (salesData.isEmpty || salesData.containsKey('데이터 없음'))
                          const Center(
                            child: Text('지점별 데이터가 비어있어요'),
                          ),
                      ],
                    ),
                  );
                } else {
                  return const Center(child: Text('No data available'));
                }
              },
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

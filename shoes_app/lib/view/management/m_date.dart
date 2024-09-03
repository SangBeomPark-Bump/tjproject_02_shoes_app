import 'package:flutter/material.dart';
import 'package:shoes_app/view/sign/sign_in.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart'; // 날짜 형식을 다루기 위해 추가

class MDate extends StatefulWidget {
  @override
  _MDateState createState() => _MDateState();
}

class _MDateState extends State<MDate> {
  late Database _database;
  List<_SalesData> salesData = [];
  bool isLoading = true;

  String selectedMonth = DateFormat('MM').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    String path = await getDatabasesPath();
    _database = await openDatabase(
      join(path, 'shoesmarket.db'),
    );
    _loadSalesData();
  }

  Future<void> _loadSalesData() async {
    try {
      List<Map<String, dynamic>> rawData = await _database.rawQuery('''
        SELECT strftime('%Y-%m-%d', paymenttime) as date, 
              strftime('%m', paymenttime) as month,
              SUM(quantity) as total_sales
        FROM ordered
        WHERE strftime('%m', paymenttime) = ?
        GROUP BY date
        ORDER BY date ASC
      ''', [selectedMonth]);

      setState(() {
        salesData = rawData.map((data) {
          return _SalesData(
            data['date'].toString(),
            (data['total_sales'] as num).toDouble(),
            int.parse(data['month'].toString()), // 월을 정수로 변환하여 저장
          );
        }).toList();
        isLoading = false;
      });

    } catch (e) {
      print("Error loading sales data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void _onMonthChanged(String newMonth) {
    setState(() {
      selectedMonth = newMonth;
      isLoading = true;
      _loadSalesData();
    });
  }

  void _onPreviousMonth() {
    int currentMonth = int.parse(selectedMonth);
    if (currentMonth > 1) {
      _onMonthChanged((currentMonth - 1).toString().padLeft(2, '0'));
    }
  }

  void _onNextMonth() {
    int currentMonth = int.parse(selectedMonth);
    if (currentMonth < 12) {
      _onMonthChanged((currentMonth + 1).toString().padLeft(2, '0'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monthly Sales'),
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SignInPage()), // SignInPage로 이동
            );
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: _onPreviousMonth, // 이전 달로 이동
                ),
                DropdownButton<String>(
                  value: selectedMonth,
                  items: List.generate(12, (index) {
                    final month = (index + 1).toString().padLeft(2, '0');
                    return DropdownMenuItem(
                      value: month,
                      child: Text('$month 월'),
                    );
                  }),
                  onChanged: (newMonth) => _onMonthChanged(newMonth!),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: _onNextMonth, // 다음 달로 이동
                ),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : SfCartesianChart(
                    primaryXAxis: CategoryAxis(),
                    title: ChartTitle(text: '월별 매출 데이터'),
                    legend: Legend(isVisible: true),
                    tooltipBehavior: TooltipBehavior(enable: true),
                    series: <CartesianSeries>[
                      ColumnSeries<_SalesData, String>(
                        dataSource: salesData,
                        xValueMapper: (_SalesData sales, _) => sales.date,
                        yValueMapper: (_SalesData sales, _) => sales.totalSales,
                        pointColorMapper: (_SalesData sales, _) => _getColorForMonth(sales.month),
                        name: '매출',
                        dataLabelSettings: const DataLabelSettings(isVisible: true),
                      )
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  // 각 월에 대한 색상을 반환하는 함수
  Color _getColorForMonth(int month) {
    switch (month) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.yellow;
      case 4:
        return Colors.green;
      case 5:
        return Colors.teal;
      case 6:
        return Colors.blue;
      case 7:
        return Colors.indigo;
      case 8:
        return Colors.purple;
      case 9:
        return Colors.pink;
      case 10:
        return Colors.brown;
      case 11:
        return Colors.grey;
      case 12:
        return Colors.black;
      default:
        return Colors.blueGrey;
    }
  }
}

// 매출 데이터 모델 클래스
class _SalesData {
  _SalesData(this.date, this.totalSales, this.month);

  final String date;
  final double totalSales;
  final int month; // 월을 저장하는 필드 추가
}

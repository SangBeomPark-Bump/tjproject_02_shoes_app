import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  late Database _database; //데이터베이스
  late String selectedMonth = DateFormat('yyyy-MM').format(DateTime.now()); // 보여줄 month를 저장하기 위한 변수
  late bool isDatabaseInitialized ; //database가 initialized됐는지 확인하기 위한 변수
  late bool monthInitial; // 처음 futurebuilder를 실행할때만 나올 변수

  @override
  void initState() {
    super.initState();
    selectedMonth = DateFormat('yyyy-MM').format(DateTime.now());
    monthInitial = true;
    isDatabaseInitialized = false;
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    String path = await getDatabasesPath();
    _database = await openDatabase(
      join(path, 'shoesmarket.db'),
    ); // 데이터베이스가 있다는 가정 
    setState(() {
      isDatabaseInitialized = true;
    });
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Branch Sales'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Get.off(() => const SignInPage()); // 누르면 돌아가게끔
          },
        ),
      ),
      body: isDatabaseInitialized
          ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FutureBuilder( // 드랍다운을 차트보다 먼저 만들기 위한 futurebuilder
                future: _loadAvailableMonth(), // 일단 availableMonths를 먼저 가져오고
                builder: (context, availableMonths) => 
                
                availableMonths.data !=null
                    ? Column( // availableMonths를 다 가져왔으면 드랍다운과 위아래 스위치를 만든다
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ////////////////// 뒤로가는버튼
                              IconButton(
                                icon: Icon(Icons.arrow_back),
                                onPressed: () =>
                                    _onPreviousMonth(availableMonths.data!),
                                color: availableMonths.data!
                                            .indexOf(selectedMonth) >
                                        0
                                    ? Colors.black
                                    : Colors.grey, // 비활성화 색상 적용
                              ),
                              ////////////////////// dropdown   
                              DropdownButton<String>(
                                value: selectedMonth,
                                items: availableMonths.data!.map((month) {
                                  return DropdownMenuItem(
                                    value: month,
                                    child: Text('$month 월'),
                                  );
                                }).toList(),
                                onChanged: (newMonth) {
                                  _onMonthChanged(newMonth!);
                                },
                              ),
                              ///////////////// 앞으로가는버튼
                              IconButton(
                                icon: const Icon(Icons.arrow_forward),
                                onPressed: () =>
                                    _onNextMonth(availableMonths.data!),
                                color: availableMonths.data!
                                            .indexOf(selectedMonth) <
                                        availableMonths.data!.length - 1
                                    ? Colors.black
                                    : Colors.grey, // 비활성화 색상 적용
                              ),
                            ],
                          ),
                          FutureBuilder<Map<String, double>>( // 차트를 만들기위한 futurebuilder, 위쪽 futurebuilder에서 
                          ////selectedmonth와 availablemonth를 받아오기 위해 추가됨.
                            future: _loadBranchSalesData(selectedMonth), // 차트를 그리기 위한 데이터 불러오기
                            builder: (context, snapshot) {
                              // print(snapshot.data);
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator()); // 기다리는중이면 CircularProgressIndicator
                              } else if (snapshot.hasData) {
                                final salesData = snapshot.data!;
                                return Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 20),
                                      Text( /// 차트 제목
                                        '${DateFormat('yyyy-MMMM').format(DateFormat('yyyy-MM').parse(selectedMonth))} 매출데이터', 
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 20),

                                      //////파이차트
                                      PieChart(
                                        dataMap: salesData,
                                        chartRadius: MediaQuery.of(context)
                                                .size
                                                .width /
                                            2,
                                        legendOptions: const LegendOptions(
                                          showLegends: true,
                                          legendPosition:
                                              LegendPosition.bottom,
                                        ),
                                        chartValuesOptions:
                                            const ChartValuesOptions(
                                          showChartValuesInPercentage: true,
                                        ),
                                      ),
                                      const SizedBox(height: 20),


                                      if (salesData.isEmpty || // 데이터가 없을때의 처리
                                          salesData.containsKey('데이터 없음'))
                                        const Center(
                                          child: Text('지점별 데이터가 비어있어요'),
                                        ),
                                    ],
                                  ),
                                );
                              } else {
                                return const Center(
                                    child: Text('No data available'));
                              }
                            },
                          ),
                        ],
                      )
                    : const CircularProgressIndicator(),
              ),
            ],
          )
          : const Center(child: CircularProgressIndicator()),
    );
  }




//가능한 Month를 가져오는 함수
  Future<List<String>> _loadAvailableMonth() async { 
    List<Map<String, dynamic>> rawData = await _database.rawQuery(
      '''
        SELECT substr(o.paymenttime, 0, 7) as ym
        FROM ordered o
        where ym != 'null'
        AND o.canceltime IS 'null'
        GROUP BY ym
      ''', );
      List<String> availableMonths = [];
      for (Map i in rawData){

        availableMonths.add(i['ym']);
      }
      if(monthInitial){
        monthInitial = false;
        selectedMonth = availableMonths[availableMonths.length-1];}
      return availableMonths;
  }

// piechart에 필요한 데이터를 가져오는 함수
  Future<Map<String, double>> _loadBranchSalesData(selectedMonth) async {
    List<Map<String, dynamic>> rawData = await _database.rawQuery('''
      SELECT b.branchname, SUM(o.quantity) as total_sales
      FROM ordered o
      JOIN branch b ON o.branch_branchcode = b.branchcode
      WHERE strftime('%Y-%m', o.paymenttime) = ?
      AND o.canceltime IS 'null'
      GROUP BY b.branchname
    ''', [selectedMonth]);
    if (rawData.isNotEmpty) {
      return {
        for (var data in rawData)
          data['branchname'].toString():
              (data['total_sales'] as num).toDouble(),
      };
    } else {
      return {'데이터 없음': 1.0};
    }
  }



// 날짜의 이런저런 변화들을 전부 감지해주는 함수
  void _onMonthChanged(String newMonth) {
    selectedMonth = newMonth;
    setState(() {});
  }

// 왼쪽화살표 누르면 작동하는 함수
  void _onPreviousMonth(availableMonths) {
    print(availableMonths);
    int currentMonthIndex = availableMonths.indexOf(selectedMonth);
    if (currentMonthIndex > 0) {
      // print(availableMonths);
      _onMonthChanged(availableMonths[currentMonthIndex - 1]);
    }
  }

// 오른쪽화살표 누르면 작동하는 함수
  void _onNextMonth(availableMonths) {
    int currentMonthIndex = availableMonths.indexOf(selectedMonth);
    if (currentMonthIndex < availableMonths.length - 1) {
      _onMonthChanged(availableMonths[currentMonthIndex + 1]);
    }
  }














}// End

import 'package:flutter/material.dart';
import 'package:shoes_app/vm/database_handler_product.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart'; // 날짜 포맷을 위해 추가
// 데이터베이스 핸들러 클래스 import

class MProduct extends StatefulWidget {
  @override
  _MProductState createState() => _MProductState();
}

class _MProductState extends State<MProduct> {
  late Future<List<String>> keysFutre;
  Future<List<List<dynamic>>>? dataFuture;
  late DatabaseHandler_Product dbHandler;
  late int keyidx;

  @override
  void initState() {
    super.initState();
    // DatabaseHandlerProduct 클래스의 인스턴스를 생성하고 데이터 가져오기
    dbHandler = DatabaseHandler_Product();
    keysFutre = dbHandler.queryProductkeys();
    
    keyidx = 0;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Monthly Sales Data'),
      ),
      body: FutureBuilder(
        future: keysFutre,
        builder:(context,keys) { 
          return keys.hasData? Center(
          child: Column(
            children: [
              DropdownButton(
                value: keys.data![keyidx],
                items: keys.data!.map((key) {
                  return DropdownMenuItem(
                    value: key,
                    child: Text(key));
                },).toList(), 
                onChanged: (changedkey){
                  keyidx = keys.data!.indexOf(changedkey!);
                  setState(() {});
                }
              ),
              FutureBuilder<List<List<dynamic>>>(
                future: dbHandler.queryTotalPriceByMonth(keys.data![keyidx]),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text('No data available');
                  } else {
                    final chartData = snapshot.data!.map((data) {
                      DateTime date = data[0] as DateTime;
                      int value = data[1] as int;
                      return ChartData(DateFormat.yMMM().format(date), value);
                    }).toList();
                      
                    return SfCartesianChart(
                      primaryXAxis: CategoryAxis(
                        title: AxisTitle(text: 'Month'), // 가로축 제목 설정
                      ),
                      primaryYAxis: NumericAxis(
                        title: AxisTitle(text: 'Total Sales'), // 세로축 제목 설정
                      ),
                      series: <CartesianSeries>[
                        ColumnSeries<ChartData, String>(
                          dataSource: chartData,
                          xValueMapper: (ChartData data, _) => data.month,
                          yValueMapper: (ChartData data, _) => data.value,
                          color: Colors.blue, // 바 차트 색상 설정
                        ),
                      ],
                    );
                  }
                },
              ),
            ],
          )
        )
        : const CircularProgressIndicator()
        ;
        
        },
      ),
    );
  }
}

// ChartData 클래스
class ChartData {
  final String month;
  final int value;

  ChartData(this.month, this.value);
}

import 'package:flutter/material.dart';
import 'package:shoes_app/vm/database_handler_product.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart'; 

class MProduct extends StatefulWidget {

  const MProduct({super.key});
  @override
  MProductState createState() => MProductState();
}

class MProductState extends State<MProduct> {
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
        title: const Text('Monthly Sales Data'),
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
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('No data available');
                  } else {
                    final chartData = snapshot.data!.map((data) {
                      DateTime date = data[0] as DateTime;
                      int value = data[1] as int;
                      return ChartData(DateFormat.yMMM().format(date), value);
                    }).toList();
                      
                    return Expanded(
                      child: SfCartesianChart(
                        primaryXAxis: const CategoryAxis(
                          title: AxisTitle(text: 'Month'), // 가로축 제목 설정
                        ),
                        primaryYAxis: const NumericAxis(
                          title:  AxisTitle(text: 'Total Sales'), // 세로축 제목 설정
                        ),
                        series: <CartesianSeries>[
                          ColumnSeries<ChartData, String>(
                            dataSource: chartData,
                            xValueMapper: (ChartData data, _) => data.month,
                            yValueMapper: (ChartData data, _) => data.value,
                            color: Colors.blue, // 바 차트 색상 설정
                          ),
                        ],
                      ),
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

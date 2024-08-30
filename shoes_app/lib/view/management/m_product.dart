import 'package:flutter/material.dart';
import 'package:shoes_app/view/sign/sign_in.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:shoes_app/vm/database_handler_product.dart';

class BarchartData {
  int month;
  int totalprice;

  BarchartData({required this.month, required this.totalprice});
}

class MProduct extends StatefulWidget {
  const MProduct({super.key});

  @override
  State<MProduct> createState() => _MProductState();
}

class _MProductState extends State<MProduct> {
  late TooltipBehavior tooltipBehavior;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tooltipBehavior = TooltipBehavior();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product'),
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const SignInPage()), // SignInPage로 이동
            );
          },
        ),
      ),
      body: Center(
        child: SizedBox(
          width: 380,
          height: 600,
          child: ElevatedButton(
            onPressed: (){
              buttonPressed();
            }, 
            child: const Text('우와')),
          // child: SfCartesianChart(
          //   title: const ChartTitle(
          //       text: 'Yearly Growth in the Flutter Community'),
          //   tooltipBehavior: tooltipBehavior,
          //   series: [
          //     BarSeries<BarchartData, int>(
          //       color: Colors.red,
          //       name: 'Developers',
          //       dataSource: data,
          //       xValueMapper: (BarchartData developers, x) {
          //         print(x);
          //         return developers.year;
          //       },
          //       yValueMapper: (DeveloperData developers, _) =>
          //           developers.developers,
          //       dataLabelSettings: const DataLabelSettings(isVisible: true),
          //       enableTooltip: true,
          //     ),
          //   ],
          //   // x축 타이틀(xlabel)
          //   primaryXAxis: CategoryAxis(
          //     title: AxisTitle(text: '년도'),
          //   ),
          //   // y축 타이틀(ylabel)
          //   primaryYAxis: CategoryAxis(
          //     title: AxisTitle(text: '인원수'),
          //   ),
          // ),
        ),
      ),
    );
  }

  //Functions
  buttonPressed(){
    DatabaseHandler_Product().queryProductChart();
  }






}// End


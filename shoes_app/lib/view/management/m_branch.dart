import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // 현재 월을 가져오기 위해 사용
import 'package:pie_chart/pie_chart.dart'; // 파이 그래프를 사용하기 위해 필요

class MBranch extends StatefulWidget {
  const MBranch({super.key});

  @override
  State<MBranch> createState() => _MBranchState();
}

class _MBranchState extends State<MBranch> {
  // 지점별 매출 데이터
  final Map<String, double> salesData = {
    '강남점': 35000000,
    '노원점': 25000000,
    '신도림점': 15000000,
  };

  @override
  Widget build(BuildContext context) {
    // 현재 월 가져오기
    String currentMonth = DateFormat('MMMM').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Branch'),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$currentMonth 매출 데이터',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
            const Center(
              child: Text('임시 데이터'),
            ),
          ],
        ),
      ),
    );
  }
}

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: const Center(
        child: Text('Sign In Page'),
      ),
    );
  }
}

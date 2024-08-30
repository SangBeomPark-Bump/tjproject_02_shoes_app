
import 'package:flutter/material.dart';
import 'package:shoes_app/vm/database_handler.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MCustomer extends StatefulWidget {
  const MCustomer({super.key});

  @override
  State<MCustomer> createState() => _MCustomerState();
}

class _MCustomerState extends State<MCustomer> {
  late TooltipBehavior tooltipBehavior; 
  late List<String> item; // dropdownbutton 리스트
  late String dropdownValue;  // dropdownbutton 선택
  late DatabaseHandler handler;

  

  @override
  void initState() {
    super.initState();
    tooltipBehavior = TooltipBehavior();
    item = ["구매내역","총매출"]; 
    dropdownValue = "구매내역"; //dropdownbutton 선택 초기값
    handler = DatabaseHandler();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("고객관리"),
      ),
      body: Center(
        child: Column(
          children: [
                DropdownButton<String>( //지점 선택 드랍다운
                dropdownColor: Theme.of(context).colorScheme.primaryContainer,
                  value: dropdownValue, // 선택한 이름
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: item.map((String item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                      dropdownValue = value!;
                      setState(() {
                      });
                  },
                ),
                FutureBuilder(
                  future: handler.queryOrder(),
                  builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(), //데이터 불러오기 전
                );
              } else if (snapshot.hasError) { //error check
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else if (snapshot.hasData && snapshot.data != null) { //데이터 있을때 
                return SizedBox(
                  height: 500,
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Row(
                          children: [
                            Text(snapshot.data![index].customer_id), //고객 이름
                            Text("성별"),  //성별 rnumber로 계산
                            Text("나이계산"), //나이 rnumber로 계산
                            Text(snapshot.data![index].shoes_seq.toString()), //신발 코드로 제품명 찾기
                            Text(snapshot.data![index].paymenttime.toString()),
                            Text(snapshot.data![index].branch_branchcode.toString()) //지점코드로 지점명 찾기
                          ]
                        ),
                      );
                    },
                  ),
                );
              } else {
                return const Center(
                  child: Text('비어있음'), //고객 정보 없을 때
                );
              }
                  },
                  )
          ],
        ),
      ),
    );
  }
}
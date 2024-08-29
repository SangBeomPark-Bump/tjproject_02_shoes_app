import 'package:flutter/material.dart';
import 'package:shoes_app/model/branch.dart';
import 'package:shoes_app/vm/database_handler.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {

    // Property
  late DatabaseHandler handler;

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
  }
  




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('테스트 입니다!'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: (){
            pressed();
          },
          child: const Text('야호')
        ),
      ),
    );
  }

  pressed() async {
    List<Branch> result = await (handler.queryBranch());
    print(result);
  }



}//End
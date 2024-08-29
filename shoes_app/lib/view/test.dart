import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shoes_app/model/branch.dart';
import 'package:shoes_app/model/shoes.dart';
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
      String imagePath = 'images/monkey.png'; // 변환하고자 하는 이미지 경로
      Uint8List binaryImage = await loadAssetAsBinary(imagePath);

      Shoes shoe = Shoes(shoesname: 'NIKE Black', price: 100000, image: binaryImage, size: 265, brand: 'NIKE');
      handler.insertShoe(shoe);

    List<Shoes> result = await (handler.queryShoes());
    print(result);
  }

//FUnctions
Future<Uint8List> loadAssetAsBinary(String assetPath) async {
  // assetPath는 Asset 이미지의 경로 예: 'assets/images/sample.png'
  ByteData byteData = await rootBundle.load(assetPath); // 이미지 로드
  Uint8List imageBytes = byteData.buffer.asUint8List(); // ByteData를 Uint8List로 변환
  return imageBytes;
}


}//End
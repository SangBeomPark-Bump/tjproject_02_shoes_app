import 'package:flutter/material.dart';
import 'package:shoes_app/view/sign/sign_in.dart';

class MDate extends StatefulWidget {
  const MDate({super.key});

  @override
  State<MDate> createState() => _MDateState();
}

class _MDateState extends State<MDate> {
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
              MaterialPageRoute(builder: (context) => const SignInPage()), // SignInPage로 이동
            );
          },
        ),
      ),

      body: const Center(
        child: Text('상품별 데이터가 비어있어요'),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:shoes_app/view/sign/sign_in.dart';

class MCustomer extends StatefulWidget {
  const MCustomer({super.key});

  @override
  State<MCustomer> createState() => _MCustomerState();
}

class _MCustomerState extends State<MCustomer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer'),
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
        child: Text('손님별 데이터가 비어있어요'),
      ),
    );
  }
}
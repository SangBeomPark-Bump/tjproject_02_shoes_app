import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoes_app/view/home.dart';
import 'package:shoes_app/view/sign/sign_in.dart';
import 'package:shoes_app/view/test.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SignInPage(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoes_app/view/kiosk/k_login.dart';
import 'package:shoes_app/view/management/m_home.dart';
import 'view/home.dart';
import 'view/sign/sign_in.dart';
import 'view/sign/sign_up.dart';
import 'view/test.dart';
import 'view/sign/sign_in.dart';

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

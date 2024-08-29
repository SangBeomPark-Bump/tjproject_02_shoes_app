import 'package:flutter/material.dart';
import 'package:shoes_app/view/sign/sign_in.dart';

class DetailPage extends StatelessWidget {
  final String imageUrl;

  const DetailPage({required this.imageUrl, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail'),

      ),

      body: Center(
        child: Image.asset(imageUrl),
      ),
    );
  }
}

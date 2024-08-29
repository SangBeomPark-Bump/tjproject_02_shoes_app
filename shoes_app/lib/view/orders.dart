import 'package:flutter/material.dart';
import 'package:shoes_app/view/sign/sign_in.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('구매내역'),
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {
            _showLogoutConfirmationDialog(context);
          },
        ),
      ),
      body: const Center(
        child: Text('구매내역이 비어있어용'),
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('로그아웃'),
          content: const Text('로그아웃하시겠습니까?'),
          actions: <Widget>[
            TextButton(
              child: const Text('아니오'),
              onPressed: () {
                Navigator.of(context).pop(); // 대화 상자 닫기
              },
            ),
            TextButton(
              child: const Text('예'),
              onPressed: () {
                Navigator.of(context).pop(); // 대화 상자 닫기
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const SignInPage()), // SignInPage로 이동
                );
              },
            ),
          ],
        );
      },
    );
  }
}

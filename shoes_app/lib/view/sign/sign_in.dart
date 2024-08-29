import 'package:flutter/material.dart';
import 'package:shoes_app/view/home.dart';
import 'package:shoes_app/view/management/m_branch.dart';
import 'package:shoes_app/view/management/m_home.dart';
import 'package:shoes_app/view/sign/sign_up.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('로그인'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // 버튼을 중앙에 정렬
          children: [
//////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////테스트 접근용 추후 삭제///////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////
            ElevatedButton(
              onPressed: () {
                // 로그인 로직을 여기에 추가하고, 성공 시 아래의 코드로 이동하세요
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
              child: const Text('Customer'),
            ),
            const SizedBox(height: 20), // 버튼 간의 간격 조정
//////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpPage()),
                );
              },
              child: const Text('회원가입'),
            ),
            const SizedBox(height: 20), // 버튼 간의 간격 조정
            ElevatedButton(
              onPressed: () {
                // 관리자 페이지로 이동
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const MHome()),
                );
              },
              child: const Text('Management'),
            ),
          ],
        ),
      ),
    );
  }
}

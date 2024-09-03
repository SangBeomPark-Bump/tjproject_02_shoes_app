import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shoes_app/view/home.dart';
import 'package:shoes_app/view/management/m_home.dart';
import 'package:shoes_app/view/sign/sign_up.dart';
import 'package:shoes_app/view/test.dart';
import 'package:shoes_app/vm/database_sign_up_handler.dart';

class SignInPage extends StatefulWidget {
    const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();
  int isExist = 0; 
  final box = GetStorage();
  final _adminid = 'admin';
  final _adminpassword = '2424';

  @override
  void initState() {
    super.initState();
    initStorage();
  }

  initStorage() {
    box.write('userId', '');
    box.write('p_password', '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // 키보드가 올라와도 화면이 밀리지 않게 함
      body: Stack(
        children: [
          Image.asset(
            'images/Sign in.png',
            fit: BoxFit.cover, // 이미지가 화면을 완전히 덮도록 함
            width: double.infinity,
            height: double.infinity,
          ),
          Center(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '더조은 신발가게',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                    const SizedBox(height: 50),
                    const Text(
                      'Sign in',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _idController,
                      decoration: const InputDecoration(
                        labelText: 'Id',
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '아이디를 입력해주세요';
                        }
                        if (isExist == 0) {
                          return '아이디나 비밀번호가 일치하지 않습니다';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8.0),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'PassWord',
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '비밀번호를 입력해주세요';
                        }
                        if (isExist == 0) {
                          return '아이디나 비밀번호가 일치하지 않습니다';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            isExist = 0;
                            setState(() {});
                            _submitForm(context);
                          },
                          child: const Text('Sign In'),
                        ),
                        const SizedBox(width: 50),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Get.off(() => const SignUpPage());
                            
                          },
                          child: const Text('Sign Up'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20), 
                    ElevatedButton(
                      onPressed: () {
                        Get.to(() => const Test());
                      },
                      child: const Text('데이터 생성'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _submitForm(context) async {
    if (_idController.text.trim() == _adminid && _passwordController.text.trim() == _adminpassword) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('관리자 로그인'),
            content: const Text('환영합니다! 관리자님!'),
            actions: <Widget>[
              TextButton(
                child: const Text('확인'),
                onPressed: () {
                  Get.off(() =>const MHome());
                },
              ),
            ],
          );
        },
      );
    } else {
      isExist = await DatabaseSignUpHandler().idPasswordCustomer(_idController.text.trim(), _passwordController.text.trim());
      setState(() {});
      if (_formKey.currentState!.validate()) {
        box.write('userId', _idController.text.trim());
        _showEnterDialog(context);
      }
    }
  }

  void _showEnterDialog(BuildContext context) {
    String userId = box.read('userId');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('로그인'),
          content: Text('환영합니다! $userId 님!'),
          actions: <Widget>[
            TextButton(
              child: const Text('확인'),
              onPressed: () {
                Get.back();
                Get.off(() => HomePage());
              },
            ),
          ],
        );
      },
    );
  }
}

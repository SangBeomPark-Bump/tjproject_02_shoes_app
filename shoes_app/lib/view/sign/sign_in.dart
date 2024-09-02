import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shoes_app/view/home.dart';
import 'package:shoes_app/view/management/m_home.dart';
import 'package:shoes_app/view/sign/sign_up.dart';
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
  

  initStorage(){
    box.write('userId', '');
    box.write('p_password', '');
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('로그인'),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // 버튼을 중앙에 정렬
              children: [
                  TextFormField(
                    controller: _idController,
                    decoration: const InputDecoration(
                      labelText: 'Id',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '아이디를 입력해주세요';
                      }
                      if (isExist ==0){
                        return '아이디나 비밀번호가 일치하지 않습니다';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'PassWord',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '비밀번호를 입력해주세요';
                      }
                      if (isExist ==0){
                        return '아이디나 비밀번호가 일치하지 않습니다';
                      }
                      // 간단한 이메일 유효성 검사
                      return null;
                    },
                  ),
                  const SizedBox(height: 20,),
            //////////////////////////////////////////////////////////////////////////////////////////////////////
            //////////////////////////////////테스트 접근용 추후 삭제///////////////////////////////////////////////
            //////////////////////////////////////////////////////////////////////////////////////////////////////
                ElevatedButton(
                  onPressed: () {
                    isExist = 0;
                    setState(() {});
                    _submitForm(context);
                  },
                  child: const Text('Sign in'),
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
        ),
      ),
    );
  }


    void _submitForm(context)async {
    if (_idController.text.trim() == _adminid && _passwordController.text.trim() == _adminpassword ){
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('관리자 로그인'),
          content: const Text('환영합니다! 관리자님!' ),
          actions: <Widget>[
            TextButton(
              child: const Text('확인'),
              onPressed: () {
                Get.back();
                Get.back();
                Get.to(() => const MHome());
              },
            ),
          ],
        );
      },
    );








    }else{
        isExist = await DatabaseSignUpHandler().idPasswordCustomer(_idController.text.trim(), _passwordController.text.trim());  
        setState(() {});
      if (_formKey.currentState!.validate()) {
        // 모든 입력이 유효할 경우
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
          content: Text('환영합니다! $userId 님!' ),
          actions: <Widget>[
            TextButton(
              child: const Text('확인'),
              onPressed: () {
                Navigator.of(context).pop(); // 대화 상자 닫기
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()), // SignInPage로 이동
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _showEnterMDialog(BuildContext context) {
    String userId = box.read('userId');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('로그인'),
          content: Text('환영합니다! $userId 님!' ),
          actions: <Widget>[
            TextButton(
              child: const Text('확인'),
              onPressed: () {
                Navigator.of(context).pop(); // 대화 상자 닫기
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()), // SignInPage로 이동
                );
              },
            ),
          ],
        );
      },
    );
  }



}// End

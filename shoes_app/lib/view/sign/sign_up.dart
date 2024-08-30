import 'package:flutter/material.dart';
import 'package:shoes_app/model/customer.dart';
import 'package:shoes_app/view/sign/sign_in.dart'; // SignInPage 경로에 맞게 수정하세요
import 'package:flutter/services.dart';
import 'package:shoes_app/vm/database_sign_up_handler.dart'; // inputFormatters를 사용하기 위해 필요

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  int isIdDup = 0;

  final _handler = DatabaseSignUpHandler();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _ssnController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  bool _passwordsMatch = true;

  void _checkPasswordsMatch() {
    setState(() {
      _passwordsMatch = _passwordController.text == _confirmPasswordController.text;
    });
  }

  void _showCancelConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('회원가입 중단'),
          content: const Text('회원가입을 중단하시겠습니까?'),
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

  void _formatSsnInput(String value) {
    if (value.length == 6) {
      _ssnController.text = '$value-';
      _ssnController.selection = TextSelection.fromPosition(
        TextPosition(offset: _ssnController.text.length),
      );
    } else if (value.length == 8) {
      _ssnController.text = value;
      _ssnController.selection = TextSelection.fromPosition(
        TextPosition(offset: _ssnController.text.length),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('회원가입'),
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {
            _showCancelConfirmationDialog(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: '이름',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '이름을 입력하세요';
                  }
                  return null;
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _idController,
                      onChanged: (value) {
                        isIdDup = 1;
                        print(isIdDup);
                      },
                      decoration: const InputDecoration(
                        labelText: '아이디',
                      ),
                      validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '아이디를 입력하세요';
                          }
                          if (value.length < 5) {
                            return '아이디는 5자리 이상이어야 합니다';
                          }
                          if (isIdDup !=0){
                            return '중복 확인을 해주세요';
                          }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () async{
                      isIdDup = await _handler.idCustomer(_idController.text);
                      print(isIdDup);
                      // 아이디 중복 확인 로직을 추가할 수 있습니다.
                      ScaffoldMessenger.of(context).showSnackBar(
                        isIdDup != 0
                        ? const SnackBar(content: Text('아이디가 중복입니다'), backgroundColor: Colors.red,)
                        : const SnackBar(content: Text('사용가능한 아이디입니다.'), backgroundColor: Colors.blue,)
                        ,
                      );
                    },
                    child: const Text('중복 확인'),
                  ),
                ],
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: '비밀번호',
                ),
                obscureText: true, // 비밀번호 필드 가리기
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '비밀번호를 입력하세요';
                  }
                  if (value.length < 6) {
                    return '비밀번호는 6자리 이상이어야 합니다';
                  }
                  return null;
                },
                onChanged: (_) => _checkPasswordsMatch(),
              ),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(
                  labelText: '비밀번호 확인',
                ),
                obscureText: true, // 비밀번호 확인 필드 가리기
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '비밀번호 확인을 입력하세요';
                  }
                  if (!_passwordsMatch) {
                    return '비밀번호가 일치하지 않습니다';
                  }
                  return null;
                },
                onChanged: (_) => _checkPasswordsMatch(),
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: '전화번호',
                ),
                keyboardType: TextInputType.number, // 번호 입력 전용 키보드
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly, // 숫자만 입력 가능
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '전화번호를 입력하세요';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _ssnController,
                decoration: const InputDecoration(
                  labelText: '주민번호',
                ),
                keyboardType: TextInputType.number, // 번호 입력 전용 키보드
                inputFormatters: [
                  LengthLimitingTextInputFormatter(8), // '-' 포함 8자리로 제한
                  FilteringTextInputFormatter.digitsOnly,
                  TextInputFormatter.withFunction((oldValue, newValue) {
                    if (newValue.text.length > 6 && !newValue.text.contains('-')) {
                      final text = newValue.text.substring(0, 6) + '-' + newValue.text.substring(6);
                      return TextEditingValue(
                        text: text,
                        selection: TextSelection.collapsed(offset: text.length),
                      );
                    }
                    return newValue;
                  }),
                ],
                onChanged: (value) {
                  _formatSsnInput(value);
                },
                validator: (value) {
                  if (value == null || value.isEmpty || value.length != 8) {
                    return '올바른 주민번호를 입력하세요';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: '이메일',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '이메일을 입력하세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() == true) {
                    Customer customer = Customer(
                      id: _idController.text.trim(), 
                      password: _passwordController.text.trim(), 
                      name: _nameController.text.trim(), 
                      phone: _phoneController.text.trim(), 
                      email: _emailController.text.trim(), 
                      rnumber: _ssnController.text.trim()
                    );
                    // 모든 필드가 유효할 때의 처리
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('회원가입이 완료되었습니다!')),
                    );
                    _handler.insertCustomer(customer);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const SignInPage()), // SignInPage로 이동
                    );
                  }
                },
                child: const Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

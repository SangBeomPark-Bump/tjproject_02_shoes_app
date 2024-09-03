import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shoes_app/view/kiosk/k_home.dart';
import 'package:shoes_app/vm/database_handler.dart';
import 'package:shoes_app/vm/database_handler_management.dart';
import 'package:shoes_app/vm/database_kiosk_handler.dart';

class KLogin extends StatefulWidget {
  const KLogin({super.key});

  @override
  State<KLogin> createState() => _KLoginState();
}

class _KLoginState extends State<KLogin> {
  //property
  late TextEditingController idController;
  late TextEditingController passwordController;
  DatabaseKioskHandler kioskHandler = DatabaseKioskHandler();
  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    idController = TextEditingController();
    passwordController = TextEditingController();
    box.write('kioskID', ""); //앱 시작시 id 초기화
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>  FocusScope.of(context).unfocus(),
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'images/shoes_kiosk.png'
            )
          )
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(200),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '더조은 신발가게 강남점',
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold
                    ),
                    ),
                    const SizedBox(
                      height: 100,
                    ),
                    const Text("LOGIN",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30
                    ),
                    ),
                    const SizedBox(height: 50),
                    //idd
                    TextField(
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9a-z]'))
                      ],
                      controller: idController,
                      decoration: const InputDecoration(
                        hintText: "ID",
                      ),
                    ),
                    const SizedBox(height: 30),
                    //password 입력
                    TextField(
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9a-z]'))
                      ],
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: "Password"
                      ),
                    ),
                    const SizedBox(height: 50,),
                    ElevatedButton(
                      onPressed: () async{
                        Customer customer = Customer(
                          id: idController.text.trim(),
                          password:  passwordController.text.trim()
                        );
                          int result = await kioskHandler.kioskqueryCustomer(customer);
                            if(idController.text.trim().isEmpty || 
                              passwordController.text.trim().isEmpty){
                                errorSnackBar();
                            }else{
                              if(result == 0){
                                notCorrectDialog();
                                }else{
                                  loginDialog();
                                }
                            }
                      }, 
                    child: const Text('Sign In')
                    )
                    
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }


  //로그인 실패
notCorrectDialog(){
  Get.defaultDialog(
    title: "로그인 실패",
    middleText: '회원정보가 일치하지 않습니다.',
    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
    barrierDismissible: false,
    actions: [
      TextButton(
        onPressed: () => Get.back(),
        child: const Text('확인')
        )
    ]
  );
}
//로그인 성공
loginDialog(){
  Get.defaultDialog(
    title: "${idController.text.trim()}님 환영합니다.",
    middleText: '제품 수령 페이지로 이동합니다.',
    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
    barrierDismissible: false,
    actions: [
      TextButton(
        onPressed: (){
          Get.back();
          Get.to(const KHome());
          box.write('kioskID', idController.text.trim());
          idController.clear();
          passwordController.clear();
          },
        child: const Text('확인')
        )
    ]
  );
}

//입력 안했을때 
errorSnackBar(){ //get package SnackBar
  Get.snackbar(
    "경고",
   "ID,Password를 모두 입력하세요",
   snackPosition: SnackPosition.BOTTOM,   //기본값 = top
   duration: const Duration(seconds: 2),
   backgroundColor: Theme.of(context).colorScheme.error,
   );
}

}//End

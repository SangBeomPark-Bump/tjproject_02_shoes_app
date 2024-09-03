import 'package:flutter/services.dart';
import 'package:shoes_app/model/branch.dart';
import 'package:shoes_app/model/customer.dart';
import 'package:shoes_app/model/order.dart';
import 'dart:math';

import 'package:shoes_app/model/shoes.dart';


// 데이터베이스에 집어넣기 위한 정보를 저장해두는 클래스//
class MadeOrderPsb{
  Random random = Random();

  Future<List<Shoes>>shoes()async{
    List imageList = [
      await loadAssetAsBinary('images/newb_red.png'),
      await loadAssetAsBinary('images/newb_white.png'),
      await loadAssetAsBinary('images/nike_black.png'),
      await loadAssetAsBinary('images/nike_red.png'),
      await loadAssetAsBinary('images/prosp_black.png'),
      await loadAssetAsBinary('images/prosp_red.png'),
    ];
    List<Shoes> shoes = [
      Shoes(
          shoesname: 'Newb Red',
          price: 100000,
          image: imageList[0],
          size: 265,
          brand: 'newBalance'),
      Shoes(
          shoesname: 'Newb White',
          price: 100000,
          image: imageList[1],
          size: 255,
          brand: 'newBalance'),
      Shoes(
          shoesname: 'NIKE Black',
          price: 120000,
          image: imageList[2],
          size: 265,
          brand: 'NIKE'),
      Shoes(
          shoesname: 'NIKE Red',
          price: 120000,
          image: imageList[3],
          size: 255,
          brand: 'NIKE'),
      Shoes(
          shoesname: 'Prosp Black',
          price: 130000,
          image: imageList[4],
          size: 265,
          brand: 'prosPecs'),
      Shoes(
          shoesname: 'Prosp Red',
          price: 130000,
          image: imageList[5],
          size: 255,
          brand: 'prosPecs'),
    ];
    return shoes;
  }

  List<Customer>customer(){
        List<Customer> customers = [
      Customer(
          id: 'yubee',
          password: '123',
          name: '유비',
          phone: '010-1234-5678',
          email: 'yubee@naver.com',
          rnumber: '621004-1'),
      Customer(
          id: 'gwanwoo',
          password: '123',
          name: '관우',
          phone: '010-1234-5678',
          email: 'gwanwoo@naver.com',
          rnumber: '151104-3'),
      Customer(
          id: 'jangbee',
          password: '123',
          name: '장비',
          phone: '010-1234-5678',
          email: 'jannbee@naver.com',
          rnumber: '830806-1'),
      Customer(
          id: 'yeopho',
          password: '123',
          name: '여포',
          phone: '010-1234-5678',
          email: 'yeopho@naver.com',
          rnumber: '951114-1'),
      Customer(
          id: 'choseon',
          password: '123',
          name: '초선',
          phone: '010-1234-5678',
          email: 'choseon@naver.com',
          rnumber: '890715-2'),
      Customer(
          id: 'heonje',
          password: '123',
          name: '헌제',
          phone: '010-1234-5678',
          email: 'heonje@naver.com',
          rnumber: '000121-1'),
      Customer(
          id: 'gyenhui',
          password: '123',
          name: '견희',
          phone: '010-1234-5678',
          email: 'gyenhui@naver.com',
          rnumber: '020402-4'),
    ];
    return customers;
  }



  List<Branch>branch(){
    List<Branch> branches = [
      Branch(branchname: '강남점'),
      Branch(branchname: '신도림점'),
      Branch(branchname: '노원점'),
    ];
    return branches;

  }

  
  List<Order>order(){

    List<String> nameList = ['yubee','gwanwoo','jangbee','yeopho','choseon','heonje','gyenhui'];

    List<Order> orderList = [];
    int orderq = random.nextInt(10)+10;

    for(int j = 1 ; j<9; j++){


      for (int i = 0; i<orderq; i++){
      late int day;
        if ([1,3,5,7,8,10,12].contains(j)){
          day = random.nextInt(31)+1;
        }
        else if(j == 2){
          day = random.nextInt(28)+1;
        }else{
          day = random.nextInt(30)+1;
        }

        int pickupCancle = random.nextInt(10);
      

        DateTime paymenttime = DateTime(2024, j, day, random.nextInt(24) , random.nextInt(60), random.nextInt(60));
          orderList.add(Order(
            branch_branchcode: random.nextInt(3)+1, 
            customer_id: nameList[random.nextInt(7)], 
            shoes_seq: random.nextInt(6)+1, 
            order_seq: 1, 
            quantity: random.nextInt(10)+1,
            paymenttime: paymenttime,
            pickuptime : (((j == 8 && pickupCancle>7) || pickupCancle>8) ? null : paymenttime.add(const Duration(days: 1))),
            canceltime : (pickupCancle >8)? paymenttime.add(const Duration(days: 1)) : null
          )
        );
      }
  }

    return orderList;
  }

  Future<Uint8List> loadAssetAsBinary(String assetPath) async {
    // assetPath는 Asset 이미지의 경로 예: 'assets/images/sample.png'
    ByteData byteData = await rootBundle.load(assetPath); // 이미지 로드
    Uint8List imageBytes =
        byteData.buffer.asUint8List(); // ByteData를 Uint8List로 변환
    return imageBytes;
  }




}
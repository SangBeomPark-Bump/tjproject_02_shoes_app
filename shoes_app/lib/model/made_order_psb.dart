import 'package:shoes_app/model/order.dart';
import 'dart:math';

class MadeOrderPsb{
  Random random = Random();
  
  function(){

    List<String> nameList = ['yubee','gwanwoo','jangbee','yeopho','choseon','heonje']; 
    List<DateTime>paymenttime = [
      
      DateTime(2024, 7, random.nextInt(30)+1, random.nextInt(24) , random.nextInt(60), random.nextInt(60))
    ];


    List<Order> orderList = [   ];
    for (int i = 0; i<10; i++){
      DateTime paymenttime = DateTime(2024, 8, random.nextInt(30)+1, random.nextInt(24) , random.nextInt(60), random.nextInt(60));
      orderList.add(Order(
        branch_branchcode: random.nextInt(3)+1, 
        customer_id: nameList[random.nextInt(6)], 
        shoes_seq: random.nextInt(6)+1, 
        order_seq: 1, 
        quantity: random.nextInt(10)+1,
        paymenttime: paymenttime,
      )
      );
      print(orderList[i].paymenttime);
    }

    for (int i = 0; i<10; i++){
      DateTime paymenttime = DateTime(2024, 7, random.nextInt(30)+1, random.nextInt(24) , random.nextInt(60), random.nextInt(60));
      orderList.add(Order(
        branch_branchcode: random.nextInt(3)+1, 
        customer_id: nameList[random.nextInt(6)], 
        shoes_seq: random.nextInt(6)+1, 
        order_seq: 1, 
        quantity: random.nextInt(10)+1,
        paymenttime: paymenttime,
      )
      );
    }

    for (int i = 0; i<10; i++){
      DateTime paymenttime = DateTime(2024, 8, random.nextInt(30)+1, random.nextInt(24) , random.nextInt(60), random.nextInt(60));
      orderList.add(Order(
        branch_branchcode: random.nextInt(3)+1, 
        customer_id: nameList[random.nextInt(6)], 
        shoes_seq: random.nextInt(6)+1, 
        order_seq: 1, 
        quantity: random.nextInt(10)+1,
        paymenttime: paymenttime,
        pickuptime: paymenttime.add(const Duration(days : 1)),
      )
      );
    }

    for (int i = 0; i<10; i++){
      DateTime paymenttime = DateTime(2024, 7, random.nextInt(30)+1, random.nextInt(24) , random.nextInt(60), random.nextInt(60));
      orderList.add(Order(
        branch_branchcode: random.nextInt(3)+1, 
        customer_id: nameList[random.nextInt(6)], 
        shoes_seq: random.nextInt(6)+1, 
        order_seq: 1, 
        quantity: random.nextInt(10)+1,
        paymenttime: paymenttime,
        pickuptime: paymenttime.add(const Duration(days : 1)),
      )
      );
    }

    return orderList;
  }
}
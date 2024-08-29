import 'package:shoes_app/model/order.dart';
import 'dart:math';

class MadeOrderPsb{
  Random random = Random();
  
  function(){

    List<String> nameList = ['yubee','gwanwoo','jangbee','yeopho','choseon','heonje']; 


    List<Order> orderList = [   ];
    for (int i = 0; i<10; i++){
      orderList.add(Order(
        seq: 'AA00$i' , 
        branch_branchcode: random.nextInt(3)+1, 
        customer_id: nameList[random.nextInt(6)], 
        shoes_seq: random.nextInt(6)+1, 
        order_seq: 1, 
        quantity: random.nextInt(10)+1,
        paymenttime: DateTime(2024, 8, random.nextInt(30)+1, random.nextInt(24) , random.nextInt(60), random.nextInt(60)),
      )
      );
      print(orderList[i].paymenttime);
    }

    for (int i = 0; i<10; i++){
      orderList.add(Order(
        seq: 'AB00$i' , 
        branch_branchcode: random.nextInt(3)+1, 
        customer_id: nameList[random.nextInt(6)], 
        shoes_seq: random.nextInt(6)+1, 
        order_seq: 1, 
        quantity: random.nextInt(10)+1,
        paymenttime: DateTime(2024, 7, random.nextInt(30)+1, random.nextInt(24) , random.nextInt(60), random.nextInt(60)),
      )
      );
    }

    for (int i = 0; i<10; i++){
      orderList.add(Order(
        seq: 'AD00$i' , 
        branch_branchcode: random.nextInt(3)+1, 
        customer_id: nameList[random.nextInt(6)], 
        shoes_seq: random.nextInt(6)+1, 
        order_seq: 1, 
        quantity: random.nextInt(10)+1,
        paymenttime: DateTime(2024, 6, random.nextInt(30)+1, random.nextInt(24) , random.nextInt(60), random.nextInt(60)),
      )
      );
    }

    for (int i = 0; i<10; i++){
      orderList.add(Order(
        seq: 'AC00$i' , 
        branch_branchcode: random.nextInt(3)+1, 
        customer_id: nameList[random.nextInt(6)], 
        shoes_seq: random.nextInt(6)+1, 
        order_seq: 1, 
        quantity: random.nextInt(10)+1,
        paymenttime: DateTime(2024, 5, random.nextInt(30)+1, random.nextInt(24) , random.nextInt(60), random.nextInt(60)),
      )
      );
    }

    return orderList;
  }
}
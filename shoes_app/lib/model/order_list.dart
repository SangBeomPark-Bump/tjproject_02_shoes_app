import 'dart:typed_data';

//구매목록 리스트를 위한 class

class OrderList {
  //Properties
  Uint8List image;
  int totalPrice;
  String shoesName;
  String seq;
  String branchName;
  int quantity;
  DateTime paymenttime;
  DateTime? canceltime;
  DateTime? pickuptime;

  OrderList({
    required this.image,
    required this.totalPrice,
    required this.shoesName,
    required this.seq,
    required this.branchName,
    required this.quantity,
    required this.paymenttime,
    this.canceltime,
    this.pickuptime,
  });

  OrderList.fromMap(Map<String, dynamic> res)
      : image = res['image'] ?? Uint8List(1),
        totalPrice = (res['totalPrice'] ?? 1),
        shoesName = res['shoesname'] ?? "",
        seq = res['seq'] ?? "",
        branchName = res['branchname'] ?? "",
        quantity = res['quantity'] ?? 1,
        paymenttime =
            DateTime.parse(res['paymenttime']), // 데이터베이스 값을 datetime으로 바꿔줌
        canceltime = res['canceltime'] == 'null'
            ? null
            : DateTime.parse(res['canceltime']),
        pickuptime = res['pickuptime'] == 'null'
            ? null
            : DateTime.parse(res['pickuptime']);
}

import 'dart:typed_data';

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
      : image = res['image'] == null ? Uint8List(1) : res['image'],
        totalPrice = (res['totalPrice'] ?? 1),
        shoesName = res['shoesname'] ?? "",
        seq = res['seq'] ?? "",
        branchName = res['branchname'] ?? "",
        quantity = res['quantity'] ?? 1,
        paymenttime = DateTime.parse(res['paymenttime']),
        canceltime = res['canceltime'] == 'null'
            ? null
            : DateTime.parse(res['canceltime']),
        pickuptime = res['pickuptime'] == 'null'
            ? null
            : DateTime.parse(res['pickuptime']);
}

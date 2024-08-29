class Order{
  //Properties
  String seq;
  int branch_branchcode;
  String customer_id;
  int shoes_seq;
  int order_seq;
  int quantity;
  DateTime? paymenttime;
  DateTime? canceltime;
  DateTime? pickuptime;

  Order({
    required this.seq,
    required this.branch_branchcode,
    required this.customer_id,
    required this.shoes_seq,
    required this.order_seq,
    required this.quantity,
    this.paymenttime,
    this.canceltime,
    this.pickuptime,
  });

  Order.fromMap(Map<String, dynamic> res)
  : seq = res['seq'],
  branch_branchcode = res['branch_branchcode'],
  customer_id = res['customer_id'],
  shoes_seq = res['shoes_seq'],
  order_seq = res['order_seq'],
  quantity = res['quantity'],
  paymenttime = res['paymenttime'],
  canceltime = res['canceltime'],
  pickuptime = res['pickuptime'];
  
}
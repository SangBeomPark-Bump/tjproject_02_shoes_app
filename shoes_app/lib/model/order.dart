import 'dart:ffi';
import 'dart:math';
class Order{
  
  
  //Properties
  Random random = Random();
  String? seq;
  int branch_branchcode;
  String customer_id;
  int shoes_seq;
  int order_seq;
  int quantity;
  DateTime paymenttime;
  DateTime? canceltime;
  DateTime? pickuptime;

  Order({
    required this.branch_branchcode,
    required this.customer_id,
    required this.shoes_seq,
    required this.order_seq,
    required this.quantity,
    required this.paymenttime,
    this.canceltime,
    this.pickuptime,
  });
  
  seqMaker(){
    String seqYear = paymenttime.year.toRadixString(16).padLeft(3, '0');
    String seqDayMonth = (paymenttime.month+paymenttime.day * 932).toRadixString(16).padLeft(4, '0');
    String seqHourMinute = (paymenttime.hour+paymenttime.minute * 289).toRadixString(16).padLeft(4, '0');
    String seqSec = (paymenttime.second * 37).toRadixString(16).padLeft(3, '0');
    String seqMili = (paymenttime.millisecond * 65).toRadixString(16).padLeft(4, '0');
    String seqMicro = (paymenttime.microsecond * 63).toRadixString(16).padLeft(4, '0');
    seq = seqYear + seqDayMonth + seqHourMinute + customer_id[0]+ customer_id[1]; seqSec + seqMili + seqMicro + order_seq.toString();
  }

  Order.fromMap(Map<String, dynamic> res)
  : seq = res['seq'],
  branch_branchcode = res['branch_branchcode'],
  customer_id = res['customer_id'],
  shoes_seq = res['shoes_seq'],
  order_seq = res['order_seq'],
  quantity = res['quantity'],
  paymenttime = DateTime.parse(res['paymenttime']),
  canceltime = res['canceltime'] == null ? DateTime.parse(res['canceltime']) : null ,
  pickuptime = res['pickuptime'] == null ? DateTime.parse(res['pickuptime']) : null ;  
}
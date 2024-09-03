import 'dart:typed_data';

//키오스크에서 가져올떄 쓸 모델
class Kiosk{


  String seq;
  String customer_id;
  DateTime? pickuptime;
  Uint8List? image;
  int branchcode;

  Kiosk({
    required this.seq,
    required this.customer_id,
    this.pickuptime,
    this.image,
    required this.branchcode
  });
}
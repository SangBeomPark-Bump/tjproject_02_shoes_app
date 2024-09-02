import 'dart:typed_data';

class Kiosk{


  String seq;
  String customer_id;
  DateTime? pickuptime;
  Uint8List? image;

  Kiosk({
    required this.seq,
    required this.customer_id,
    this.pickuptime,
    this.image,
  });
}
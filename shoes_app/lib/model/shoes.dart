import 'dart:typed_data';

class Shoes{
  int? seq;
  String shoesname;
  int price;
  final Uint8List image;
  int size;
  String brand;

  Shoes({
    required this.shoesname,
    required this.price,
    required this.image,
    required this.size,
    required this.brand,
  });

  Shoes.fromMap(Map<String, dynamic> res)
  : seq = res['seq'],
  shoesname = res['shoesname'],
  price = res['price'],
  size = res['size'],
  image = res['image'],
  brand = res['brand'];
  
  
}
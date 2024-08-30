class Customer{
  String id; // 그냥 'id'
  String password; //비밀번호
  String name; //이름
  String phone; //전화번호
  String email; // 이메일
  String rnumber; // 주민번호

  Customer({
    required this.id, 
    required this.password,
    required this.name,
    required this.phone,
    required this.email,
    required this.rnumber,
  });


  Customer.fromMap(Map<String, dynamic> res)
:id = res['id'],
  password = res['password'],
  name = res['name'],
  phone = res['phone'],
  email = res['email'],
  rnumber = res['rnumber'];

}
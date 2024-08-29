class Customer{
  String id;
  String password;
  String name;
  String phone;
  String email;
  String rnumber;

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
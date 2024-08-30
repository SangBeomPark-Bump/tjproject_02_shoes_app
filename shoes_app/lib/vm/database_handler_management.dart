import 'dart:typed_data';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// Branch 클래스
class Branch {
  int? branchcode;
  String? branchname;

  Branch({this.branchcode, this.branchname});

  Map<String, dynamic> toMap() {
    return {
      'branchcode': branchcode,
      'branchname': branchname,
    };
  }

  factory Branch.fromMap(Map<String, dynamic> map) {
    return Branch(
      branchcode: map['branchcode'],
      branchname: map['branchname'],
    );
  }
}

// Customer 클래스
class Customer {
  String? id;
  String? password;
  String? name;
  String? phone;
  String? email;
  String? rnumber;

  Customer({this.id, this.password, this.name, this.phone, this.email, this.rnumber});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'password': password,
      'name': name,
      'phone': phone,
      'email': email,
      'rnumber': rnumber,
    };
  }

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      id: map['id'],
      password: map['password'],
      name: map['name'],
      phone: map['phone'],
      email: map['email'],
      rnumber: map['rnumber'],
    );
  }
}

// Order 클래스
class Order {
  String? seq;
  int? branch_branchcode;
  String? customer_id;
  int? shoes_seq;
  int? order_seq;
  int? quantity;
  String? paymenttime;
  String? canceltime;
  String? pickuptime;

  Order({
    this.seq,
    this.branch_branchcode,
    this.customer_id,
    this.shoes_seq,
    this.order_seq,
    this.quantity,
    this.paymenttime,
    this.canceltime,
    this.pickuptime,
  });

  Map<String, dynamic> toMap() {
    return {
      'seq': seq,
      'branch_branchcode': branch_branchcode,
      'customer_id': customer_id,
      'shoes_seq': shoes_seq,
      'order_seq': order_seq,
      'quantity': quantity,
      'paymenttime': paymenttime,
      'canceltime': canceltime,
      'pickuptime': pickuptime,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      seq: map['seq'],
      branch_branchcode: map['branch_branchcode'],
      customer_id: map['customer_id'],
      shoes_seq: map['shoes_seq'],
      order_seq: map['order_seq'],
      quantity: map['quantity'],
      paymenttime: map['paymenttime'],
      canceltime: map['canceltime'],
      pickuptime: map['pickuptime'],
    );
  }
}

// Shoes 클래스
class Shoes {
  int? seq;
  String? shoesname;
  int? price;
  Uint8List? image;
  int? size;
  String? brand;

  Shoes({this.seq, this.shoesname, this.price, this.image, this.size, this.brand});

  Map<String, dynamic> toMap() {
    return {
      'seq': seq,
      'shoesname': shoesname,
      'price': price,
      'image': image,
      'size': size,
      'brand': brand,
    };
  }

  factory Shoes.fromMap(Map<String, dynamic> map) {
    return Shoes(
      seq: map['seq'],
      shoesname: map['shoesname'],
      price: map['price'],
      image: map['image'],
      size: map['size'],
      brand: map['brand'],
    );
  }
}

// DatabaseHandler 클래스
class DatabaseHandler {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'shoesmarket.db'),
      onCreate: (db, version) async {
        await db.execute("""
          CREATE TABLE customer (
            id text PRIMARY KEY,
            password text,
            name text,
            phone text,
            email text,
            rnumber text
          );
        """);

        await db.execute("""
          CREATE TABLE ordered (
            seq text PRIMARY KEY,
            branch_branchcode integer,
            customer_id text,
            shoes_seq integer,
            order_seq integer,
            quantity integer,
            paymenttime text,
            canceltime text,
            pickuptime text
          );
        """);

        await db.execute("""
          CREATE TABLE branch (
            branchcode integer PRIMARY KEY autoincrement,
            branchname text
          );
        """);

        await db.execute("""
          CREATE TABLE shoes (
            seq integer PRIMARY KEY autoincrement,
            shoesname text,
            price integer,
            image blob,
            size integer,
            brand text
          );
        """);
      },
      version: 1,
    );
  }

  // Branch 관련 메서드들
  Future<int> insertBranch(Branch branch) async {
    final Database db = await initializeDB();
    return await db.insert('branch', branch.toMap());
  }

  Future<List<Branch>> queryBranch() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('branch');
    return queryResult.map((e) => Branch.fromMap(e)).toList();
  }

  Future<String?> getBranchName(int branchCode) async {
    final db = await initializeDB();
    final List<Map<String, dynamic>> result = await db.query(
      'branch',
      where: 'branchcode = ?',
      whereArgs: [branchCode],
    );
    if (result.isNotEmpty) {
      return result.first['branchname'] as String?;
    }
    return null;
  }

  Future<int> updateBranch(Branch branch) async {
    final Database db = await initializeDB();
    return await db.update(
      'branch',
      branch.toMap(),
      where: 'branchcode = ?',
      whereArgs: [branch.branchcode],
    );
  }

  // Customer 관련 메서드들
  Future<int> insertCustomer(Customer customer) async {
    final Database db = await initializeDB();
    return await db.insert('customer', customer.toMap());
  }

  Future<List<Customer>> queryCustomer() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('customer');
    return queryResult.map((e) => Customer.fromMap(e)).toList();
  }

  Future<int?> getCustomerAge(String customerId) async {
    final db = await initializeDB();
    final List<Map<String, dynamic>> result = await db.query(
      'customer',
      where: 'id = ?',
      whereArgs: [customerId],
    );
    if (result.isNotEmpty) {
      String rnumber = result.first['rnumber'];
      int birthYear = int.parse(rnumber.substring(0, 2));
      int currentYear = DateTime.now().year;
      if (birthYear > currentYear % 100) {
        birthYear += 1900; // 1900년대 생
      } else {
        birthYear += 2000; // 2000년대 생
      }
      return currentYear - birthYear;
    }
    return null;
  }

  Future<int> updateCustomer(Customer customer) async {
    final Database db = await initializeDB();
    return await db.update(
      'customer',
      customer.toMap(),
      where: 'id = ?',
      whereArgs: [customer.id],
    );
  }

  // Order 관련 메서드들
  Future<int> insertOrder(Order order) async {
    final Database db = await initializeDB();
    return await db.insert('ordered', order.toMap());
  }

  Future<List<Order>> queryOrder() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('ordered');
    return queryResult.map((e) => Order.fromMap(e)).toList();
  }

  Future<int> updateOrder(Order order) async {
    final Database db = await initializeDB();
    return await db.update(
      'ordered',
      order.toMap(),
      where: 'seq = ?',
      whereArgs: [order.seq],
    );
  }

  // Shoes 관련 메서드들
  Future<int> insertShoe(Shoes shoes) async {
    final Database db = await initializeDB();
    return await db.insert('shoes', shoes.toMap());
  }

  Future<List<Shoes>> queryShoes() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('shoes');
    return queryResult.map((e) => Shoes.fromMap(e)).toList();
  }

  Future<double?> getShoePrice(int shoesSeq) async {
    final db = await initializeDB();
    final List<Map<String, dynamic>> result = await db.query(
      'shoes',
      where: 'seq = ?',
      whereArgs: [shoesSeq],
    );
    if (result.isNotEmpty) {
      return result.first['price'] as double?;
    }
    return null;
  }

  Future<String?> getShoeName(int shoesSeq) async {
    final db = await initializeDB();
    final List<Map<String, dynamic>> result = await db.query(
      'shoes',
      where: 'seq = ?',
      whereArgs: [shoesSeq],
    );
    if (result.isNotEmpty) {
      return result.first['shoesname'] as String?;
    }
    return null;
  }

  Future<int> updateShoe(Shoes shoe) async {
    final Database db = await initializeDB();
    return await db.update(
      'shoes',
      shoe.toMap(),
      where: 'seq = ?',
      whereArgs: [shoe.seq],
    );
  }
}

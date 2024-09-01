import 'package:path/path.dart';
import 'package:shoes_app/model/branch.dart';
import 'package:shoes_app/model/customer.dart';
import 'package:shoes_app/model/order.dart';
import 'package:shoes_app/model/shoes.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHandler{



    Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'shoesmarket.db'),
      onCreate: (db, version) async {
        // customer table
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

        // order table
        await db.execute("""
          CREATE TABLE ordered (
            seq text PRIMARY KEY ,
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
        // branch table
        await db.execute("""
          CREATE TABLE branch (
            branchcode integer PRIMARY KEY autoincrement,
            branchname text
          );
        """);
        // shoes
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

//customer
  Future<int> insertCustomer(Customer customer)async{
    int result = 0;
    final Database db = await initializeDB();
    result = await db.rawInsert(
      """
        insert into customer(id, password, name, phone, email,rnumber)
        values (?,?,?,?,?,?)
      """,
      [
        customer.id, 
        customer.password, 
        customer.name, 
        customer.phone, 
        customer.email,
        customer.rnumber
      ]);
    return result;
  }


// Insert
// Order
Future<int> insertOrder(Order order) async {
  int result = 0;
  final Database db = await initializeDB();
  result = await db.rawInsert(
    """
      INSERT INTO ordered(seq, branch_branchcode, customer_id, shoes_seq, order_seq, quantity, paymenttime, canceltime, pickuptime)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
    """,
    [
      order.seq,
      order.branch_branchcode,
      order.customer_id,
      order.shoes_seq,
      order.order_seq,
      order.quantity,
      order.paymenttime.toString(),
      order.canceltime.toString(),
      order.pickuptime.toString()
    ],
  );
  return result;
}

// Branch
Future<int> insertBranch(Branch branch) async {
  int result = 0;
  final Database db = await initializeDB();
  result = await db.rawInsert(
    """
      INSERT INTO branch(branchname)
      VALUES (?)
    """,
    [
      branch.branchname,
    ],
  );
  return result;
}

// Shoes
Future<int> insertShoe(Shoes shoes) async {
  int result = 0;
  final Database db = await initializeDB();
  result = await db.rawInsert(
    """
      INSERT INTO shoes(shoesname, price, image, size, brand)
      VALUES (?, ?, ?, ?, ?)
    """,
    [
      shoes.shoesname,
      shoes.price,
      shoes.image,
      shoes.size,
      shoes.brand,
    ],
  );
  return result;
}

//query
Future<List<Customer>> queryCustomer() async {
  final Database db = await initializeDB();
  final List<Map<String, Object?>> queryResult = await db.rawQuery(
    'SELECT * FROM customer',
  );
  return queryResult.map((e) => Customer.fromMap(e)).toList();
}

Future<List<Order>> queryOrder() async {
  final Database db = await initializeDB();
  final List<Map<String, Object?>> queryResult = await db.rawQuery(
    'SELECT * FROM ordered',
  );
  print(queryResult[21]['pickuptime']);
  List<Order> resultorder = queryResult.map((e) => Order.fromMap(e)).toList();
  print(resultorder[21].pickuptime);
  return resultorder;
}

Future<List<Branch>> queryBranch() async {
  final Database db = await initializeDB();
  final List<Map<String, Object?>> queryResult = await db.rawQuery(
    'SELECT * FROM branch',
  );
  return queryResult.map((e) => Branch.fromMap(e)).toList();
}

Future<List<Shoes>> queryShoes() async {
  final Database db = await initializeDB();
  final List<Map<String, Object?>> queryResult = await db.rawQuery(
    'SELECT * FROM shoes',
  );
  return queryResult.map((e) => Shoes.fromMap(e)).toList();
}

//customer
Future<int> updateCustomer(Customer customer) async {
  int result = 0;
  final Database db = await initializeDB();
  result = await db.rawUpdate(
    """
      UPDATE customer
      SET password = ?, name = ?, phone = ?, email = ?, rnumber = ?
      WHERE id = ?
    """,
    [
      customer.password,
      customer.name,
      customer.phone,
      customer.email,
      customer.rnumber,
      customer.id
    ],
  );
  return result;
}

Future<int> updateOrder(Order order) async {
  int result = 0;
  final Database db = await initializeDB();
  result = await db.rawUpdate(
    """
      UPDATE ordered
      SET branch_branchcode = ?, customer_id = ?, shoes_seq = ?, order_seq = ?, quantity = ?, paymenttime = ?, canceltime = ?, pickuptime = ?
      WHERE seq = ?
    """,
    [
      order.branch_branchcode,
      order.customer_id,
      order.shoes_seq,
      order.order_seq,
      order.quantity,
      order.paymenttime.toString(),
      order.canceltime.toString(),
      order.pickuptime.toString(),
      order.seq
    ],
  );
  return result;
}

Future<int> updateBranch(Branch branch) async {
  int result = 0;
  final Database db = await initializeDB();
  result = await db.rawUpdate(
    """
      UPDATE branch
      SET branchname = ?
      WHERE branchcode = ?
    """,
    [
      branch.branchname,
      branch.branchcode
    ],
  );
  return result;
}

Future<int> updateShoe(Shoes shoe) async {
  int result = 0;
  final Database db = await initializeDB();
  result = await db.rawUpdate(
    """
      UPDATE shoes
      SET shoesname = ?, price = ?, image = ?, size = ?, brand = ?
      WHERE seq = ?
    """,
    [
      shoe.shoesname,
      shoe.price,
      shoe.image,
      shoe.size,
      shoe.brand,
      shoe.seq
    ],
  );
  return result;
}

removeAll()async{
  final Database db = await initializeDB();
    final int order_queryResult = await db.rawDelete(
    """
        DELETE 
        FROM ordered
    """
  );
}



}
import 'package:path/path.dart';
import 'package:shoes_app/model/branch.dart';
import 'package:shoes_app/model/order.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseCarthandler{
    

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

Future<List<Branch>> queryBranch() async {
  final Database db = await initializeDB();
  final List<Map<String, Object?>> queryResult = await db.rawQuery(
    'SELECT  FROM branch',
  );
  return queryResult.map((e) => Branch.fromMap(e)).toList();
}


}
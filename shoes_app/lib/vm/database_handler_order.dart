import 'package:path/path.dart';
import 'package:shoes_app/model/order_list.dart';
import 'package:shoes_app/model/shoes.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHandlerOrder {
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

  Future<List<OrderList>> queryOrderList() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.rawQuery(
      """
SELECT s.image as image, s.price*o.quantity as totalPrice, s.shoesname, o.seq, b.branchname, o.quantity, o.paymenttime, o.canceltime, o.pickuptime
from shoes s, ordered o, customer c, branch b
where c.id = o.customer_id AND s.seq= o.shoes_seq AND b.branchcode = o.branch_branchcode
          """,
    );

    for (int i = 0; i < queryResult.length; i++) {
      print(queryResult[i]);
    }

    return queryResult.map((e) => OrderList.fromMap(e)).toList();
  }

  Future<List<OrderList>> queryUser(id) async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.rawQuery("""
SELECT s.image as image, s.price*o.quantity as totalPrice, s.shoesname, o.seq, b.branchname, o.quantity, o.paymenttime, o.canceltime, o.pickuptime
from shoes s, ordered o, customer c, branch b
where c.id = ? and c.id = o.customer_id AND s.seq= o.shoes_seq AND b.branchcode = o.branch_branchcode
          """, [id]);

    for (int i = 0; i < queryResult.length; i++) {
      print(queryResult[0]["totalPrice"]);
      print(queryResult[0]["shoesname"]);
      print(queryResult[0]["seq"]);
      print(queryResult[0]["branchname"]);
      print(queryResult[0]["quantity"]);
      print(queryResult[0]["paymenttime"]);
      print(queryResult[0]["canceltime"]);
      print(queryResult[0]["pickuptime"]);
    }

    return queryResult.map((e) => OrderList.fromMap(e)).toList();
  }

  Future<List<Shoes>> queryShoesByQuery(String query) async {
    final db = await initializeDB(); // 데이터베이스 연결
    final result = await db.rawQuery(
      """
      select *
      from shoes
      where
      shoesname like ? 
      or size like ? 
      """,
      ['%$query%', '%$query%'],
    );
    return result.map((e) => Shoes.fromMap(e)).toList(); // 데이터 변환
  }

  Future<List<Shoes>> queryNike() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult =
        await db.rawQuery('SELECT * FROM shoes where brand = ?', ['NIKE']);
    return queryResult.map((e) => Shoes.fromMap(e)).toList();
  }

  Future<List<Shoes>> queryNewB() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db
        .rawQuery('SELECT * FROM shoes where brand = ?', ['newBalance']);
    return queryResult.map((e) => Shoes.fromMap(e)).toList();
  }

  Future<List<Shoes>> queryPro() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult =
        await db.rawQuery('SELECT * FROM shoes where brand = ?', ['prosPecs']);
    return queryResult.map((e) => Shoes.fromMap(e)).toList();
  }

  Future<void> cancelShoe(String cancelTime, String seq) async {
    print(cancelTime);
    final Database db = await initializeDB();
    await db.rawUpdate(
      """
      update ordered
      set canceltime = ?
      WHERE seq = ?
    """,
      [cancelTime, seq],
    );
  }
}

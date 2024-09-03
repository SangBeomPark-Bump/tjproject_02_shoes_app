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

  Future<List<OrderList>> queryUser(String id) async {
    // 유저별 구매내역 쿼리
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.rawQuery("""
SELECT s.image as image, s.price*o.quantity as totalPrice, s.shoesname, o.seq, b.branchname, o.quantity, o.paymenttime, o.canceltime, o.pickuptime
from shoes s, ordered o, customer c, branch b
where c.id = ? and c.id = o.customer_id AND s.seq= o.shoes_seq AND b.branchcode = o.branch_branchcode
          """, [id]);

    for (int i = 0; i < queryResult.length; i++) {
      //print(queryResult[0]["totalPrice"]);
    }

    return queryResult.map((e) => OrderList.fromMap(e)).toList();
  }

  Future<List<Shoes>> queryShoesByQuery(String query) async {
    // app home 화면에서 검색 쿼리
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

  Future<List<OrderList>> queryOrderByQuery(String id, String date) async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.rawQuery("""
select s.image as image, s.price*o.quantity as totalPrice, s.shoesname, o.seq, b.branchname, o.quantity, o.paymenttime, o.canceltime, o.pickuptime
from shoes s, ordered o, customer c, branch b
where strftime('%Y-%m', o.paymenttime) like ? and c.id = ? and c.id = o.customer_id and s.seq= o.shoes_seq and b.branchcode = o.branch_branchcode
        """, [date, id]);
    for (int i = 0; i < queryResult.length; i++) {
      //print(queryResult[0]);
    }
    return queryResult.map((e) => OrderList.fromMap(e)).toList();
  }

  Future<List<Shoes>> queryNike() async {
    //app home 화면에서 nike 신발 목록 쿼리
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult =
        await db.rawQuery('SELECT * FROM shoes where brand = ?', ['NIKE']);
    return queryResult.map((e) => Shoes.fromMap(e)).toList();
  }

  Future<List<Shoes>> queryNewB() async {
    //app home 화면에서 newB 신발 목록 쿼리
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db
        .rawQuery('SELECT * FROM shoes where brand = ?', ['newBalance']);
    return queryResult.map((e) => Shoes.fromMap(e)).toList();
  }

  Future<List<Shoes>> queryPro() async {
    //app home 화면에서 Pro 신발 목록 쿼리
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult =
        await db.rawQuery('SELECT * FROM shoes where brand = ?', ['prosPecs']);
    return queryResult.map((e) => Shoes.fromMap(e)).toList();
  }

  Future<void> cancelShoe(String cancelTime, String seq) async {
    //구매내역에서 취소 시 쿼리
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

  Future<List<String>> loadAvailableMonth() async {
    final Database db = await initializeDB();

    List<Map<String, dynamic>> rawData = await db.rawQuery(
      '''
        SELECT substr(o.paymenttime, 0, 7) as ym
        FROM ordered o
        where ym != 'null'
        GROUP BY ym
      ''',
    );
    List<String> availableMonths = [];
    for (Map i in rawData) {
      availableMonths.add(i['ym']);
    }
    return availableMonths;
  }
}

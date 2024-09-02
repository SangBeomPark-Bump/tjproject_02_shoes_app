import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHandler_Product{



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

    Future<List<List<dynamic>>> queryTotalPriceByMonth(String brand) async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.rawQuery(
      """
          SELECT 
              s.brand,
              strftime('%Y-%m', o.pickuptime) AS orderMonth,
              SUM(s.price * o.quantity) AS totalPriceQuantity
          FROM 
              'ordered' o
          JOIN 
              shoes s ON o.shoes_seq = s.seq
          WHERE 
              orderMonth IS NOT NULL
              AND o.pickuptime IS NOT 'null'
              AND o.canceltime IS 'null'
              AND s.brand = ?
          GROUP BY 
              orderMonth
          ORDER BY 
              orderMonth
      """
    ,[brand]
    );
    

    // 결과를 List<List<dynamic>> 형식으로 변환
    List<List<dynamic>> result = queryResult.map((row) {
      // orderMonth를 DateTime으로 변환
      String orderMonth = row['orderMonth'] as String;
      DateTime dateTime = DateTime.parse(orderMonth + "-01"); // 월을 1일로 설정

      // totalPriceQuantity를 int로 변환
      int totalPriceQuantity = row['totalPriceQuantity'] as int;

      return [dateTime, totalPriceQuantity];
    }).toList();

    return result;
  }


//query
Future<List<String>> queryProductkeys() async {
  final Database db = await initializeDB();
  final List<Map<String, Object?>> queryResult = await db.rawQuery(
    """
        SELECT DISTINCT(brand) as brands
        FROM shoes
        group by brands
    """,
  );
  print(queryResult);
  return queryResult.map((brand) => brand['brands'] as String ).toList();
  //return queryResult.map((Dae) => Customer.fromMap(e)).toList();
}




}



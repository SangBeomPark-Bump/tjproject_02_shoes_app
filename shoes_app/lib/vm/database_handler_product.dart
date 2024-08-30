import 'package:path/path.dart';
import 'package:shoes_app/model/branch.dart';
import 'package:shoes_app/model/customer.dart';
import 'package:shoes_app/model/order.dart';
import 'package:shoes_app/model/shoes.dart';
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


//query
Future<List?> queryProductChart() async {
  final Database db = await initializeDB();
  final List<Map<String, Object?>> queryResult = await db.rawQuery(
    """
        SELECT count(o.seq) strftime(%Y-%m, paymentdate) as orderMonth ,
        FROM 
            'order' o
        JOIN 
            shoes s ON o.shoes_seq = s.seq
        group by orderMonth
        order by orderMonth
    """,
  );
  print(queryResult);
  //return queryResult.map((Dae) => Customer.fromMap(e)).toList();
}


}
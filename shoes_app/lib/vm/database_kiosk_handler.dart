import 'package:path/path.dart';
import 'package:shoes_app/model/kiosk.dart';
import 'package:shoes_app/model/order.dart';
import 'package:shoes_app/vm/database_handler_management.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseKioskHandler{

  //db생성
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


//kiosk 회원가입 여부 확인
//Customer table query
Future<int> kioskqueryCustomer(Customer customer) async {
  final Database db = await initializeDB();
  final List<Map<String, Object?>> queryResult = await db.rawQuery(
    'SELECT count(*) hasID FROM customer where id = ? and password = ?', [customer.id , customer.password]
  );
  final int result = queryResult.isNotEmpty ? queryResult.first['hasID'] as int : 0;
  return result;
} 


//kiosk id,주문번호  확인
//Ordered table query
Future<List<Map<String,dynamic>>> kioskqueryOrder(Kiosk kiosk)async{
  final Database db = await initializeDB();
  final List<Map<String ,Object?>> queryResult = await db.rawQuery(
    '''
    select o.seq ,o.shoes_seq, o.quantity, s.shoesname, s.image, o.order_seq
    from ordered as o
    join shoes as s on o.shoes_seq = s.seq
    where o.seq like ? and o.customer_id = ? and o.pickuptime is 'null'
    ''', ['${kiosk.seq}%', kiosk.customer_id]
  );
    // print(queryResult);
    // print(queryResult.first['image']);
    
    return queryResult.isEmpty ? [] : queryResult;
}

//kiosk 수령시 PickupTime update
Future<int> updateOrder(Kiosk kiosk) async {
  int result = 0;
  final Database db = await initializeDB();
  result = await db.rawUpdate(
    """
      UPDATE ordered
      SET pickuptime = ?
      WHERE seq like ? and customer_id = ? 
    """,
    [ kiosk.pickuptime.toString(),
      "${kiosk.seq}%",
      kiosk.customer_id
    ],

  );
  return result;
}




}
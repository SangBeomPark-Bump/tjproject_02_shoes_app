import 'package:path/path.dart';

import 'package:shoes_app/model/customer.dart';

import 'package:sqflite/sqflite.dart';

class DatabaseSignUpHandler{



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




//query
Future<int> idCustomer(String id) async {
  final Database db = await initializeDB();
  final List<Map<String, Object?>> queryResult = await db.rawQuery(
    'SELECT count(id) as count FROM customer WHERE id = ?',
    [id]
  );
    if (queryResult.isNotEmpty) {
      return queryResult[0]['count'] as int ;
    // return queryResult.first['count'] as int;
  } else {
    return 0;
  }
}

Future<int> idPasswordCustomer(String id, String password) async {
  final Database db = await initializeDB();
  final List<Map<String, Object?>> queryResult = await db.rawQuery(
    'SELECT count(id) as count FROM customer WHERE id = ? and password = ?' ,
    [id, password]
  );
    if (queryResult.isNotEmpty) {
      return queryResult[0]['count'] as int ;
    // return queryResult.first['count'] as int;
  } else {
    return 0;
  }
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



}
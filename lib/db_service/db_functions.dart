import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DB {
  Future<Database> dbInit() async {
    String path = await getDatabasesPath();

    return openDatabase(
      join(path, 'save.db'),
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE cartitems(id INTEGER PRIMARY KEY, product_id TEXT,qantity INTEGER, shop_id TEXT)',
        );
      },
      version: 2,
    );
  }

  Future insertdata(String shopId, String productID, int qty, int min, int max,
      bool isBulk) async {
    int newQty;
    var db = await dbInit();
    var copy = await db
        .rawQuery("SELECT * FROM cartitems WHERE product_id= '$productID'");

    if (copy.isEmpty) {
      var value = {'product_id': productID, 'qantity': qty, 'shop_id': shopId};
      // var result = 
      await db.insert(
        'cartitems',
        value,
      );
      // var data = 
      await db.rawQuery("SELECT * FROM cartitems");
    } else {
      var previousQty = copy[0]["qantity"];
      if (isBulk) {
        newQty = qty;
      } else {
        newQty = int.parse(previousQty.toString()) + qty;
      }
      if (newQty < min) {
        newQty = min;
      } else if (newQty > max) {
        newQty = max;
      }
      await db.rawQuery(
          "UPDATE cartitems SET qantity= $newQty WHERE product_id= '$productID'");
      // var data = 
      await db.rawQuery("SELECT * FROM cartitems");
    }
  }

  Future getProductId() async {
    var db = await dbInit();
    var name = await db.rawQuery(
        'SELECT product_id,qantity FROM cartitems ORDER BY product_id');
    return name;
  }

  Future getdata() async {
    var db = await dbInit();
    var name = await db.rawQuery('SELECT * FROM cartitems');
    return name;
  }

  Future updateQuantity(int updatedQty, String productId) async {
    var db = await dbInit();
    //  var update = await db.raw
    var update = await db.rawQuery(
        "UPDATE cartitems SET qantity ='$updatedQty' WHERE product_id='$productId'");
    // var update = await db.rawQuery(
    //     "REPLACE INTO cartitems SET product_id = '$productId', qantity = '$updatedQty',shop_id='$shopId' ");
    // print(update);
    return update;
  }

  Future deleteItems(String productId) async {
    var db = await dbInit();
    // var deletedItem = 
    await db
        .rawQuery("DELETE FROM cartitems WHERE product_id= '$productId';");
    // var table = 
    await db.rawQuery("SELECT * FROM cartitems");
  }

  Future clearData() async {
    var db = await dbInit();
    await db.rawQuery("DELETE FROM cartitems");
  }

  Future cartCount() async {
    var db = await dbInit();
    var count = await db.rawQuery("SELECT COUNT(*) FROM cartitems");
    // print(count);
    return count;
  }
}

import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String orderTable = "orderTable";
final String idColumn = "idColumn";
final String numbColumn = "numbColumn";
final String nameColumn = "nameColumn";
final String imgColumn = "imgColumn";
final String tipoColumn = "tipoColumn";
final String observColumn = "observColumn";
final String dateColumn = "dateColumn";
final String tiposColumn = "tiposColumn";

class OrderHelper {

  static final OrderHelper _instance = OrderHelper.internal();

  factory OrderHelper() => _instance;

  OrderHelper.internal();

  Database _db;

  Future<Database> get db async {
    if(_db != null){
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  Future<Database>initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "ordersnew.db");

    return await openDatabase(path, version: 1, onCreate: (Database db, int newerVersion) async {
      await db.execute(
        "CREATE TABLE $orderTable($idColumn INTEGER PRIMARY KEY, $numbColumn TEXT, $nameColumn TEXT,"
         "$imgColumn TEXT, $tipoColumn TEXT, $observColumn TEXT, $dateColumn TEXT, $tiposColumn TEXT)"
      );
    });
  }

  Future<Order> saveOrder(Order order) async {
    Database dbOrder = await db;
    order.date = DateFormat("dd/MM/yyyy").format(DateTime.now());
    order.id = await dbOrder.insert(orderTable, order.toMap());
    return order;
  }

  Future<Order> getOrder(int id) async {
    Database dbOrder = await db;
    List<Map> maps = await dbOrder.query(orderTable,
      columns: [idColumn, numbColumn, nameColumn, imgColumn, tipoColumn, observColumn, dateColumn, tiposColumn],
      where: "$idColumn = ?",
      whereArgs: [id]);
    if(maps.length > 0){
      return Order.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deleteOrder(int id) async {
    Database dbOrder = await db;
    return await dbOrder.delete(orderTable, where: "$idColumn = ?", whereArgs: [id]);
  }

  Future<int> updateOrder(Order order) async {
    Database dbOrder = await db;
    return await dbOrder.update(orderTable,
      order.toMap(),
      where: "$idColumn = ?", 
      whereArgs: [order.id]);
  }

  Future<List> getAllOrders() async {
    Database dbOrder = await db;
    List listMap = await dbOrder.rawQuery("SELECT * FROM $orderTable order by dateColumn" );
    List<Order> listOrder = [];
    for(Map m in listMap){
      listOrder.add(Order.fromMap(m));
    }
    return listOrder;
  }

  Future<int> getNumber() async {
    Database dbOrder = await db;
    return Sqflite.firstIntValue(await dbOrder.rawQuery("SELECT COUNT(*) FROM $orderTable"));
  }

  Future close() async {
    Database dbOrder = await db;
    dbOrder.close();
  }

}

// id  number  name     img        tipo   observacao
// 0   12      Luwa   /images/     ativo  bla bla bla

class Order {

  int id;
  String numb;
  String name;
  String img;
  String tipo;
  String observ;
  String date;
  String tipos;

  Order();

  Order.fromMap(Map map){
    id = map[idColumn];
    numb = map[numbColumn];
    name = map[nameColumn];
    img = map[imgColumn];
    tipo = map[tipoColumn];
    observ = map[observColumn];
    date = map[dateColumn];
    tipos = map[tiposColumn];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      numbColumn: numb,
      nameColumn: name,
      imgColumn: img,
      tipoColumn: tipo,
      observColumn: observ,
      dateColumn: date,
      tiposColumn: tipos
    };
    if(id != null){
      map[idColumn] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Order(id: $id, numb: $numb, name: $name, img: $img, tipo: $tipo, observ: $observ, date: $date, tipos: $tipos)";
  }

}
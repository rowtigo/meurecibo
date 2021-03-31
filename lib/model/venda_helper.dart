import 'dart:async';
import 'dart:ffi';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String vendaTable = "vendaTable";
final String idColumn = "idColumn";
final String tituloColumn = "tituloColumn";
final String descricaoColumn = "descricaoColumn";
final String clientesColumn = "clientesColumn";
final String tipoColumn = "tipoColumn";
final String dataPagamentoColumn = "datapagemtoColumn";
final String valorColumn = "valorColumn";
final String pagoColumn = "pagoColumn";

class VendasHelper {
  static final VendasHelper _instance = VendasHelper.internal();

  factory VendasHelper() => _instance;

  VendasHelper.internal();

  Database _db;

  Future<Database> get db async {
    if(_db != null){
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "meurecibo.db");

    return await openDatabase(path, version: 1, onCreate: (Database db, int newerVersion) async {
      await db.execute(
          "CREATE TABLE $vendaTable($idColumn INTEGER PRIMARY KEY, $tituloColumn TEXT, $descricaoColumn TEXT, $clientesColumn TEXT, $tipoColumn TEXT, $dataPagamentoColumn TEXT,  $valorColumn REAL, $pagoColumn TEXT)"
      );
    });
  }

  Future<Venda> saveVenda(Venda venda) async {
    Database dbVenda = await db;
    venda.id = await dbVenda.insert(vendaTable, venda.toMap());
    return venda;
  }

  Future<Venda> getVenda(int id) async {
    Database dbVenda = await db;
    List<Map> maps = await dbVenda.query(vendaTable,
        columns: [idColumn, tituloColumn, descricaoColumn, clientesColumn, tipoColumn, dataPagamentoColumn, valorColumn, pagoColumn],
        where: "$idColumn = ?",
        whereArgs: [id]);
    if(maps.length > 0){
      return Venda.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deleteVenda(int id) async {
    Database dbVenda  = await db;
    return await dbVenda.delete(vendaTable, where: "$idColumn = ?", whereArgs: [id]);
  }

  Future<int> updateVenda(Venda venda) async {
    Database dbVenda = await db;
    return await dbVenda.update(vendaTable,
        venda.toMap(),
        where: "$idColumn = ?",
        whereArgs: [venda.id]);
  }

  // Future<int> marcarComoPago(Venda venda) async {
  //   Database dbVenda = await db;
  //   return await dbVenda.update(vendaTable,
  //       //venda.toMapPago(),
  //       where: "$idColumn = ?",
  //       whereArgs: [venda.id]);
  // }
  //
  // Future<int> marcarComoAberto(Venda venda) async {
  //   Database dbVenda = await db;
  //   return await dbVenda.update(vendaTable,
  //       venda.toMapAberto(),
  //       where: "$idColumn = ?",
  //       whereArgs: [venda.id]);
  // }

  Future<List> getAll() async {
    Database dbVenda = await db;
    List listMap = await dbVenda.rawQuery("SELECT * FROM $vendaTable");
    List<Venda> listVendas = List();
    for(Map m in listMap){
      listVendas.add(Venda.fromMap(m));
    }
    return listVendas;
  }


  Future<String> getTotalVendas() async {
    var dbVenda = await db;
    var result = await dbVenda.rawQuery("SELECT SUM($valorColumn) FROM $vendaTable");
    var value = result[0]["SUM($valorColumn)"]; // value = 220
    return value.toString();
    print("O TAOATAL É: " + value.toString());

  }

  // Future<int> getNumber() async {
  //   Database dbContact = await db;
  //   return Sqflite.firstIntValue(await dbContact.rawQuery("SELECT COUNT(*) FROM $contactTable"));
  // }

  Future close() async {
    Database dbContact = await db;
    dbContact.close();
  }

}

class Venda {

  int id;
  String pago;
  String titulo;
  String descricao;
  String tipo;
  String clientes;
  String dataPagemnto;
  double valor;
  double total;

  Venda();

  Venda.fromMap(Map map){
    id = map[idColumn];
    pago = map[pagoColumn];
    titulo = map[tituloColumn];
    descricao = map[descricaoColumn];
    tipo = map[tipoColumn];
    clientes = map[clientesColumn];
    dataPagemnto = map[dataPagamentoColumn];
    valor = map[valorColumn];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      tituloColumn: titulo,
      descricaoColumn: descricao,
      tipoColumn: tipo,
      clientesColumn: clientes,
      dataPagamentoColumn: dataPagemnto,
      valorColumn: valor,
      pagoColumn: pago,
    };
    if(id != null){
      map[idColumn] = id;
    }
    return map;
  }


  // @override
  // String toString() {
  //   return "Contact(id: $id, name: $name, email: $email, phone: $phone, img: $img)";
  // }
}

import 'dart:convert';
import 'dart:io';
import 'package:common_utils/common_utils.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:guanjia/ui/plaza/plaza_history/plaza_history_controller.dart';

import '../network/api/model/talk_model.dart';

class PlazaDatabase {
  static const _version = 1; // 数据库版本号
  static const _databaseName = "plaza_history.db"; // 数据库名称
  static const _tableName = "plaza_history"; // 表名称
  static const _tableData = "data"; // 浏览数据

  PlazaDatabase.internal();

  //数据库句柄
  late Database _database;
  Future<Database> get database async {
    String path = join(await getDatabasesPath(), _databaseName);
    _database = await openDatabase(path, version: _version,
        onConfigure: (Database db) {
          print("数据库创建前、降级前、升级前调用");
        }, onCreate: (Database db, int version) async {
          print("创建时调用");
          await _createTable(db, '''create table if not exists $_tableName (
        id text primary key, 
        searchId INTEGER,
        $_tableData text)''');
        }, onOpen: (Database db) async {
          print("重新打开时调用");
        });
    return _database;
  }

  /// 创建表
  Future<void> _createTable(Database db, String sql) async {
    await db.execute(sql);
  }

  /// 添加数据或更新数据
  static Future<void> insertOrUpdateData(String id, PlazaListModel? data) async {
    Database db = await PlazaDatabase.internal().open();
    var dateTime = DateTime.now();
    data = data?.copyWith(
      browsingTime: DateUtil.formatDate(dateTime, format: DateFormats.y_mo_d),
      browsingTimeStamp: dateTime.millisecondsSinceEpoch
    );
    String jsonData = json.encode(data);

    List<Map<String, dynamic>> maxSearchIdRecord = await db.rawQuery("SELECT MAX(searchId) as maxId FROM $_tableName");
    int maxSearchId = (maxSearchIdRecord[0]['maxId'] ?? 0) + 1;
    List<Map<String, dynamic>> records = await db.rawQuery("SELECT * FROM $_tableName WHERE id = ?", [id]);

    if (records.isNotEmpty) {
      // 删除已存在的记录
      await db.rawDelete("DELETE FROM $_tableName WHERE id = ?", [id]);
    }

    await db.transaction((txn) async {
      await txn.rawInsert("INSERT INTO $_tableName (id, searchId, $_tableData) VALUES (?, ?, ?)", [id, maxSearchId, jsonData]);
    });

    await db.close();
  }

  /// 查询全部数据
  static Future<List<Map<String, dynamic>>> searchAllData(int page) async {
    print("page==$page");
    Database db = await PlazaDatabase.internal().open();
    int limit = 10; // 每页返回的最大数量
    int offset = (page - 1) * limit; // 计算偏移量

    List<Map<String, dynamic>> records = await db.rawQuery("SELECT * FROM $_tableName ORDER BY searchId DESC LIMIT ? OFFSET ?", [limit, offset]);
    List<Map<String, dynamic>> results = [];
    for (var record in records) {
      Map<String, dynamic> data = json.decode(record[_tableData]);
      results.add(data);
    }
    await db.close();
    return results;
  }

  /// 查询某一天的数据
  static Future<Map<String, dynamic>> searchData(String date) async {
    Database db = await PlazaDatabase.internal().open();
    List<Map<String, dynamic>> records = await db.rawQuery("SELECT * FROM $_tableName WHERE id = ?", [date]);

    Map<String, dynamic>? result;
    if (records.isNotEmpty) {
      result = json.decode(records[0][_tableData]);
    }

    await db.close();
    return result ?? {};
  }

  //打开
  Future<Database> open() async {
    return await database;
  }

  ///关闭
  Future<void> close() async {
    var db = await database;
    return db.close();
  }

  ///删除数据库文件
  static Future<bool> deleteDataBaseFile() async {
    await PlazaDatabase.internal().close();
    String path = join(await getDatabasesPath(), _databaseName);
    File file = File(path);
    if (await file.exists()) {
      await file.delete();
      if (!await file.exists()) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  ///获取总数量
  static Future<int> total() async {
    Database db = await PlazaDatabase.internal().open();
    int totalCount = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $_tableName')) ?? 0;
    return totalCount;
  }

  ///删除指定的数据库数据项
  static Future<void> deleteDataItem(String id) async {
    Database db = await PlazaDatabase.internal().open();
    int rowsDeleted =
    await db.rawDelete('DELETE FROM $_tableName WHERE id = ?', [id]);
    if (rowsDeleted > 0) {
      print("删除成功");
    } else {
      print("删除失败：未找到符合条件的数据");
    }
    await db.close();
  }
}

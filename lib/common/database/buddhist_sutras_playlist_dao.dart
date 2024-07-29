import 'package:sqflite/sqflite.dart';
import 'package:guanjia/common/network/api/api.dart';

///诵经播放列表 DAO
class BuddhistSutrasPlaylistDao {
  static const _tableName = 'buddhist_sutras_playlist';

  final Database database;
  BuddhistSutrasPlaylistDao(this.database);

  ///创建表
  Future<void> createTable() {
    return database.execute('''
    CREATE TABLE "$_tableName" (
      "id"	INTEGER NOT NULL,
      "name"	TEXT NOT NULL,
      "alias"	TEXT NOT NULL,
      "type"	INTEGER,
      "icon"	TEXT,
      "audio"	TEXT,
      "subtitles"	TEXT,
      "content"	TEXT,
      "remark"	TEXT,
      "duration"	INTEGER,
      "bless"	INTEGER,
      "createdAt"	INTEGER,
      "updatedAt"	INTEGER,
      PRIMARY KEY("id")
    );
    ''');
  }

  Future<void> save(BuddhistSutrasModel model) async {
    final results = await database.query(_tableName, where: 'id=?', whereArgs: [model.id], limit: 1, offset: 0);
    final values = {
      'id': model.id,
      'name': model.name,
      'alias': model.alias,
      'type': model.type,
      'icon': model.icon,
      'audio': model.audio,
      'subtitles': model.subtitles,
      'content': model.content,
      'remark': model.remark,
      'duration': model.duration,
      'bless': model.bless,
      'createdAt': DateTime.now().millisecondsSinceEpoch,
      'updatedAt': DateTime.now().millisecondsSinceEpoch,
    };
    if(results.isNotEmpty){
      final createdAt = results.first['createdAt'] ?? DateTime.now();
      await database.update(_tableName, {
        ...values,
        'createdAt': createdAt,
      }, where: 'id=?', whereArgs: [model.id]);
    }else{
      await database.insert(_tableName, values);
    }
  }

  Future<void> delete(BuddhistSutrasModel model) async {
    await database.delete(_tableName, where: 'id = ?', whereArgs: [model.id]);
  }

  Future<List<BuddhistSutrasModel>> list() async{
    final results = await database.query(_tableName, orderBy: 'createdAt desc');
    return results.map((e) => BuddhistSutrasModel.fromJson(e)).toList();
  }


}

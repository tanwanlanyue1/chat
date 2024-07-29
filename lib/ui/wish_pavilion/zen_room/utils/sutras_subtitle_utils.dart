import 'dart:io';
import 'package:lrc/lrc.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:guanjia/common/extension/string_extension.dart';
import 'package:guanjia/common/network/network.dart';
import 'package:guanjia/common/utils/app_logger.dart';

///经文字幕工具类
class SutrasSubtitleUtils {

  SutrasSubtitleUtils._();

  ///获取经文内容
  ///- url 文件URL
  static Future<File?> getSutrasContent(String url) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(join(dir.path, url.md5String));

    if (!(await file.exists())) {
      final response = await HttpClient.download(url, file.path);
      if (response.statusCode != 200) {
        return null;
      }
    }
    if (await file.exists()) {
      return file;
    }
    return null;
  }

  ///获取字幕文本行
  static Future<List<String>> getSutrasLines(String url,{bool isLrc = false}) async{
    final file = await getSutrasContent(url);
    if(file == null || !(await file.exists())){
      return [];
    }
    var list = <String>[];
    try{
      final content = await file.readAsString();
      final lrc = Lrc.parse(content);
      list = lrc.lyrics.map((e) => e.lyrics).toList();
    }catch(ex){
      list = await file.readAsLines();
    }
    return list
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty).toList();
  }
}


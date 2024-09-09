
import 'dart:io';
import 'package:common_utils/common_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:developer' as developer;

import 'app_info.dart';
import 'app_logger.dart';

///日志写入文件
class FileLogger{
  FileLogger._();

  static bool isEnabled = !AppInfo.isRelease;

  static void printFilePath() async{
    if(isEnabled){
      AppLogger.d(await getFilePath());
    }
  }

  ///输出日志内容
  static void printFileLog() async{
    if(isEnabled){
      final path = await getFilePath();
      final file = File(path);
      if(await file.exists()){
        final content = await file.readAsString();
        developer.log(content);
      }else{
        AppLogger.d('log file not found!, path=$path');
      }
    }
  }

  static Future<void> clear() async{
    if(isEnabled){
      final filepath = await getFilePath();
      final file = File(filepath);
      if(await file.exists()){
        await file.delete();
      }
    }
  }

  static Future<String> getFilePath() async{
    final dir = await getTemporaryDirectory();
    final fileName = '${DateUtil.formatDate(DateTime.now(), format: 'yyyyMMdd')}.txt';
    final filePath = '${dir.path}/$fileName';
    return filePath;
  }

  static final _logs = <String>[];
  static String? _currentLogText;

  static void d(String msg) async {
    if(isEnabled){
      _logs.add('${DateTime.now().toString()}  $msg\n');
      _execute();
      return;
    }
  }

  static Future<void> _execute() async{
    if (_currentLogText == null && _logs.isNotEmpty) {
      _currentLogText = _logs.removeAt(0);
      try {
        final filePath = await getFilePath();
        final file = File(filePath);
        await file.writeAsString(_currentLogText??'', mode: FileMode.append, flush: true);
      } catch (ex) {
        AppLogger.w('写入日志文件发生异常，logText=$_currentLogText, 发生异常ex=$ex');
      }
      _currentLogText = null;
      if (_logs.isNotEmpty) {
        await _execute();
      }
    }
  }

}
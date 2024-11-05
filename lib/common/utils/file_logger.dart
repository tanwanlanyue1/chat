
import 'dart:io';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/extension/string_extension.dart';
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
  static Future<String> printFileLog() async{
    if(isEnabled){
      final path = await getFilePath();
      final file = File(path);
      if(await file.exists()){
        final content = await file.readAsString();
        developer.log(content);
        return content;
      }else{
        AppLogger.d('log file not found!, path=$path');
      }
    }
    return '';
  }

  static Future<void> show() async{
    var text = await printFileLog();
    if(text.isEmpty){
      text = 'empty';
    }
    Get.dialog(
      AlertDialog(
        content: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: Get.height * 0.8),
          child: SingleChildScrollView(
            child: Text(text),
          ),
        ),
        actions: [
          TextButton(onPressed: (){
            clear();
            Get.back();
          }, child: Text('清空')),
          TextButton(onPressed: (){
            text.copy();
          }, child: Text('复制')),
          TextButton(onPressed: Get.back, child: Text('关闭')),
        ],
      )
    );
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
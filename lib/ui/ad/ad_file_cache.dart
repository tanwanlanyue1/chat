import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:guanjia/common/utils/app_logger.dart';

///广告文件缓存
class AdFileCache {
  AdFileCache._();

  static final instance = AdFileCache._();
  final _dio = Dio();
  CancelToken? _cancelToken;

  ///获取本地广告文件
  ///- url 广告URL
  Future<File?> getFile(String url) async {
    try {
      final file = await url.toAdFilePath();
      if (await file.exists()) {
        return file;
      }
    } catch (ex) {
      AppLogger.w('文件下载失败,url=$url, error=$ex');
    }
    return null;
  }

  ///下载文件到本地
  ///- url 广告URL
  Future<File?> downloadFile(String url) async {
    if (!url.startsWith('http')) {
      return null;
    }
    try {
      final file = await url.toAdFilePath();
      if (await file.exists()) {
        return file;
      }

      final tempPath = '${file.path}.temp';
      _cancelToken?.cancel();
      _cancelToken = CancelToken();
      final response = await _dio.download(url, tempPath, cancelToken: _cancelToken);
      if (response.statusCode == 200) {
        return File(tempPath).rename(file.path);
      }else{
        AppLogger.w('文件下载失败,url=$url, response=$response');
      }
    } catch (ex) {
      AppLogger.w('文件下载失败,url=$url, error=$ex');
    }
    return null;
  }
}

extension on String {
  Future<File> toAdFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return File(join(directory.path, 'ad', keyToMd5(this)));
  }
}

/// get md5 from key
String keyToMd5(String key) => md5.convert(utf8.encode(key)).toString();

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

extension DefaultCacheManagerX on DefaultCacheManager{
  static const _cacheImageFolderName = 'libCachedImageData';

  static DefaultCacheManager get instance => DefaultCacheManager();

  ///获取图片文件缓存大小
  Future<int> getImageCacheSize() async{
    final temp = await getTemporaryDirectory();
    final cacheDir = Directory(join(temp.path, _cacheImageFolderName));
    if(!(await cacheDir.exists())){
      return 0;
    }
    return compute<Directory, int>((cacheDir) async{
      var size = 0;
      await for (final FileSystemEntity file in cacheDir.list()) {
        size += file.statSync().size;
      }
      return size;
    }, cacheDir);
  }

  ///清空图片缓存
  Future<void> clearImageCache() async{
    final temp = await getTemporaryDirectory();
    final cacheDir = Directory(join(temp.path, _cacheImageFolderName));
    if(await cacheDir.exists()){
      await cacheDir.delete(recursive: true);
    }
  }

}

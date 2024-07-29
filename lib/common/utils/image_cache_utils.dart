import 'package:flutter/cupertino.dart';

class ImageCacheUtils {
  // 读取图片缓存大小
  static String getAllSizeOfCacheImages() {
    ImageCache? imageCache = PaintingBinding.instance!.imageCache;
    String cacheSizeStr = '0 kb';
    if (imageCache != null) {
      int byte = imageCache.currentSizeBytes;
      if (byte >= 0 && byte < 1024) {
        cacheSizeStr = '$byte B';
      }
      if (byte >= 1024 && byte < 1024 * 1024) {
        double size = (byte * 1.0 / 1024);
        String sizeStr = size.toStringAsFixed(2);
        cacheSizeStr = '$sizeStr KB';
      } else {
        double size = (byte * 1.0 / 1024) / 1024;
        String sizeStr = size.toStringAsFixed(2);
        cacheSizeStr = '$sizeStr MB';
      }
    }
    return cacheSizeStr;
  }

  // 清除所有图片缓存
  static void clearAllCacheImage() {
    ImageCache? imageCache = PaintingBinding.instance!.imageCache;
    if (imageCache != null) {
      imageCache.clear();
    }
  }
}

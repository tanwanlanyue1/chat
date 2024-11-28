import 'package:get/get.dart';
import 'package:guanjia/ui/plaza/release_media/media_upload/media_item.dart';

class ReleaseMediaState {

  ///图片/视频列表
  final mediaList = <MediaItem>[];

  ///是否是免费公开查看
  final isFreeRx = false.obs;

}

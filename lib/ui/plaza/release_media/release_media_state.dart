import 'package:get/get.dart';

import 'media_upload/media_upload_view.dart';

class ReleaseMediaState {

  ///图片/视频列表
  final mediaList = <MediaItem>[];

  ///是否是免费公开查看
  final isFreeRx = false.obs;

}

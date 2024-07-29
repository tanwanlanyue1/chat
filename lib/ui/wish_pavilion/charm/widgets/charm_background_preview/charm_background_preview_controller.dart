import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';

class CharmBackgroundPreviewController extends GetxController {
  CharmBackgroundPreviewController(this.url);

  final String url;

  bool isLoad = false;

  @override
  void onInit() async {
    await DefaultCacheManager().getSingleFile(url);
    isLoad = true;
    update();
    super.onInit();
  }
}

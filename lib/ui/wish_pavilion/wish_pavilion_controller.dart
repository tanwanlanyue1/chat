import 'package:get/get.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/widgets/ad_dialog.dart';
import 'package:guanjia/widgets/loading.dart';
import 'wish_pavilion_state.dart';

class WishPavilionController extends GetxController {
  final WishPavilionState state = WishPavilionState();

  void onTapNext(WishPavilionType type) {
    switch (type) {
      case WishPavilionType.zenRoom:
        Get.toNamed(AppRoutes.zenRoomPage);
        break;
      case WishPavilionType.templeOfWealth:
        Loading.showToast("暂未开放，敬请期待");
        break;
      case WishPavilionType.yearningRiver:
        Get.toNamed(AppRoutes.homesickRiverPage);
        break;
      case WishPavilionType.lightsPray:
        Get.toNamed(AppRoutes.lightsPrayPage);
        break;
      case WishPavilionType.releasePond:
        Loading.showToast("暂未开放，敬请期待");
        // Get.to(() => TestPage());
        break;
      case WishPavilionType.hallOfPrayer:
        Get.toNamed(AppRoutes.charmPage);
        break;
      case WishPavilionType.wishingForest:
        Loading.showToast("暂未开放，敬请期待");
        break;
    }
  }

  @override
  void onInit() {
    
    startupCarousel();
    super.onInit();
  }

  /// 获取广告弹窗
  void startupCarousel() async {
    final response = await OpenApi.startupAdvertList(
        type: 3,
        position: 6,
        size: 1
    );
    if (response.isSuccess) {
      if(response.data?.isNotEmpty ?? false){
        AppAdDialog.show(response.data![0],"6");
      }
    }
  }
}

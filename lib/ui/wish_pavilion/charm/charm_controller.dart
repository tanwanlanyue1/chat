import 'dart:async';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/ui/wish_pavilion/charm/put_charm/put_charm_bottom_sheet.dart';
import 'package:guanjia/ui/wish_pavilion/charm/widgets/charm_put_result/charm_put_result_dialog.dart';
import 'package:guanjia/ui/wish_pavilion/charm/widgets/charm_top_up_dialog.dart';
import 'package:guanjia/widgets/ad_dialog.dart';
import 'package:guanjia/widgets/loading.dart';
import 'package:guanjia/widgets/widgets.dart';

import 'charm_state.dart';

class CharmController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final CharmState state = CharmState();

  final loginService = SS.login;

  Timer? _timer;

  void onTapMyCharm() {
    Get.toNamed(AppRoutes.myCharmPage);
  }

  void onTapPutCharm() {
    loginService.requiredAuthorized(() {
      PutCharmBottomSheet.show();
    });
  }

  void onTapCharmBackground() {
    Get.toNamed(AppRoutes.charmBackgroundPage);
  }

  void onTapInvite() async {
    final info = state.charmInfo.value;
    if (info == null) return;

    loginService.requiredAuthorized(() async {
      if (info.cost != 0 &&
          (loginService.levelMoneyInfo?.money ?? 0) < info.cost) {
        Get.dialog(const CharmTopUpDialog());
        return;
      }

      Loading.show();
      final res = await CharmApi.inviteOrPayment(type: 0);
      Loading.dismiss();
      if (!res.isSuccess) {
        res.showErrorMessage();
        return;
      }

      loginService.fetchLevelMoneyInfo();
      // 重新拉取数据
      fetchCost();

      final model = res.data;
      if (model == null) return;

      // 先缓存了特效和图片资源，方便后续直接播放
      Loading.show();
      await DefaultCacheManager().getSingleFile(model.currentStateImageUrl);
      await DefaultCacheManager().getSingleFile(info.svga);
      Loading.dismiss();

      Get.dialog(
        CharmPutResultDialog(
          imageUrl: model.currentStateImageUrl,
          perfectImageUrl: model.perfectImageUrl,
          svga: info.svga,
          milliseconds: info.millisecond,
          lightNum: model.getLight,
          blessNum: model.getBless,
          onConfirm: () {
            onTapPutCharm();
          },
        ),
        useSafeArea: false,
      );
    });
  }

  void onTapOperation({required int id, required int type}) async {
    Loading.show();
    final res = await CharmApi.updateRecord(
      id: id,
      type: type,
    );
    Loading.dismiss();
    if (!res.isSuccess) {
      res.showErrorMessage();
      return;
    }
    // 重新拉取数据
    fetchCost();

    Loading.show();
    final recordRes = await CharmApi.getRecord(
      id: id,
    );
    if (!recordRes.isSuccess) {
      recordRes.showErrorMessage();
      return;
    }
    Loading.dismiss();

    state.charmRecord.value = recordRes.data;
  }

  Future<void> fetchCost() async {
    final res = await CharmApi.getCost();
    if (!res.isSuccess) {
      res.showErrorMessage();
      return;
    }

    final info = res.data;
    if (info == null) return;

    state.charmInfo.value = info;

    if (info.seconds > 0) {
      _startTimer();
    }
  }

  /// 获取广告弹窗
  void startupCarousel() async {
    final response =
        await OpenApi.startupAdvertList(type: 3, position: 11, size: 1);
    if (response.isSuccess) {
      if (response.data?.isNotEmpty ?? false) {
        AppAdDialog.show(response.data![0], "11");
      }
    }
  }

  @override
  void onInit() async {
    Loading.show();
    await fetchCost();
    startupCarousel();
    Loading.dismiss();
    super.onInit();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void _startTimer() {
    if (_timer != null) return;

    int seconds = state.charmInfo.value?.seconds ?? 0;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (seconds > 0) {
        seconds--;
        state.charmInfo.update((val) {
          val?.seconds = seconds;
        });
      } else {
        _resetCountdown();
      }
    });
  }

  void _resetCountdown() {
    _timer?.cancel();
    _timer = null;

    fetchCost();
  }
}

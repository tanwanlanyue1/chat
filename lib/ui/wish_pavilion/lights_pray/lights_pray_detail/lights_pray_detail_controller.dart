import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/widgets/loading.dart';

import 'lights_pray_detail_state.dart';

class LightsPrayDetailController extends GetxController {
  final LightsPrayDetailState state = LightsPrayDetailState();

  LightsPrayDetailController({
    required this.lightId,
  });

  final int lightId;

  void onTapPraise() async {
    SS.login.requiredAuthorized(() async {
      Loading.show();
      final res = await LightsPrayApi.praise(id: lightId);
      Loading.dismiss();
      if (!res.isSuccess) {
        Loading.showToast(res.errorMessage ?? "error");
        return;
      }

      fetchData();
    });
  }

  void fetchData() async {
    Loading.show();
    final res = await LightsPrayApi.info(id: lightId);
    Loading.dismiss();
    if (!res.isSuccess) {
      Loading.showToast(res.errorMessage ?? "error");
      Get.back();
      return;
    }

    state.model = res.data;

    update();
  }

  @override
  void onInit() {
    fetchData();
    super.onInit();
  }
}

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:scrollview_observer/scrollview_observer.dart';
import 'package:guanjia/common/extension/list_extension.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/ui/wish_pavilion/lights_pray/lights_pray_detail/lights_pray_detail_dialog.dart';
import 'package:guanjia/widgets/ad_dialog.dart';
import 'package:guanjia/widgets/loading.dart';

import 'lights_pray_state.dart';

class LightsPrayController extends GetxController {
  final LightsPrayState state = LightsPrayState();

  int myLightsSelectIndex = 0;

  ScrollController scrollController = ScrollController();
  late GridObserverController observerController =
      GridObserverController(controller: scrollController);

  Future<void> _fetchLightsData(LightsPrayArea area) async {
    // 先清空数组中存在的供灯模型
    clearAllItem();

    Loading.show();
    // 获取当前区域供灯列表
    final res = await LightsPrayApi.list(
      direction: area.index,
    );
    Loading.dismiss();

    if (!res.isSuccess) {
      Loading.showToast(res.message ?? "");
      return;
    }

    final data = res.data;
    if (data == null) {
      return;
    }

    for (var element in data) {
      final item = state.items.safeElementAt(element.position);
      item?.model = element;
    }

    state.items.refresh();
  }

  void _fetchMyLights() async {
    state.myLights.clear();
    myLightsSelectIndex = 0;

    // 获取当前区域供灯列表
    final res = await LightsPrayApi.myList();

    if (!res.isSuccess) return;

    final data = res.data;
    if (data == null) return;

    state.myLights =
        data.map((e) => LightsPrayItem(index: e.position, model: e)).toList();

    update();
  }

  void onTapChangeArea({LightsPrayArea? area}) {
    state.area.value = state.area.value.next;

    _fetchLightsData(state.area.value);
  }

  void onTapMyLocation() async {
    if (state.myLights.isEmpty) return;

    final item = state.myLights.safeElementAt(myLightsSelectIndex);
    final model = item?.model;

    if (item == null || model == null) {
      return;
    }

    final area = LightsPrayArea.getType(model.direction);
    final index = model.position;

    // 如果区域不同，需要重新拉取新区域数据
    if (area != state.area.value) {
      _fetchLightsData(area);
    }

    state.area.value = area;

    observerController.animateTo(
      index: index,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      padding: EdgeInsets.symmetric(vertical: state.mainAxisSpacing),
      alignment: 0.5,
      offset: (offset) {
        return state.listConstraints.maxHeight / 2;
      },
    );

    myLightsSelectIndex = (myLightsSelectIndex + 1) % state.myLights.length;
  }

  void onTapChoosePosition(int position, {required LightsPrayItem item}) {
    final model = item.model;
    if (model != null) {
      LightsPrayDetailDialog.show(model.id);
      return;
    }

    Get.toNamed(AppRoutes.lightsPrayInvitationPage, arguments: {
      "position": position,
      "direction": state.area.value.index,
    })?.then((value) {
      if (value is int) {
        _fetchMyLights();
        _fetchLightsData(state.area.value);
      }
    });
  }

  void updateItemAt(int index) {
    state.items[index].model = null;
    state.items.refresh();
  }

  void clearAllItem() {
    for (var element in state.items) {
      element.model = null;
    }
  }

  /// 获取广告弹窗
  void startupCarousel() async {
    final response = await OpenApi.startupAdvertList(
        type: 3,
        position: 10,
        size: 1
    );
    if (response.isSuccess) {
      if(response.data?.isNotEmpty ?? false){
        AppAdDialog.show(response.data![0],"10");
      }
    }
  }
  @override
  void onInit() {
    _fetchLightsData(state.area.value);
    _fetchMyLights();
    startupCarousel();
    super.onInit();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}

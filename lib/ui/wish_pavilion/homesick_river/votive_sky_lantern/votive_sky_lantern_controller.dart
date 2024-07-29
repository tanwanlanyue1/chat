
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/widgets/widgets.dart';

import '../homesick_river_controller.dart';
import '../widget/sky_lantern_bottom_sheet.dart';
import 'votive_sky_lantern_state.dart';

class VotiveSkyLanternController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final VotiveSkyLanternState state = VotiveSkyLanternState();
  late TabController tabController;
  //祝福者
  final TextEditingController benedictionController = TextEditingController();
  //愿望-控制器
  final TextEditingController wishInputController = TextEditingController();
  final homeController = Get.find<HomesickRiverController>();

  ///获取热门列表
  Future<void> getHotList() async {
    final response = await HomesickRiverApi.getHotList();
    if (response.isSuccess) {
      state.hotLanterns = response.data ?? [];
      state.filtrateData = state.hotLanterns;
      update();
    }
  }

  ///获取礼物列表
  ///type: 礼物类型：1上香2供品，3河灯，4天灯，5供灯
  ///subType: 1婚恋2生活3学业4财运5事业
  Future<void> getCommentList({int subType = 0}) async {
    final response = await GiftApi.list(
      type: 4,
    );
    if (response.isSuccess) {
      state.votiveSkyLantern = response.data ?? [];
    }
  }

  ///根据礼物ID获取售价配置信息
  ///type: /api/miss/getConfig
  ///again:再次许愿
  Future<void> getConfig(GiftModel item,{RecordDetailsModel? details}) async {
    final response = await HomesickRiverApi.getConfig(
      lanternId: item.id,
    );
    if (response.isSuccess) {
      state.timeLimit = response.data ?? [];
      if(details != null){
        wishInputController.text = details.desire ?? '';
        benedictionController.text = details.name ?? '';
      }else{
        benedictionController.clear();
        wishInputController.clear();
      }
      state.moreTemplate = false;
      if (item.surplusCount == 0) {
        state.currentIndex.value = 1;
      }
      SkyLanternBottomSheet.show(
        item: item,
      );
    }
  }

  ///获取天灯许愿模板
  Future<void> getTemplateList() async {
    final response = await HomesickRiverApi.getTemplateList();
    if (response.isSuccess) {
      state.templateData = response.data;
    }
  }

  ///筛选类型
  disposeData(int type) {
    if (type == -1) {
      state.filtrateData = state.hotLanterns;
    } else {
      state.filtrateData =
          state.votiveSkyLantern.where((data) => data.subType == type).toList();
    }
    update();
  }

  @override
  void onInit() async {
    tabController = TabController(
        length: state.skyLanternType.length, vsync: this, initialIndex: 0);

    getHotList();
    getCommentList();
    getTemplateList();
    super.onInit();
  }

  ///放天灯求愿
  ///type: /api/miss/getConfig
  Future<void> saveRecord(int giftId) async {
    SS.login.requiredAuthorized(() async {
      if (benedictionController.text.isEmpty) {
        Loading.showToast('请写下被祝福者的名字！');
      } else if (wishInputController.text.isEmpty) {
        Loading.showToast('请写下祈求的愿望！');
      } else if (state.timeLimit.isEmpty) {
        Loading.showToast('该天灯没有配置时限，请让后台配置！');
      } else {
        final response = await HomesickRiverApi.saveRecord(
          giftId: giftId,
          name: benedictionController.text,
          desire: wishInputController.text,
          configId: state.timeLimit[state.currentIndex.value].id,
          open: state.timeLimit[state.currentIndex.value].acquiesce,
        );
        if (response.isSuccess) {
          Get.back();
          homeController.getRecord(type: 4);
          SS.login.fetchLevelMoneyInfo();
          Loading.showToast('求愿成功！');
        } else {
          response.showErrorMessage();
        }
      }
    });
  }
}

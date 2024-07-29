import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/ui/wish_pavilion/homesick_river/homesick_river_controller.dart';
import 'package:guanjia/widgets/loading.dart';

import 'missing_river_lamp_state.dart';

class MissingRiverLampController extends GetxController {
  final MissingRiverLampState state = MissingRiverLampState();
  //思念-控制器
  final TextEditingController missInputController = TextEditingController();
  final homeController = Get.find<HomesickRiverController>();

  ///获取礼物列表
  ///type: 礼物类型：1上香2供品，3河灯，4天灯，5供灯
  Future<void> getCommentList({int subType = 0}) async {
    final response = await GiftApi.list(
      type: 3,
    );
    if (response.isSuccess) {
      state.selectAging.value = null;
      state.votiveSkyLantern = response.data ?? [];
      if (state.votiveSkyLantern.isNotEmpty) {
        getConfig(
          acquiesce: 1,
        );
      }
    }
  }

  ///根据礼物ID获取售价配置信息
  ///acquiesce:0非默认，1默认
  Future<void> getConfig({int? acquiesce}) async {
    final response = await HomesickRiverApi.getConfig(
      lanternId: state.votiveSkyLantern[state.river].id,
      acquiesce: acquiesce,
    );
    if (response.isSuccess) {
      if (acquiesce == 1) {
        state.timeLimit = response.data ?? [];
        if (state.timeLimit.isNotEmpty) {
          state.agingCurrent.value = state.timeLimit[0].id;
        }
        missInputController.text = '';
        state.selectAging.value = null;
      } else {
        state.allTime = response.data ?? [];
      }
      update(['MissingRiverLampController']);
    }
  }

  //是否公开
  void setOpen() {
    if (state.open == 0) {
      state.open = 1;
    } else {
      state.open = 0;
    }
    update(['MissingRiverLampController']);
  }

  ///清空数据
  void cleanData() {
    missInputController.text = '';
    state.river = 0;
  }

  @override
  void onInit() {
    
    getCommentList();
    super.onInit();
  }

  ///点河灯祝福
  Future<void> saveRecord() async {
    SS.login.requiredAuthorized(() async {
      if (missInputController.text.isEmpty) {
        Loading.showToast('请写下您的思念或祝福！');
      } else {
        final response = await HomesickRiverApi.saveRecord(
          giftId: state.votiveSkyLantern[state.river].id,
          configId: state.agingCurrent.value,
          desire: missInputController.text,
          open: state.open,
        );
        if (response.isSuccess) {
          Get.back();
          homeController.getRecord(type: 3);
          Loading.showToast('河灯祝福成功！');
        } else {
          response.showErrorMessage();
        }
      }
    });
  }
}

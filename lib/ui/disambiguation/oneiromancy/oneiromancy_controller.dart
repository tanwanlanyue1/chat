import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/ui/home/bottom_sheet_chat/bottom_sheet_chat_page.dart';
import 'package:guanjia/widgets/ad_dialog.dart';
import 'package:guanjia/widgets/loading.dart';

import 'oneiromancy_state.dart';

class OneiromancyController extends GetxController {
  final OneiromancyState state = OneiromancyState();
  TextEditingController dreamController = TextEditingController();
  FocusNode chatFocusNode = FocusNode();

  set setSex(bool val){
    state.sex = val;
    update();
  }

  @override
  void onInit() {
    
    getGold();
    startupCarousel();
    startupAdvertList();
    chatFocusNode.addListener(() {
      if(chatFocusNode.hasFocus){
        state.focus = true;
      }else{
        state.focus = false;
      }
      update();
    });
    super.onInit();
  }

  ///解梦
  Future<void> getPair() async {
    SS.login.requiredAuthorized(() async {
      if(dreamController.text.isEmpty){
        Loading.showToast('请写下梦境内容！');
      }else{
        Loading.show();
        final response = await DisambiguationApi.saveDream(
          content: dreamController.text,
          sex: state.sex ? "男":"女",
        );
        Loading.dismiss();
        if(response.isSuccess){
          if(state.costGold == 0){
            getGold();
          }
          SS.login.fetchLevelMoneyInfo();
          Map item = {
            "quiz":{
              "name": dreamController.text,
              "sex": state.sex ? "男":"女",
            },
            "answer": response.data,
          };
          dreamController.text = '';
          BottomSheetChatPage.show(
            type: 8,
            item: item,
          );
        }else{
         response.showErrorMessage();
        }
      }
    });
  }

  ///玩法所需境修币
  Future<void> getGold() async {
    final response = await DisambiguationApi.getGold(
        type: 8
    );
    if(response.isSuccess){
      state.costGold = response.data?.cost ?? 0;
      update();
    }
  }

  /// 获取广告轮播 carousel
  Future<void> startupCarousel() async {
    final response = await OpenApi.startupAdvertList(
        type: 4,
        position: 5
    );
    if (response.isSuccess) {
      state.carousel = response.data ?? [];
    }
  }

  /// 获取广告弹窗
  void startupAdvertList() async {
    final response = await OpenApi.startupAdvertList(
        type: 3,
        position: 5,
        size: 1
    );
    if (response.isSuccess) {
      if(response.data?.isNotEmpty ?? false){
        AppAdDialog.show(response.data![0],"5");
      }
    }
  }
  @override
  void onClose() {
    
    dreamController.clear();
    chatFocusNode.removeListener(() {});
    super.onClose();
  }
}

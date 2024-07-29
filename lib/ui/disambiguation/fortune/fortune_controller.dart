import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lunar/lunar.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/common_utils.dart';
import 'package:guanjia/ui/home/bottom_sheet_chat/bottom_sheet_chat_page.dart';
import 'package:guanjia/widgets/ad_dialog.dart';
import 'package:guanjia/widgets/loading.dart';
import 'package:guanjia/widgets/lunar/lunar_view.dart';

import 'fortune_state.dart';

class FortuneController extends GetxController {
  final FortuneState state = FortuneState();
  TextEditingController nameController = TextEditingController();
  FocusNode chatFocusNode = FocusNode();

  //设置性别
  set setSex(bool val){
    state.sex = val;
    update();
  }
  //设置测算类型
  set setCalculate(int val){
    state.calculateIndex = val;
    update();
  }

  //默认出生日期为今天
  void getCurrentDateTime() {
    nameController.text = '';
    DateTime now = DateTime.now();
    state.birthdayList = ['2000','${now.month < 10 ? '0${now.month}': now.month}','${now.day}','${now.hour}'];
    state.solarList = ['2000','${now.month < 10 ? '0${now.month}': now.month}','${now.day}','${now.hour}'];
    state.birthday = "2000年${now.month}月${now.day}日${now.hour}时";
  }

  //选择时间
  void onTapChooseBirth() async {
    LunarView.show(
      onSelectionChanged: (List<String> value) {
        state.birthday = "${value[0]}年${value[1]}月${value[2]}日${value[3]}时";
        if(value[4] == 'false'){
          Solar solar = CommonUtils.lunarToSolar(value);
          state.solarList = ['${solar.getYear()}',(solar.getMonth() < 10 ? '0${solar.getMonth()}' : '${solar.getMonth()}'),(solar.getDay() < 10 ? '0${solar.getDay()}' :'${solar.getDay()}'),'${solar.getHour()}'];
        }else{
          state.birthdayList = value;
          state.solarList = value;
        }
        update();
      },
      defaultSelection: state.birthdayList,
    );
  }

  @override
  void onInit() {
    
    getCurrentDateTime();
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

  ///玩法所需境修币
  Future<void> getGold() async {
    final response = await DisambiguationApi.getGold(
        type: 7
    );
    if(response.isSuccess){
      state.costGold = response.data?.cost ?? 0;
      update();
    }
  }
  ///测算运势
  ///type	查询类型（1财运 2爱情 3健康 4事业）
  Future<void> getPair() async {
    SS.login.requiredAuthorized(() async {
      if(nameController.text.isEmpty){
        Loading.showToast('请填写测算姓名！');
      }else{
        Loading.show();
        final response = await DisambiguationApi.getFortune(
          name: nameController.text,
          sex: state.sex ? '男' : "女",
          birthday: '${state.solarList[0]}-${state.solarList[1] == '未知' ? '01' : state.solarList[1]}-${state.solarList[2] == '未知' ? '01' : state.solarList[2]} ${state.solarList[3] == '未知' ? '01' : state.solarList[3]}',
          type: state.calculateIndex+1,
          typeStr: state.calculateType[state.calculateIndex]['name'],
        );
        Loading.dismiss();
        if(response.isSuccess){
          if(state.costGold == 0){
            getGold();
          }
          SS.login.fetchLevelMoneyInfo();
          Map item = {
            "quiz":{
              "name": nameController.text,
              "sex": state.sex ? '男' : "女",
              "birthday": state.birthday,
              "type": state.calculateType[state.calculateIndex]['name'],
            },
            "answer": response.data,
          };
          nameController.text = '';
          BottomSheetChatPage.show(
            type: 7,
            item: item,
          );
        }else{
          response.showErrorMessage();
        }
      }
    });
  }

  /// 获取广告轮播 carousel
  Future<void> startupCarousel() async {
    final response = await OpenApi.startupAdvertList(
        type: 4,
        position: 4
    );
    if (response.isSuccess) {
      state.carousel = response.data ?? [];
      update();
    }
  }

  /// 获取广告弹窗
  void startupAdvertList() async {
    final response = await OpenApi.startupAdvertList(
        type: 3,
        position: 4,
        size: 1
    );
    if (response.isSuccess) {
      if(response.data?.isNotEmpty ?? false){
        AppAdDialog.show(response.data![0],"4");
      }
    }
  }
  @override
  void onClose() {
    
    chatFocusNode.removeListener(() {});
    super.onClose();
  }
}

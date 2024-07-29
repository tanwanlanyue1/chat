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

import 'take_name_state.dart';

class TakeNameController extends GetxController with GetSingleTickerProviderStateMixin{
  final TakeNameState state = TakeNameState();
  //姓氏输入框控制器
  final TextEditingController familyNameController = TextEditingController();
  //检查是否所有表单都已填写完成
  bool get isFormFilled => familyNameController.text.isNotEmpty;
  FocusNode chatFocusNode = FocusNode();

  set setBeBorn(bool val){
    state.beBorn = val;
    update();
  }

  set setSex(bool val){
    state.sex = val;
    update();
  }

  set setFamilyName(String val){
    familyNameController.text = val;
    update();
  }

  //默认出生日期为今天
  void getCurrentDateTime() {
    familyNameController.text = '';
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
        type: 3
    );
    if(response.isSuccess){
      state.costGold = response.data?.cost ?? 0;
      update();
    }
  }

  ///取名
  Future<void> getPair() async {
    SS.login.requiredAuthorized(() async {
      if(familyNameController.text.isEmpty){
        Loading.showToast('请填写姓氏！');
      }else{
        Loading.show();
        final response = await DisambiguationApi.saveName(
          surname: familyNameController.text,
          sex: state.beBorn ? (state.sex ? '1' : "2") : null,
          birth: state.beBorn ? '1' : '0',
          birthday: state.beBorn ? ('${state.solarList[0]}-${state.solarList[1] == '未知' ? '01' : state.solarList[1]}-${state.solarList[2] == '未知' ? '01' : state.solarList[2]}') : null,
        );
        Loading.dismiss();
        if(response.isSuccess){
          if(state.costGold == 0){
            getGold();
          }
          if(response.data?.isEmpty ?? true){
            Loading.showToast('暂无此姓氏信息，请重新填写!');
          }else{
            SS.login.fetchLevelMoneyInfo();
            Map item = {
              "quiz":{
                "name": familyNameController.text,
                "sex": state.beBorn ? (state.sex ? '男' : "女") : '',
                "birth": state.beBorn ? '已出生' : "未出生",
                "birthday": state.beBorn ? state.birthday : '',
              },
              "answer": response.data,
            };
            getCurrentDateTime();
            BottomSheetChatPage.show(
              type: 3,
              item: item,
            );
          }
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
        position: 2
    );
    if (response.isSuccess) {
      state.carousel = response.data ?? [];
    }
  }

  /// 获取广告弹窗
  void startupAdvertList() async {
    final response = await OpenApi.startupAdvertList(
        type: 3,
        position: 2,
        size: 1
    );
    if (response.isSuccess) {
      if(response.data?.isNotEmpty ?? false){
        AppAdDialog.show(response.data![0],"2");
      }
    }
  }
  @override
  void onClose() {
    
    chatFocusNode.removeListener(() {});
    super.onClose();
  }
}

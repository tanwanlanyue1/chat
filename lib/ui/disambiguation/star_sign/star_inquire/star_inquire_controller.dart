import 'package:get/get.dart';
import 'package:guanjia/common/network/api/disambiguation_api.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/ui/home/bottom_sheet_chat/bottom_sheet_chat_page.dart';
import 'package:guanjia/widgets/loading.dart';
import 'package:guanjia/widgets/lunar/lunar_view.dart';

import 'dart:async';
import 'star_inquire_state.dart';

class StarInquireController extends GetxController {
  final StarInquireState state = StarInquireState();

  //设置性别
  set setSex(bool val){
    state.sex = val;
    update();
  }

  //默认出生日期为今天
  void getCurrentDateTime() {
    DateTime now = DateTime.now();
    state.birthdayList = ['2000','${now.month < 10 ? '0${now.month}': now.month}','${now.day}','${now.hour}'];
    state.birthday = "2000年${now.month}月${now.day}日${now.hour}时";
  }

  //选择时间
  Future<bool?> onTapChooseBirth() async {
    Completer<bool> completer = Completer<bool>();
    LunarView.show(
      onSelectionChanged: (List<String> value) {
        state.birthdayList = value;
        state.birthday = "${value[0]}年${value[1]}月${value[2]}日${value[3]}时";
        update();
        completer.complete(true);
      },
      defaultSelection: state.birthdayList,
    );
    return completer.future;
  }

  @override
  void onInit() {
    
    getGold();
    getCurrentDateTime();
    super.onInit();
  }

  ///玩法所需境修币
  Future<void> getGold() async {
    final response = await DisambiguationApi.getGold(
        type: 5
    );
    if(response.isSuccess){
      state.costGold = response.data?.cost ?? 0;
      update();
    }
  }

  ///星座-星盘
  Future<void> horoscope() async {
    SS.login.requiredAuthorized(() async {
      Loading.show();
      final response = await DisambiguationApi.horoscope(
          year: state.birthdayList[0] == "未知" ? "2000" : state.birthdayList[0],
          month: state.birthdayList[1] == "未知" ? "1" : (state.birthdayList[1].startsWith('0') ? state.birthdayList[1].substring(1) : state.birthdayList[1]),
          day: state.birthdayList[2] == "未知" ? "1" : (state.birthdayList[2].startsWith('0') ? state.birthdayList[2].substring(1) : state.birthdayList[2]),
          hour: state.birthdayList[3] == "未知" ? "1" : (state.birthdayList[3].startsWith('0') ? state.birthdayList[3].substring(1) : state.birthdayList[3]),
          province: state.allAddressPresent['province'],
          city: state.allAddressPresent['city']
      );
      Loading.dismiss();
      if(response.isSuccess){
        if(state.costGold == 0){
          getGold();
        }
        SS.login.fetchLevelMoneyInfo();
        Map item = {
          "quiz":{
            "time": state.birthdayList,
            "address": state.allAddressPresent,
          },
          "answer": response.data,
        };
        BottomSheetChatPage.show(
          type: 5,
          item: item,
        );
      }else{
        response.showErrorMessage();
      }
    });
  }

}

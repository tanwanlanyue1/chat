import 'package:get/get.dart';
import 'package:guanjia/common/network/api/disambiguation_api.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/ui/home/bottom_sheet_chat/bottom_sheet_chat_page.dart';
import 'package:guanjia/widgets/loading.dart';

import 'star_fortune_state.dart';

class StarFortuneController extends GetxController {
  final StarFortuneState state = StarFortuneState();

  @override
  void onInit() {
    
    getGold();
    super.onInit();
  }

  ///玩法所需境修币
  Future<void> getGold() async {
    final response = await DisambiguationApi.getGold(
        type: 4
    );
    if(response.isSuccess){
      state.costGold = response.data?.cost ?? 0;
      update();
    }
  }

  ///星座运势
  Future<void> getFortune() async {
    SS.login.requiredAuthorized(() async {
      Loading.show();
      final response = await DisambiguationApi.fortune(
        constellation: state.constellation.constellation!,
        timeType: state.timeType[state.timeIndex.value]['timeType'],
        timeTypeStr: state.timeType[state.timeIndex.value]['name'],
        constellationStr: state.constellation.name!,
      );
      Loading.dismiss();
      if(response.isSuccess){
        SS.login.fetchLevelMoneyInfo();
        if(state.costGold == 0){
          getGold();
        }
        Map item = {
          "quiz":{
            "time": state.timeType[state.timeIndex.value]['name'],
            "constellation": state.constellation,
          },
          "answer": response.data,
        };
        BottomSheetChatPage.show(
          type: 4,
          item: item,
        );
      }else{
        response.showErrorMessage();
      }
    });
  }
}

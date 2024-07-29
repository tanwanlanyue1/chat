import 'package:get/get.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/ui/home/bottom_sheet_chat/bottom_sheet_chat_page.dart';
import 'package:guanjia/widgets/loading.dart';

import 'star_pairing_state.dart';

class StarPairingController extends GetxController {
  final StarPairingState state = StarPairingState();

  @override
  void onInit() {
    
    getGold();
    super.onInit();
  }

  ///玩法所需境修币
  Future<void> getGold() async {
    final response = await DisambiguationApi.getGold(
        type: 6
    );
    if(response.isSuccess){
      state.costGold = response.data?.cost ?? 0;
      update();
    }
  }

  ///星座配对
  Future<void> getPair() async {
    SS.login.requiredAuthorized(() async {
      Loading.show();
      final response = await DisambiguationApi.pair(
        man: '${state.pairingBoy.name!}男',
        woman: '${state.pairingGirl.name!}女',
      );
      Loading.dismiss();
      if(response.isSuccess){
        if(state.costGold == 0){
          getGold();
        }
        SS.login.fetchLevelMoneyInfo();
        Map item = {
          "quiz":{
            "man": state.pairingBoy,
            "woman": state.pairingGirl,
          },
          "answer": response.data,
        };
        BottomSheetChatPage.show(
          type: 6,
          item: item,
        );
      }else{
        response.showErrorMessage();
      }
    });
  }
}

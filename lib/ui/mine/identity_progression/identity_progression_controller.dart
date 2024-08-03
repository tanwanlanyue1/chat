import 'package:get/get.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/ui/mine/widgets/activation_progression.dart';
import 'package:guanjia/widgets/loading.dart';

import 'identity_progression_state.dart';

class IdentityProgressionController extends GetxController {
  final IdentityProgressionState state = IdentityProgressionState();

  @override
  void onInit() {
    // TODO: implement onInit
    setInterests();
    onTapActivation();
    super.onInit();
  }

  void updateAudit(){
    ActivationProgression.show(
      callBack: (val)=> onTapUserAdvanced(val)
    );
  }

  void setInterests(){
    state.current = state.loginInfo?.type.index ?? 0;
    if(state.current == 0){
      state.interests = state.clientInterests;
    }else if(state.current == 1){
      state.interests = state.jiaInterests;
    }else{
      state.interests = state.brokerInterests;
    }
    update();
  }

  //用户进阶查询
  void onTapActivation() async {
    Loading.show();
    final response = await UserApi.getUserAdvanced();
    Loading.dismiss();
    if(response.isSuccess){
      state.advanced = response.data ?? state.advanced;
      state.audit = state.advanced.status ?? 0;
      update();
    }else{
      response.showErrorMessage();
    }
  }

  //用户进阶
  void onTapUserAdvanced(int index) async {
    Loading.show();
    final response = await UserApi.userAdvanced(
        type: index
    );
    Loading.dismiss();
    if(response.isSuccess){
      Get.back();
      onTapActivation();
    }else{
      response.showErrorMessage();
    }
  }
}

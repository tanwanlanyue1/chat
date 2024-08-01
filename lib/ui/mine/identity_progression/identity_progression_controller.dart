import 'package:get/get.dart';

import 'identity_progression_state.dart';

class IdentityProgressionController extends GetxController {
  final IdentityProgressionState state = IdentityProgressionState();

  @override
  void onInit() {
    // TODO: implement onInit
    setInterests();
    super.onInit();
  }

  void updateAudit(){
    if(state.audit < 2){
      state.audit++;
    }else{
      state.audit = 0;
    }
    update();
  }

  void updateCurrent(){
    if(state.current < 2){
      state.current++;
    }else{
      state.current = 0;
    }
    setInterests();
  }

  void setInterests(){
    if(state.current == 0){
      state.interests = state.jiaInterests;
    }else if(state.current == 1){
      state.interests = state.clientInterests;
    }else{
      state.interests = state.brokerInterests;
    }
    update();
  }

}

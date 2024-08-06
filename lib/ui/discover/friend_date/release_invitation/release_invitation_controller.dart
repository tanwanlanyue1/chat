import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/widgets/loading.dart';

import '../widget/release_success.dart';
import 'release_invitation_state.dart';

class ReleaseInvitationController extends GetxController {
  final ReleaseInvitationState state = ReleaseInvitationState();
  TextEditingController contentController = TextEditingController();

  //设置标签
  void setLabel(int index){
    if(state.labelList.length < 3){
      if(state.labelList.contains(index)){
        state.labelList.remove(index);
      }else{
        state.labelList.add(index);
      }
    }else{
      if(state.labelList.contains(index)){
        state.labelList.remove(index);
      }
    }
  }

  //发布
  void onTapRelease(){
    ReleaseSuccess.show();
  }
}

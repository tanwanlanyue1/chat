import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/network/api/user_api.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/widgets/loading.dart';

import 'mine_service_charge_state.dart';

class MineServiceChargeController extends GetxController {
  final MineServiceChargeState state = MineServiceChargeState();
  TextEditingController contentController = TextEditingController(); //服务费



  ///修改服务费
  Future<void> getCommunityDetail() async {
    if((0 < double.parse(contentController.text)) && double.parse(contentController.text)< 1000000){
      Loading.show();
      final response = await UserApi.updateUserCharge(
        serviceCharge: double.parse(contentController.text),
      );
      if(response.isSuccess){
        SS.login.setInfo((val) {
          val?.serviceCharge = double.parse(contentController.text);
        });
        Loading.showToast(S.current.modifySuccessfully);
        Loading.dismiss();
        Get.back();
      }else{
        Loading.dismiss();
        response.showErrorMessage();
      }
    }else{
      Loading.showToast(S.current.serviceBeyond);
    }
  }

}

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/extension/get_extension.dart';
import 'package:guanjia/common/extension/math_extension.dart';
import 'package:guanjia/common/network/api/im_api.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/common_utils.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/widgets/loading.dart';
import 'package:guanjia/widgets/payment_password_keyboard.dart';
import 'package:guanjia/widgets/widgets.dart';

import 'red_packet_state.dart';

class RedPacketController extends GetxController {
  final RedPacketState state = RedPacketState();

  final int userId;
  final amountEditingController = TextEditingController();
  final descEditingController = TextEditingController();

  RedPacketController({required this.userId});

  @override
  void onInit() {
    super.onInit();
    amountEditingController.bindTextRx(state.amountRx);
    descEditingController.bindTextRx(state.descRx);
    SS.appConfig.fetchData();
  }

  String get defaultDesc => S.current.theKnowsYou;

  Future<void> sendRedPacket() async {
    var amountText = state.amountRx();
    final amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) {
      Loading.showToast(S.current.theRedPacketThan0);
      return;
    }

    final maxAmount = SS.appConfig.redPacketMaxAmount;
    if (amount > maxAmount) {
      Loading.showToast('${S.current.theAmountGreaterThan}${maxAmount.toCurrencyString()}');
      return;
    }

    CommonUtils.hideSoftKeyboard();
    final password = await PaymentPasswordKeyboard.show();
    if (password == null) {
      return;
    }
    var desc = state.descRx();
    if (desc.trim().isEmpty) {
      desc = defaultDesc;
    }

    Loading.show();
    final response = await IMApi.sendRedEnvelopes(
      toUid: userId,
      amount: amount,
      message: desc,
      payPassword: password,
    );
    Loading.dismiss();
    if(response.isSuccess){
      Get.back();
    }else{
      response.showErrorMessage();
    }
  }
}

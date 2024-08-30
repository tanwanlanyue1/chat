import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/extension/get_extension.dart';
import 'package:guanjia/common/network/api/im_api.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/widgets/loading.dart';
import 'package:guanjia/widgets/payment_password_keyboard.dart';

import 'transfer_money_state.dart';

class TransferMoneyController extends GetxController {
  final TransferMoneyState state = TransferMoneyState();

  final int userId;
  final amountEditingController = TextEditingController();
  final focusNode = TextInputFocusNode()..ignoreSystemKeyboardShow = true;


  TransferMoneyController({required this.userId});

  @override
  void onInit() {
    super.onInit();
    amountEditingController.bindTextRx(state.amountRx);
    focusNode.requestFocus();
    SS.appConfig.fetchData();
  }

  Future<void> submit() async {
    final amount = double.tryParse(state.amountRx()) ?? 0;
    if (amount <= 0) {
      Loading.showToast('转账金额必须大于0');
      return;
    }

    final password = await PaymentPasswordKeyboard.show();
    if (password == null) {
      focusNode.requestFocus();
      return;
    }

    Loading.show();
    final response = await IMApi.transfer(
      toUid: userId,
      amount: amount,
      payPassword: password,
    );
    Loading.dismiss();
    if (response.isSuccess) {
      Get.back();
    } else {
      response.showErrorMessage();
    }
  }
}

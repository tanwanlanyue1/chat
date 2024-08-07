import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/extension/get_extension.dart';
import 'package:guanjia/common/utils/common_utils.dart';
import 'package:guanjia/ui/chat/custom/custom_message_type.dart';
import 'package:guanjia/ui/chat/custom/message_red_packet_content.dart';
import 'package:guanjia/widgets/loading.dart';
import 'package:guanjia/widgets/payment_password_keyboard.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

import 'red_packet_state.dart';

class RedPacketController extends GetxController {
  final RedPacketState state = RedPacketState();

  final String conversationId;
  final ZIMConversationType conversationType;
  final amountEditingController = TextEditingController();
  final descEditingController = TextEditingController();

  RedPacketController(
      {required this.conversationId, required this.conversationType});

  @override
  void onInit() {
    super.onInit();
    amountEditingController.bindTextRx(state.amountRx);
    descEditingController.bindTextRx(state.descRx);
  }

  Future<void> sendRedPacket() async {
    CommonUtils.hideSoftKeyboard();
    final password = await PaymentPasswordKeyboard.show();
    if(password == null){
      return;
    }
    if (password != '123456') {
      Loading.showToast('支付密码错误');
      return;
    }

    //TODO 调发红包接口，目前先客户端测试发送
    var amountText = state.amountRx();
    final amount = double.tryParse(amountText);
    if(amount == null || amount <= 0){
      Loading.showToast('红包金额不能低于0');
      return;
    }

    final content = MessageRedPacketContent(amount: amountText, desc: state.descRx(), status: 0);
    await ZIMKit().sendCustomMessage(
      conversationId,
      conversationType,
      customType: CustomMessageType.redPacket.value,
      customMessage: content.toJsonString(),
    );

    Loading.showToast('发送成功');
    Get.back();
  }
}

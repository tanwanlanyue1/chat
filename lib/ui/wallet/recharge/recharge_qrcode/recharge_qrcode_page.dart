import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/service/service.dart';

import 'recharge_qrcode_controller.dart';
import 'recharge_qrcode_state.dart';

///充值订单提交成功(充值二维码)
class RechargeQrcodePage extends StatelessWidget {
  final controller = Get.put(RechargeQrcodeController());
  final state = Get.find<RechargeQrcodeController>().state;

  @override
  Widget build(BuildContext context) {


    return Container();
  }
}

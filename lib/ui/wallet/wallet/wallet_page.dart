import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/widgets/app_image.dart';

import 'wallet_controller.dart';

class WalletPage extends StatelessWidget {
  WalletPage({super.key});

  final controller = Get.put(WalletController());
  final state = Get.find<WalletController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(S.current.myWallet),
        actions: [
          GestureDetector(
            onTap: controller.onTapOrder,
            child: Container(
              margin: EdgeInsets.only(right: 16.rpx),
              padding: EdgeInsets.symmetric(horizontal: 10.rpx),
              child: AppImage.asset(
                "assets/images/wallet/order.png",
                length: 24.rpx,
              ),
            ),
          ),
        ],
      ),
      body: Container(),
    );
  }
}

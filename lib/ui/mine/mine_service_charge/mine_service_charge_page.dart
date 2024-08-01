import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/widgets/button.dart';
import 'package:guanjia/widgets/input_widget.dart';

import 'mine_service_charge_controller.dart';

//我的-服务费
class MineServiceChargePage extends StatelessWidget {
  MineServiceChargePage({Key? key}) : super(key: key);

  final controller = Get.put(MineServiceChargeController());
  final state = Get.find<MineServiceChargeController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(S.current.modificationServiceCharge,style: TextStyle(color: const Color(0xff333333),fontSize: 18.rpx,),),
      ),
      backgroundColor: AppColor.scaffoldBackground,
      body: Column(
        children: [
          SizedBox(height: 36.rpx),
          Text(S.current.chargeService,style: AppTextStyle.fs16m.copyWith(color: AppColor.gray5),),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16.rpx).copyWith(top: 24.rpx),
            color: Colors.white,
            child: InputWidget(
              hintText: S.current.pleaseEnterService,
              lines: 1,
              fillColor: Colors.white,
              textAlign: TextAlign.center,
              // inputController: controller.contentController,
            ),
          ),
          Button(
            height: 50.rpx,
            onPressed: (){},
            margin: EdgeInsets.symmetric(horizontal: 38.rpx).copyWith(top: 60.rpx),
            child: Text(
              S.current.confirm,
              style: TextStyle(color: Colors.white, fontSize: 16.rpx),
            ),
          )
        ],
      ),
    );
  }
}

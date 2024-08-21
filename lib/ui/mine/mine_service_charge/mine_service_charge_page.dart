import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/service/service.dart';
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
      body: Column(
        children: [
          SizedBox(height: 36.rpx),
          Text(S.current.chargeService,style: AppTextStyle.fs16m.copyWith(color: AppColor.gray5),),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16.rpx).copyWith(top: 24.rpx),
            color: Colors.white,
            height: 50.rpx,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  height: 30.rpx,
                  child: InputWidget(
                    hintText: '${SS.login.info?.serviceCharge ?? S.current.pleaseEnterService}',
                    lines: 1,
                    fillColor: Colors.white,
                    textAlign: TextAlign.center,
                    // counterText: "数字1-999999",
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                    ],
                    inputController: controller.contentController,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 6.rpx),
                  child: Text("数字1-999999",style: AppTextStyle.fs10m.copyWith(color: AppColor.gray10),),
                ),
              ],
            ),
          ),
          Button(
            height: 50.rpx,
            onPressed: controller.getCommunityDetail,
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

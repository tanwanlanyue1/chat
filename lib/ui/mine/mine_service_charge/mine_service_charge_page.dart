import 'package:flutter/cupertino.dart';
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
          Container(
            margin: EdgeInsets.only(left: 16.rpx,top: 24.rpx,bottom: 16.rpx),
            alignment: Alignment.centerLeft,
            child: Text(S.current.chargeService,style: AppTextStyle.fs16b.copyWith(color: AppColor.black20),),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16.rpx),
            height: 50.rpx,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.rpx)
            ),
            child: InputWidget(
              hintText: '${SS.login.info?.serviceCharge ?? S.current.pleaseEnterService}',
              lines: 1,
              fillColor: Colors.white,
              textAlign: TextAlign.center,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp('[0-9]')),
              ],
              inputController: controller.contentController,
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            margin: EdgeInsets.only(right: 16.rpx,top: 12.rpx),
            child: Text("${S.current.figure}1-999999",style: AppTextStyle.fs12m.copyWith(color: AppColor.gray9),),
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

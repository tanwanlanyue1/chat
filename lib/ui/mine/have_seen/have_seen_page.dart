import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/iterable_extension.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/mine/widgets/client_card.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/button.dart';

import 'have_seen_controller.dart';

///谁看过我
class HaveSeenPage extends StatelessWidget {
  HaveSeenPage({Key? key}) : super(key: key);

  final controller = Get.put(HaveSeenController());
  final state = Get.find<HaveSeenController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.whoSeenMe),
      ),
      backgroundColor: AppColor.scaffoldBackground,
      body: Obx(() => Visibility(
        visible: !state.vip.value,
        replacement: buildClient(),
        child: buildNoVip(),
      )),
    );
  }

  //非VIP
  Widget buildNoVip(){
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(vertical: 36.rpx),
          child: AppImage.asset("assets/images/mine/warning.png",width: 120.rpx,height: 120.rpx,),
        ),
        Text("您还不是VIP，暂时无法使用该功能。\n点击下方按钮可立即充值",style: AppTextStyle.fs16m.copyWith(color: AppColor.gray5,height: 1.4),textAlign: TextAlign.center,),
        Button(
          onPressed: (){
            state.vip.value = true;
          },
          margin: EdgeInsets.all(37.rpx),
          child: Text("立即前往充值VIP",style: AppTextStyle.fs16m.copyWith(color: Colors.white),),
        )
      ],
    );
  }

  //客户列表
  Widget buildClient(){
    return Column(
      children: [
        SizedBox(height: 1.rpx),
        ...List.generate(5, (index) => ClientCard()),
      ],
    );
  }
}

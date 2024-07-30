import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/app_image.dart';

import 'mine_evaluate_controller.dart';
import 'widget/evaluate_card.dart';

//我的评价
class MineEvaluatePage extends StatelessWidget {
  MineEvaluatePage({Key? key}) : super(key: key);

  final controller = Get.put(MineEvaluateController());
  final state = Get.find<MineEvaluateController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("我的评价",style: AppTextStyle.fs18m.copyWith(color: AppColor.gray5),),
      ),
      backgroundColor: AppColor.grayF7,
      body: ListView(
        padding: EdgeInsets.only(top: 1.rpx),
        children: List.generate(4, (index) => EvaluateCard(index: index,)),
      ),
    );
  }

}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/widgets/app_image.dart';

import '../mine_evaluate/widget/evaluate_card.dart';
import 'mine_team_evaluate_controller.dart';

//我的-团队评价
class MineTeamEvaluatePage extends StatelessWidget {
  MineTeamEvaluatePage({Key? key}) : super(key: key);

  final controller = Get.put(MineTeamEvaluateController());
  final state = Get.find<MineTeamEvaluateController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.teamEvaluation),
      ),
      backgroundColor: AppColor.scaffoldBackground,
      body: Column(
        children: [
          overallMerit(),
          ... List.generate(2, (index) => EvaluateCard(
            index: index,
            team: true,
            margin: EdgeInsets.only(bottom: 1.rpx),
          )),
        ],
      ),
    );
  }

  //总评价
  Widget overallMerit(){
    return Container(
      height: 56.rpx,
      color: Colors.white,
      margin: EdgeInsets.only(top: 1.rpx,bottom: 8.rpx),
      padding: EdgeInsets.only(left: 16.rpx),
      child: Row(
        children: [
          Text(S.current.overallMerit,style: AppTextStyle.fs16m.copyWith(color: AppColor.gray5),),
          SizedBox(width: 12.rpx,),
          Row(
            children: List.generate(5, (i) => Container(
              margin: EdgeInsets.only(right: 16.rpx),
              child: AppImage.asset(
                width: 24.rpx,
                height: 24.rpx,
                i == 4 ?
                'assets/images/mine/star_none.png':
                'assets/images/mine/star.png',
              ),
            )),
          ),
          Text("4.0${S.current.minute}",style: AppTextStyle.fs14m.copyWith(color: AppColor.primary),),
        ],
      ),
    );
  }
}

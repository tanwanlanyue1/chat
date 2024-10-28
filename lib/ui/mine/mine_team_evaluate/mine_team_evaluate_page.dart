import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/paging/default_paged_child_builder_delegate.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../common/network/api/api.dart';
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
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                offset: const Offset(0, 4),
                blurRadius: 8,
              ),
            ],
          ),
        ),
      ),
      backgroundColor: AppColor.grayF7,
      body: SmartRefresher(
          controller: controller.pagingController.refreshController,
          onRefresh: controller.pagingController.onRefresh,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                  child: overallMerit()
              ),
              PagedSliverList(
                pagingController: controller.pagingController,
                builderDelegate: DefaultPagedChildBuilderDelegate<EvaluationItemModel>(
                  pagingController: controller.pagingController,
                  itemBuilder: (_, item, index) {
                    return EvaluateCard(
                      index: index,
                      item: item,
                      team: true,
                      margin: EdgeInsets.only(bottom: 1.rpx),
                    );
                  },
                ),
              ),
            ],
          )
      ),
    );
  }

  //总评价
  Widget overallMerit(){
    return GetBuilder<MineTeamEvaluateController>(
      id: "overallMerit",
      builder: (_) {
      return Container(
        height: 56.rpx,
        color: Colors.white,
        margin: EdgeInsets.only(top: 1.rpx,bottom: 8.rpx),
        padding: EdgeInsets.only(left: 16.rpx),
        child: Row(
          children: [
            Text(S.current.overallMerit,style: AppTextStyle.fs16.copyWith(color: AppColor.gray5),),
            SizedBox(width: 12.rpx,),
            Row(
              children: List.generate(5, (i) => Container(
                margin: EdgeInsets.only(right: 16.rpx),
                child: AppImage.asset(
                  width: 24.rpx,
                  height: 24.rpx,
                  i < (state.evaluation?.totalScore ?? 0) ?
                  'assets/images/mine/star.png':
                  'assets/images/mine/star_none.png',
                ),
              )),
            ),
            Visibility(
              visible: (state.evaluation?.totalScore ?? 0) > 0,
              child: Text("${state.evaluation?.totalScore ?? 0}.0${S.current.minute}",style: AppTextStyle.fs14m.copyWith(color: AppColor.gradientBegin),),
            ),
          ],
        ),
      );
    },);
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/paging/default_paged_child_builder_delegate.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../common/network/api/api.dart';
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
        title: Text(S.current.myAssessment,style: AppTextStyle.fs18m.copyWith(color: AppColor.gray5),),
      ),
      backgroundColor: AppColor.white8,
      body: SmartRefresher(
        controller: controller.pagingController.refreshController,
        onRefresh: controller.pagingController.onRefresh,
        child: PagedListView(
          pagingController: controller.pagingController,
          builderDelegate: DefaultPagedChildBuilderDelegate<EvaluationItemModel>(
            pagingController: controller.pagingController,
            itemBuilder: (_, item, index) {
              return EvaluateCard(
                index: index,
                item: item,
                margin: EdgeInsets.only(top: 1.rpx,bottom: 7.rpx),
              );
            },
          ),
        ),
      ),
    );
  }

}

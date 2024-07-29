import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/network/api/model/wish_pavilion/cultivation_ranking_model.dart';
import 'package:guanjia/common/paging/default_paged_child_builder_delegate.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/widgets.dart';

import '../widgets/merit_ranking_list_tile.dart';
import '../widgets/self_ranking_tile.dart';
import 'merit_ranking_controller.dart';

///功德排行
class MeritRankingView extends StatelessWidget {
  final controller = Get.put(MeritRankingController());
  final state = Get.find<MeritRankingController>().state;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            margin: FEdgeInsets(horizontal: 12.5.rpx),
            color: AppColor.gray13,
            child: Column(
              children: [
                buildTableHeader(),
                Expanded(child: buildListView()),
              ],
            ),
          ),
        ),
        ObxValue((dataRx) {
          final data = dataRx();
          if (data == null) {
            return Spacing.blank;
          }
          return SelfRankingTile(item: data);
        }, state.selfRankingRx)
      ],
    );
  }

  Widget buildTableHeader() {
    return Padding(
      padding: FEdgeInsets(horizontal: 20.rpx, vertical: 8.rpx),
      child: DefaultTextStyle(
        style: AppTextStyle.fs14m.copyWith(color: AppColor.gray9),
        child: Row(
          children: [
            Text('排名'),
            Expanded(
              child: Padding(
                padding: FEdgeInsets(left: 65.rpx),
                child: Text('账号信息'),
              ),
            ),
            Text('功德'),
          ],
        ),
      ),
    );
  }

  Widget buildListView() {
    return PagedListView.separated(
      padding: FEdgeInsets(horizontal: 8.rpx, vertical: 12.rpx),
      pagingController: controller.pagingController,
      separatorBuilder: (_, index) => Spacing.h(10),
      builderDelegate:
          DefaultPagedChildBuilderDelegate<CultivationRankingModel>(
              pagingController: controller.pagingController,
              itemBuilder: (_, item, index) {
                return MeritRankingListTile(item: item, type: 0);
              }),
    );
  }
}

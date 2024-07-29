import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/network/api/model/wish_pavilion/cultivation_ranking_model.dart';
import 'package:guanjia/common/paging/default_paged_child_builder_delegate.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/wish_pavilion/zen_room/merit_cultivation_ranking/widgets/merit_ranking_list_tile.dart';
import 'package:guanjia/ui/wish_pavilion/zen_room/merit_cultivation_ranking/widgets/self_ranking_tile.dart';
import 'package:guanjia/widgets/edge_insets.dart';
import 'package:guanjia/widgets/spacing.dart';
import 'package:collection/collection.dart';
import 'package:guanjia/widgets/widgets.dart';

import 'cultivation_ranking_controller.dart';

///修行排行
class CultivationRankingView extends StatelessWidget {

  List<String> get tabs => <String>[
    '累积榜',
    '连修榜',
    '上香',
    '供礼',
    '敲诵',
    '念珠',
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Column(
        children: [
          buildTabBar(),
          Expanded(child: buildTabBarView()),
        ],
      ),
    );
  }

  Widget buildTabBar() {
    return Container(
      width: double.infinity,
      margin: FEdgeInsets(horizontal: 12.5.rpx),
      color: AppColor.gray13,
      child: TabBar(
        isScrollable: true,
        unselectedLabelStyle: AppTextStyle.fs14m,
        unselectedLabelColor: AppColor.gray5,
        labelStyle: AppTextStyle.fs14b,
        labelColor: AppColor.primary,
        labelPadding: FEdgeInsets(horizontal: 12.rpx),
        indicator: TabUnderlineIndicator(
          width: 20.rpx,
          widthEqualTitle: false,
          borderSide: BorderSide(width: 4.rpx, color: AppColor.primary),
        ),
        tabs: tabs.map((e){
          return Tab(text: e, height: 30.rpx);
        }).toList(),
      ),
    );
  }

  Widget buildTabBarView() {
    return TabBarView(
      children: tabs.mapIndexed((index, element){
        return _CultivationRankingTabBarView(type: index + 1);
      }).toList(),
    );
  }
}

class _CultivationRankingTabBarView extends StatefulWidget {
  ///type 0=功德值排行 1=累计修行天数排行 2=连续修行排行 3=上香 4=供礼 5=敲诵 6=念珠
  final int type;
  const _CultivationRankingTabBarView({super.key, required this.type});

  @override
  State<_CultivationRankingTabBarView> createState() => _CultivationRankingTabBarViewState();
}

class _CultivationRankingTabBarViewState extends State<_CultivationRankingTabBarView> with AutomaticKeepAliveClientMixin {


  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GetBuilder<CultivationRankingController>(
      init: CultivationRankingController(widget.type),
      tag: 'CultivationRanking${widget.type}',
      builder: (controller) {
        return Column(
          children: [
            Expanded(
              child: Container(
                margin: FEdgeInsets(horizontal: 12.5.rpx),
                color: AppColor.gray13,
                child: buildListView(controller),
              ),
            ),
            ObxValue((dataRx) {
              final data = dataRx();
              if (data == null) {
                return Spacing.blank;
              }
              return SelfRankingTile(item: data, unit: [1,2].contains(widget.type) ? '天' : '');
            }, controller.state.selfRankingRx)
          ],
        );
      },
    );
  }

  Widget buildListView(CultivationRankingController controller) {
    return PagedListView.separated(
      padding: FEdgeInsets(horizontal: 8.rpx, vertical: 12.rpx),
      pagingController: controller.pagingController,
      separatorBuilder: (_, index) => Spacing.h(10),
      builderDelegate:
          DefaultPagedChildBuilderDelegate<CultivationRankingModel>(
              pagingController: controller.pagingController,
              itemBuilder: (_, item, index) {
                return MeritRankingListTile(item: item, type: widget.type);
              }),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

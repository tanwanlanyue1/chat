import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/text_style_extension.dart';
import 'package:guanjia/common/network/api/model/wish_pavilion/cultivation_record_model.dart';
import 'package:guanjia/common/paging/default_paged_child_builder_delegate.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/widgets.dart';

import 'practice_detail_controller.dart';
import 'widgets/practice_record_list_tile.dart';

///修行详情
class PracticeDetailPage extends StatelessWidget {
  PracticeDetailPage({super.key});

  final controller = Get.put(PracticeDetailController());
  final state = Get.find<PracticeDetailController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColor.scaffoldBackground,
      appBar: AppBar(
        title: const Text('修行详情'),
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          AppImage.asset(
            'assets/images/wish_pavilion/zen_room/practice_detail_top_bg.png',
            height: 80.rpx + Get.mediaQuery.padding.top + kToolbarHeight,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          SafeArea(
            child: Column(
              children: [
                buildHeader(),
                buildDate(),
                buildContent(),
                buildBottom(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildHeader() {
    return Obx(() {
      final stats = state.cultivationStatsRx();
      return Container(
        height: 80.rpx,
        margin: EdgeInsets.symmetric(horizontal: 12.rpx),
        child: Row(
          children: [
            AppImage.network(
              shape: BoxShape.circle,
              width: 58.rpx,
              height: 58.rpx,
              stats?.avatar ?? '',
              placeholder: const CircleAvatar(
                backgroundColor: Colors.transparent,
                backgroundImage:
                    AppAssetImage('assets/images/mine/mine_head_default.png'),
                foregroundImage:
                    AppAssetImage('assets/images/wish_pavilion/拜@3x.png'),
              ),
            ),
            SizedBox(width: 8.rpx),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stats?.userName ?? '',
                    style: AppTextStyle.st.bold
                        .size(16.rpx)
                        .textColor(AppColor.gray5),
                  ),
                  SizedBox(height: 4.rpx),
                  Row(
                    children: [
                      Text.rich(
                        TextSpan(
                          text: '已坚持连续修行',
                          children: [
                            TextSpan(
                              text: (stats?.currentMavDay ?? 0).toString(),
                              style: AppTextStyle.st.bold
                                  .size(22.rpx)
                                  .textColor(const Color(0xFF8D310F)),
                            ),
                            const TextSpan(text: '天'),
                          ],
                        ),
                        style: AppTextStyle.st.medium
                            .size(14.rpx)
                            .textColor(AppColor.gray5),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20.rpx),
                        child: Text.rich(
                          TextSpan(
                            text: '累积修行',
                            children: [
                              TextSpan(
                                text: (stats?.mavDay ?? 0).toString(),
                                style: AppTextStyle.st.bold
                                    .size(22.rpx)
                                    .textColor(const Color(0xFF8D310F)),
                              ),
                              const TextSpan(text: '天'),
                            ],
                          ),
                          style: AppTextStyle.st.medium
                              .size(14.rpx)
                              .textColor(AppColor.gray5),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget buildDate() {
    return Container(
      height: 60.rpx,
      padding: EdgeInsets.only(left: 12.rpx),
      decoration: BoxDecoration(
          image: AppDecorations.backgroundImage(
              'assets/images/wish_pavilion/zen_room/practice_detail_date_bg.png')),
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Text(
            state.day,
            style: AppTextStyle.st.bold
                .size(40.rpx)
                .textColor(const Color(0x80333333)),
          ),
          SizedBox(width: 8.rpx),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                state.week,
                style: AppTextStyle.st.medium
                    .size(14.rpx)
                    .textColor(const Color(0xFF666666)),
              ),
              Padding(
                padding: EdgeInsets.only(top: 4.rpx),
                child: Text(
                  state.yearAndMonth,
                  style: AppTextStyle.st.medium
                      .textHeight(1.001)
                      .size(14.rpx)
                      .textColor(const Color(0xFF666666)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Expanded buildContent() {
    final pagingController = controller.pagingController;
    final textStyle =
        AppTextStyle.st.medium.size(14.rpx).textColor(AppColor.gray5);
    return Expanded(
      child: Obx(() {
        return Container(
          color: Colors.white,
          child: Column(
            children: [
              Padding(
                padding: FEdgeInsets(vertical: 12.rpx),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(state.dateItems.length, (index) {
                    var item = state.dateItems[index];
                    var isSelect = state.selectedItemRx.value == item;

                    var textColor = AppColor.gray5;
                    if(isSelect){
                      textColor = Colors.white;
                    }else if(item.isToday){
                      textColor = AppColor.primary;
                    }else if(item.isFuture){
                      textColor = AppColor.gray9;
                    }

                    return GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: item.isFuture ? null : () => controller.onChangeDate(item),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            item.weekDay,
                            style: textStyle
                                .size(12.rpx)
                                .textColor(AppColor.gray9),
                          ),
                          Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              Container(
                                margin: FEdgeInsets(top: 4.rpx),
                                width: 36.rpx,
                                height: 36.rpx,
                                alignment: Alignment.center,
                                decoration: isSelect
                                    ? const BoxDecoration(
                                        color: Color(0xFF8D310F),
                                        shape: BoxShape.circle,
                                      )
                                    : null,
                                child: Text(
                                  item.day.toString(),
                                  style: textStyle.size(16.rpx).textColor(textColor),
                                ),
                              ),
                              if (item.isToday)
                                Container(
                                  width: 4.rpx,
                                  height: 4.rpx,
                                  decoration: ShapeDecoration(
                                    shape: const CircleBorder(),
                                    color: isSelect
                                        ? Colors.white
                                        : AppColor.primary,
                                  ),
                                ),
                            ],
                          )
                        ],
                      ),
                    );
                  }),
                ),
              ),
              Expanded(
                child: PagedListView(
                  pagingController: pagingController,
                  builderDelegate:
                      DefaultPagedChildBuilderDelegate<CultivationRecordModel>(
                          pagingController: pagingController,
                          itemBuilder: (_, item, index) {
                            return PracticeRecordListTile(item: item);
                          }),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  /// 底部
  Widget buildBottom() {
    Widget buildItem(
        {required String text, required String value, VoidCallback? onTap}) {
      return Flexible(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            height: 60.rpx,
            padding: EdgeInsets.symmetric(horizontal: 10.rpx),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.rpx),
              color: Colors.white,
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      text,
                      style: AppTextStyle.st.medium
                          .size(12.rpx)
                          .textColor(AppColor.gray5),
                    ),
                    AppImage.asset(
                      'assets/images/mine/mine_right_arrow.png',
                      width: 10.rpx,
                      height: 10.rpx,
                    ),
                  ],
                ),
                Spacing.h4,
                Text.rich(
                  style: AppTextStyle.st.bold
                      .size(16.rpx)
                      .textColor(const Color(0xFF8D310F)),
                  TextSpan(
                    text: value,
                    children: [
                      TextSpan(
                          text: '次',
                          style: AppTextStyle.st.medium
                              .size(12.rpx)
                              .textColor(AppColor.gray9)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      margin: EdgeInsets.all(12.rpx),
      child: Obx(() {
        final stats = state.cultivationStatsRx();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 12.rpx),
              child: Text(
                '每日修行功课',
                style:
                    AppTextStyle.st.bold.size(16.rpx).textColor(AppColor.gray5),
              ),
            ),
            Row(
              children: [
                buildItem(
                  text: '上香顶礼',
                  value: (stats?.prayCount ?? 0).toString(),
                  onTap: () => controller.onTapOfferIncenseDetail(),
                ),
                SizedBox(width: 10.rpx),
                buildItem(
                  text: '供品顶礼',
                  value: (stats?.tributeCount ?? 0).toString(),
                  onTap: () => controller.onTapTributeDetailPage(),
                ),
                SizedBox(width: 10.rpx),
                buildItem(
                  text: '木鱼诵经',
                  value: (stats?.scripturesCount ?? 0).toString(),
                  onTap: () => controller.onTapWoodenFishDetail(),
                ),
                SizedBox(width: 10.rpx),
                buildItem(
                  text: '念珠',
                  value: (stats?.beadsCount ?? 0).toString(),
                  onTap: () => controller.onTapRosaryBeadsDetail(),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }
}

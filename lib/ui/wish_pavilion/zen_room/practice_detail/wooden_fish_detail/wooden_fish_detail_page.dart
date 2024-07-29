import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/math_extension.dart';
import 'package:guanjia/common/extension/string_extension.dart';
import 'package:guanjia/common/extension/text_style_extension.dart';
import 'package:guanjia/common/network/api/model/wish_pavilion/WoodenFishRecordModel.dart';
import 'package:guanjia/common/paging/default_paged_child_builder_delegate.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/wish_pavilion/zen_room/buddhist_sutras_list/widgets/buddhist_sutras_cover.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/widgets.dart';

import 'wooden_fish_detail_controller.dart';

///木鱼诵经
class WoodenFishDetailPage extends StatelessWidget {
  WoodenFishDetailPage({Key? key}) : super(key: key);

  final controller = Get.put(WoodenFishDetailController());
  final state = Get.find<WoodenFishDetailController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('木鱼诵经'),
      ),
      body: Obx(() {
        final records = state.recordRx();
        return CustomScrollView(
          slivers: [
            if (records?.count.isNotEmpty == true)
              buildStats(records?.count ?? []),
            SliverToBoxAdapter(
              child: Padding(
                padding: FEdgeInsets(all: 12.rpx, top: 20.rpx),
                child: Text(
                  '诵经记录',
                  style: AppTextStyle.fs16b.copyWith(color: AppColor.gray5),
                ),
              ),
            ),
            buildRecords(),
          ],
        );
      }),
    );
  }

  Widget buildStats(List<SutrasStatsItem> list) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final item = list[index];
          return Container(
            padding: FEdgeInsets(
              all: 12.rpx,
              right: 20.rpx,
              top: index == 0 ? 12.rpx : 5.rpx,
              bottom: index == list.length - 1 ? 12.rpx : 5.rpx,
            ),
            color: Colors.white,
            child: Row(
              children: [
                AppImage.asset(
                  'assets/images/wish_pavilion/ic_practice_record.png',
                  width: 24.rpx,
                  height: 24.rpx,
                ),
                Expanded(
                  child: Padding(
                    padding: FEdgeInsets(horizontal: 8.rpx),
                    child: Text(
                      '诵念：${item.giftName}',
                      style: AppTextStyle.fs14m.copyWith(
                        color: AppColor.gray5,
                      ),
                    ),
                  ),
                ),
                Text(
                  '${item.count}遍',
                  style: AppTextStyle.fs14m.copyWith(
                    color: AppColor.gray9,
                  ),
                ),
              ],
            ),
          );
        },
        childCount: list.length,
      ),
    );
  }

  Widget buildRecords() {
    return PagedSliverList.separated(
      pagingController: controller.pagingController,
      builderDelegate: DefaultPagedChildBuilderDelegate<WoodenFishRecordItem>(
          pagingController: controller.pagingController,
          itemBuilder: (_, item, index) {
            final textStyle = AppTextStyle.st.medium.size(14.rpx);
            return Container(
              height: 106.rpx,
              padding: EdgeInsets.all(12.rpx),
              color: Colors.white,
              child: Row(
                children: [
                  Padding(
                    padding: FEdgeInsets(right: 12.rpx),
                    child: BuddhistSutrasCover(
                      width: 58.rpx,
                      height: 82.rpx,
                      name: item.name,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '诵念《${item.name}》',
                          style: textStyle.textColor(AppColor.gray5),
                        ),
                        Text(
                          '法器敲击：${item.count}',
                          style: textStyle.textColor(AppColor.gray5),
                        ),
                        Text(
                          '今日诵念此经：${item.number}遍',
                          style:
                              textStyle.size(13.rpx).textColor(AppColor.gray9),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.rpx),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 16.rpx),
                        child: Text.rich(
                          style: textStyle.textColor(AppColor.gray9),
                          TextSpan(
                            text: '完成 ',
                            children: [
                              TextSpan(
                                text: '${item.completionRate.toStringAsTrimZero()}%',
                                style: AppTextStyle.st.bold
                                    .size(18.rpx)
                                    .textColor(const Color(0xFF8D310F)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Text(
                        item.durationText,
                        style: textStyle.textColor(AppColor.gray9),
                      ),
                    ],
                  ),
                  SizedBox(width: 8.rpx),
                ],
              ),
            );
          }),
      separatorBuilder: (_, __) => SizedBox(height: 1.rpx),
    );
  }
}

extension on WoodenFishRecordItem {
  ///持续时间
  String get durationText {
    final startDate = startTime.dateTime;
    final endDate = endTime.dateTime;
    if (startDate == null || endDate == null) {
      return '';
    }
    final diff = endDate.difference(startDate);

    String fmt(int value) {
      return value.toString().padLeft(2, '0');
    }

    final days = diff.inDays;
    final hours = diff.inHours;
    final minutes = diff.inMinutes;
    final seconds = diff.inSeconds;

    var text = '';
    if (days > 0) {
      text = '$days天 ';
    }
    if (hours > 0) {
      text += '${fmt(hours % 24)}:';
    }
    if (minutes > 0 || seconds > 0) {
      text += '${fmt(minutes % 60)}:';
    }
    if (seconds > 0) {
      text += fmt(seconds % 60);
    }
    return text;
  }
}

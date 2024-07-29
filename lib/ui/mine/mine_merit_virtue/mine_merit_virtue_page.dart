import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pickers/pickers.dart';
import 'package:flutter_pickers/style/picker_style.dart';
import 'package:flutter_pickers/time_picker/model/date_mode.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/string_extension.dart';
import 'package:guanjia/common/extension/text_style_extension.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/paging/default_paged_child_builder_delegate.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'mine_merit_virtue_controller.dart';

/// 功德
class MineMeritVirtuePage extends StatelessWidget {
  MineMeritVirtuePage({Key? key}) : super(key: key);

  final controller = Get.put(MineMeritVirtueController());
  final state = Get.find<MineMeritVirtueController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("修功业行善德"),
        backgroundColor: Colors.transparent,
        actions: [
          GestureDetector(
            onTap: controller.onTapRanking,
            child: Container(
              margin: EdgeInsets.only(right: 16.rpx),
              alignment: Alignment.center,
              child: Text(
                "功德榜",
                style: AppTextStyle.st.regular
                    .size(14.rpx)
                    .textColor(AppColor.gray5),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x78FFEBDB),
                    Color(0xFFF6F8FE),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppImage.asset("assets/images/mine/merit_virtue_bg.png"),
          ),
          Positioned.fill(
            child: Column(
              children: [
                _buildHeader(),
                _buildDateSelect(context),
                Expanded(
                  child: PagedListView(
                    padding: EdgeInsets.zero,
                    pagingController: controller.pagingController,
                    builderDelegate:
                        DefaultPagedChildBuilderDelegate<MeritVirtueLog>(
                      pagingController: controller.pagingController,
                      itemBuilder: (_, item, index) {
                        return _buildItem(item, index);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Column _buildItem(MeritVirtueLog item, int index) {
    final image = state.logTypeIconMap[item.logType] ?? item.image;
    return Column(
      children: [
        Container(
          height: 60.rpx,
          margin: EdgeInsets.symmetric(horizontal: 12.rpx),
          padding: EdgeInsets.symmetric(horizontal: 12.rpx),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.rpx),
          ),
          child: Row(
            children: [
              AppImage.network(
                image,
                width: 42.rpx,
                height: 42.rpx,
                fit: BoxFit.contain,
              ),
              SizedBox(width: 8.rpx),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.giftName,
                            maxLines: 1,
                            style: AppTextStyle.st
                                .size(14.rpx)
                                .textColor(AppColor.gray5),
                          ),
                        ),
                        SizedBox(width: 8.rpx),
                        Text(
                          '+${item.amount}',
                          style: AppTextStyle.st
                              .size(18.rpx)
                              .textColor(AppColor.primary),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.rpx),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.extraName,
                            maxLines: 1,
                            style: AppTextStyle.st
                                .size(12.rpx)
                                .textColor(AppColor.gray9),
                          ),
                        ),
                        SizedBox(width: 8.rpx),
                        Text(
                          DateUtil.formatDate(item.createTime.dateTime,
                              format: 'MM-dd HH:mm'),
                          style: AppTextStyle.st
                              .size(12.rpx)
                              .textColor(AppColor.gray9),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
            height: index == controller.pagingController.length - 1
                ? 10.rpx + Get.mediaQuery.padding.bottom
                : 10.rpx),
      ],
    );
  }

  Widget _buildDateSelect(BuildContext context) {
    return Obx(() {
      return Container(
        margin:
            EdgeInsets.symmetric(horizontal: 12.rpx).copyWith(bottom: 12.rpx),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                Pickers.showDatePicker(
                  context,
                  onConfirm: (val) {
                    if (val.year == null || val.month == null) return;
                    controller.selectDate(val.year!, val.month!);
                  },
                  mode: DateMode.YM,
                  pickerStyle: PickerStyle(
                    pickerTitleHeight: 65.rpx,
                    commitButton: Padding(
                      padding: EdgeInsets.only(right: 12.rpx),
                      child: Text(
                        "完成",
                        style: TextStyle(
                            fontSize: 14.rpx, color: const Color(0xff8D310F)),
                      ),
                    ),
                    cancelButton: Padding(
                      padding: EdgeInsets.only(left: 12.rpx),
                      child: AppImage.asset(
                        "assets/images/disambiguation/close.png",
                        width: 24.rpx,
                        height: 24.rpx,
                      ),
                    ),
                    headDecoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.rpx),
                        topRight: Radius.circular(20.rpx),
                      ),
                    ),
                  ),
                );
              },
              child: Container(
                alignment: Alignment.center,
                child: Wrap(
                  spacing: 1.rpx,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      state.dateString.value,
                      style: TextStyle(
                        color: const Color(0xFF333333),
                        fontSize: 14.rpx,
                      ),
                    ),
                    AppImage.asset("assets/images/mine/mine_arrow_down.png",
                        width: 16.rpx, height: 12.rpx),
                  ],
                ),
              ),
            ),
            Text.rich(
              TextSpan(
                text: "本月累计:",
                children: [
                  TextSpan(
                    text: "${state.monthMav}",
                    style:
                        AppTextStyle.st.size(14.rpx).textColor(AppColor.gray5),
                  ),
                ],
              ),
              style: AppTextStyle.st.size(14.rpx).textColor(AppColor.gray9),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildHeader() {
    return Obx(() {
      final levelMoneyInfo = controller.loginService.levelMoneyInfo;
      final mavLevelName = levelMoneyInfo?.mavLevelName ?? "";
      final nextMavLevelName = levelMoneyInfo?.nextMavLevelName ?? "";
      final currentExp = levelMoneyInfo?.mavExp ?? 0;
      final diffExp = levelMoneyInfo?.mavExpDiff ?? 0;
      final totalExp = currentExp + diffExp;

      return SafeArea(
        bottom: false,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 12.rpx)
              .copyWith(top: 12.rpx, bottom: 20.rpx),
          decoration: BoxDecoration(
            color: const Color(0xFFFFDBC4),
            borderRadius: BorderRadius.circular(12.rpx),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 72.rpx,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "我的功德",
                            style: AppTextStyle.st
                                .size(16.rpx)
                                .textColor(Colors.black),
                          ),
                          SizedBox(height: 8.rpx),
                          Visibility(
                            visible: mavLevelName.isNotEmpty,
                            replacement: SizedBox(height: 18.rpx),
                            child: Container(
                              height: 18.rpx,
                              padding: EdgeInsets.symmetric(horizontal: 8.rpx),
                              decoration: BoxDecoration(
                                color: const Color(0xFF49914E),
                                borderRadius: BorderRadius.circular(9.rpx),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    mavLevelName,
                                    style: AppTextStyle.st
                                        .size(10.rpx)
                                        .textColor(Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    VerticalDivider(
                      color: Colors.white,
                      width: 1,
                      thickness: 1,
                      indent: 20.rpx,
                      endIndent: 12.rpx,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "今日功德",
                            style: AppTextStyle.st
                                .size(16.rpx)
                                .textColor(Colors.black),
                          ),
                          SizedBox(height: 2.rpx),
                          Text(
                            "${state.todayMav.value ?? 0}",
                            style: AppTextStyle.st.bold
                                .size(20.rpx)
                                .textColor(AppColor.primary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                "$currentExp / $totalExp",
                style:
                    AppTextStyle.st.bold.size(16.rpx).textColor(AppColor.gray5),
              ),
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 12.rpx, vertical: 8.rpx),
                width: double.infinity,
                child: Stack(
                  children: [
                    // 背景
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: const Color(0x268D310F),
                          borderRadius: BorderRadius.circular(5.rpx),
                        ),
                      ),
                    ),
                    // 进度
                    Align(
                      alignment: Alignment.centerLeft,
                      child: LayoutBuilder(
                        builder: (_, constraints) {
                          final width = constraints.maxWidth * 1 / 2;
                          return Container(
                            width: width,
                            height: 10.rpx,
                            decoration: BoxDecoration(
                              color: AppColor.primary,
                              borderRadius: BorderRadius.circular(5.rpx),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 12.rpx),
                    child: Text.rich(
                      TextSpan(
                        text: "距$nextMavLevelName 还需",
                        children: [
                          TextSpan(
                            text: diffExp.toString(),
                            style: AppTextStyle.st
                                .size(12.rpx)
                                .textColor(AppColor.primary),
                          ),
                          const TextSpan(text: "功德"),
                        ],
                      ),
                      style: AppTextStyle.st
                          .size(12.rpx)
                          .textColor(AppColor.gray9),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.rpx),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   children: [
              //     GestureDetector(
              //       onTap: controller.onTapMore,
              //       child: Container(
              //         padding: EdgeInsets.symmetric(
              //             horizontal: 7.rpx, vertical: 5.rpx),
              //         alignment: Alignment.center,
              //         decoration: BoxDecoration(
              //           color: const Color(0xFF684326),
              //           borderRadius: BorderRadius.only(
              //             topLeft: Radius.circular(12.rpx),
              //             bottomRight: Radius.circular(12.rpx),
              //           ),
              //         ),
              //         child: Text(
              //           "获取更多",
              //           style: AppTextStyle.st.size(10).textColor(Colors.white),
              //         ),
              //       ),
              //     )
              //   ],
              // ),
            ],
          ),
        ),
      );
    });
  }
}

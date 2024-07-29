import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/app_back_button.dart';
import 'package:guanjia/widgets/app_image.dart';

import 'mine_mission_center_controller.dart';

class MineMissionCenterPage extends StatelessWidget {
  MineMissionCenterPage({Key? key}) : super(key: key);

  final controller = Get.put(MineMissionCenterController());
  final state = Get.find<MineMissionCenterController>().state;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFEF7F2),
      child: Stack(
        children: [
          AppImage.asset(
            "assets/images/mine/mission_center_bg.png",
            height: Get.mediaQuery.padding.top + 134.rpx,
          ),
          Column(
            children: [
              _navWidget(),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 12.rpx),
                  physics: const ClampingScrollPhysics(),
                  children: [
                    Container(
                      height: 80.rpx,
                      margin: EdgeInsets.only(top: 10.rpx),
                      decoration: BoxDecoration(
                        image: AppDecorations.backgroundImage(
                          "assets/images/mine/mission_center_signIn_bg.png",
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 14.rpx),
                            child: Text(
                              "连续签到领积分",
                              style: TextStyle(
                                color: const Color(0xFF333333),
                                fontSize: 20.rpx,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 25.rpx),
                            child: GestureDetector(
                              onTap: () => controller.onTapRewardPoints(),
                              behavior: HitTestBehavior.opaque,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "2500",
                                    style: TextStyle(
                                      color: const Color(0xFF333333),
                                      fontSize: 28.rpx,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  SizedBox(height: 6.rpx),
                                  Text(
                                    "我的积分",
                                    style: TextStyle(
                                      color: const Color(0xFF666666),
                                      fontSize: 14.rpx,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 146.rpx,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(12.rpx),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                  left: 12.rpx,
                                  top: 11.rpx,
                                  bottom: 12.rpx,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      "已连续签到",
                                      style: TextStyle(
                                        color: const Color(0xFF333333),
                                        fontSize: 14.rpx,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 4.rpx),
                                      padding: EdgeInsets.all(2.rpx),
                                      decoration: BoxDecoration(
                                        color: const Color(0x268D310F),
                                        borderRadius:
                                            BorderRadius.circular(2.rpx),
                                      ),
                                      child: Text(
                                        "2",
                                        style: TextStyle(
                                          color: const Color(0xFF8D310F),
                                          fontSize: 18.rpx,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "天",
                                      style: TextStyle(
                                        color: const Color(0xFF333333),
                                        fontSize: 14.rpx,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 6.rpx),
                                padding: EdgeInsets.symmetric(vertical: 4.rpx)
                                    .copyWith(left: 6.rpx, right: 12.rpx),
                                decoration: BoxDecoration(
                                  color: const Color(0x268D310F),
                                  borderRadius: BorderRadius.horizontal(
                                    left: Radius.circular(8.rpx),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    AppImage.asset(
                                      "assets/images/mine/mine_replacement_card20.png",
                                      width: 20.rpx,
                                      height: 20.rpx,
                                    ),
                                    SizedBox(width: 4.rpx),
                                    Text(
                                      "补签卡2张",
                                      style: TextStyle(
                                        color: const Color(0xFF8D310F),
                                        fontSize: 12.rpx,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          _signInWidget(),
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "签到日历",
                                    style: TextStyle(
                                      color: const Color(0xFF333333),
                                      fontSize: 12.rpx,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  AppImage.asset(
                                    "assets/images/mine/mission_center_right.png",
                                    width: 10.rpx,
                                    height: 10.rpx,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: 10.rpx,
                          bottom: Get.mediaQuery.padding.bottom + 10.rpx),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.rpx),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.all(12.rpx),
                            child: Text(
                              "做任务赚积分",
                              style: TextStyle(
                                color: const Color(0xFF333333),
                                fontSize: 16.rpx,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          _earnPointsWidget(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container _signInWidget() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.rpx),
      child: Row(
        children: [
          for (int index = 0; index < 7; index++) ...[
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF9EA),
                  border: Border.all(
                    color: const Color(0xFFEEC88A),
                  ),
                  borderRadius: BorderRadius.circular(4.rpx),
                ),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Container(
                      height: 18.rpx,
                      color: const Color(0xFFEEC88A),
                      alignment: Alignment.center,
                      child: Text(
                        "第一天",
                        style: TextStyle(
                          color: const Color(0xFF333333),
                          fontSize: 10.rpx,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 4.rpx),
                    AppImage.asset(
                      "assets/images/mine/mine_gold16.png",
                      width: 16.rpx,
                      height: 16.rpx,
                    ),
                    SizedBox(height: 4.rpx),
                    Text(
                      "+10",
                      style: TextStyle(
                        color: const Color(0xFFF5B449),
                        fontSize: 12.rpx,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5.rpx),
                  ],
                ),
              ),
            ),
            if (index < 6) SizedBox(width: 6.rpx), // 仅在不是最后一个元素时添加间隔
          ],
        ],
      ),
    );
  }

  Container _earnPointsWidget() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.rpx).copyWith(bottom: 16.rpx),
      child: Column(
        children: [
          for (final item in state.earnPointsItems) ...[
            Container(
              height: 60.rpx,
              padding: EdgeInsets.symmetric(horizontal: 12.rpx),
              decoration: BoxDecoration(
                color: item.isFinish
                    ? const Color(0xFFF6F6F6)
                    : const Color(0x148D310F),
                borderRadius: BorderRadius.circular(8.rpx),
              ),
              alignment: Alignment.center,
              child: Row(
                children: [
                  AppImage.asset(
                    item.icon,
                    width: 32.rpx,
                    height: 32.rpx,
                  ),
                  SizedBox(width: 8.rpx),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: TextStyle(
                            color: const Color(0xFF333333),
                            fontSize: 14.rpx,
                          ),
                        ),
                        Text(
                          item.points,
                          style: TextStyle(
                            color: const Color(0xFF8D310F),
                            fontSize: 14.rpx,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 30.rpx,
                    padding: EdgeInsets.symmetric(horizontal: 12.rpx),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: item.isFinish
                          ? const Color(0xFFE8E8E8)
                          : const Color(0x148D310F),
                      borderRadius: BorderRadius.circular(15.rpx),
                    ),
                    child: Text(
                      item.isFinish ? "已完成" : "去完成",
                      style: TextStyle(
                        color: item.isFinish
                            ? const Color(0xFF999999)
                            : const Color(0xFF8D310F),
                        fontSize: 14.rpx,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (item != state.earnPointsItems.last)
              SizedBox(height: 10.rpx), // 仅在不是最后一个元素时添加间隔
          ],
        ],
      ),
    );
  }

  Container _navWidget() {
    return Container(
      height: 44,
      padding: EdgeInsets.symmetric(horizontal: 16.rpx),
      margin: EdgeInsets.only(top: Get.mediaQuery.padding.top),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppBackButton.dark(),
          // Spacer(),
          Expanded(
            child: Text(
              "任务中心",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFF333333),
                fontSize: 18.rpx,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          // Spacer(),
          SizedBox(width: 24.rpx),
        ],
      ),
    );
  }
}

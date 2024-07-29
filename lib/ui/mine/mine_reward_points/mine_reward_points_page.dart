import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/app_back_button.dart';

import '../../../widgets/app_image.dart';
import 'mine_reward_points_controller.dart';

class MineRewardPointsPage extends StatelessWidget {
  MineRewardPointsPage({Key? key}) : super(key: key);

  final controller = Get.put(MineRewardPointsController());
  final state = Get.find<MineRewardPointsController>().state;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF6F8FE),
      child: Stack(
        children: [
          AppImage.asset(
            "assets/images/mine/mine_reward_points_bg.png",
            height: Get.mediaQuery.padding.top + 106.rpx,
            width: double.infinity,
            fit: BoxFit.fill,
          ),
          Column(
            children: [
              _navWidget(),
              SizedBox(
                height: 57.rpx,
                child: Row(
                  children: [
                    SizedBox(width: 25.rpx),
                    AppImage.asset(
                      "assets/images/mine/mine_reward_points.png",
                      height: 24.rpx,
                      width: 24.rpx,
                    ),
                    SizedBox(width: 6.rpx),
                    Text(
                      "154644",
                      style: TextStyle(
                        color: const Color(0xFF333333),
                        fontSize: 18.rpx,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 24.rpx),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 15 / 19,
                    mainAxisSpacing: 20.rpx,
                    crossAxisSpacing: 27.rpx,
                  ),
                  itemCount: 14,
                  itemBuilder: (_, index) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.rpx),
                      ),
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Positioned(
                            top: 5.rpx,
                            bottom: 5.rpx,
                            left: 5.rpx,
                            right: 5.rpx,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12.rpx),
                                border: Border.all(
                                  color: const Color(0xFFFFF5E5),
                                ),
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              Container(
                                width: 106.rpx,
                                height: 26.rpx,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  image: AppDecorations.backgroundImage(
                                      "assets/images/mine/mine_reward_points_item_bg.png"),
                                ),
                                child: Text(
                                  "10万积分",
                                  style: TextStyle(
                                    color: const Color(0xFF684326),
                                    fontSize: 14.rpx,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(height: 15.rpx),
                              AppImage.asset(
                                "assets/images/mine/mine_gold50.png",
                                height: 50.rpx,
                                width: 50.rpx,
                              ),
                              SizedBox(height: 12.rpx),
                              Text(
                                "10境修币",
                                style: TextStyle(
                                  color: const Color(0xFF333333),
                                  fontSize: 18.rpx,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10.rpx),
                              Container(
                                width: 100.rpx,
                                height: 26.rpx,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEEC88A),
                                  borderRadius: BorderRadius.circular(13.rpx),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  "立即兑换",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.rpx,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
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
          Flexible(
            child: Row(
              children: [
                AppBackButton.dark(),
              ],
            ),
          ),
          Text(
            "积分",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFF333333),
              fontSize: 18.rpx,
              fontWeight: FontWeight.w500,
            ),
          ),
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () => controller.onTapRewardPointsDetail(),
                  child: Text(
                    "积分明细",
                    style: TextStyle(
                      color: const Color(0xFF333333),
                      fontSize: 14.rpx,
                      fontWeight: FontWeight.w500,
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
}

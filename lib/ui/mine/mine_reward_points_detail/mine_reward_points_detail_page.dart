import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'mine_reward_points_detail_controller.dart';

class MineRewardPointsDetailPage extends StatelessWidget {
  MineRewardPointsDetailPage({Key? key}) : super(key: key);

  final controller = Get.put(MineRewardPointsDetailController());
  final state = Get.find<MineRewardPointsDetailController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FE),
      appBar: AppBar(
        title: const Text("积分明细"),
      ),
      body: GetBuilder<MineRewardPointsDetailController>(builder: (controller) {
        return Column(
          children: [
            Container(
              margin:
                  EdgeInsets.symmetric(vertical: 12.rpx, horizontal: 24.rpx),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "2024年4月",
                    style: TextStyle(
                      color: const Color(0xFF333333),
                      fontSize: 12.rpx,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Wrap(
                    spacing: 24.rpx,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: "收入:",
                          style: TextStyle(
                            color: const Color(0xFF999999),
                            fontSize: 14.rpx,
                          ),
                          children: const [
                            TextSpan(
                              text: "142",
                              style: TextStyle(
                                color: Color(0xFF333333),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          text: "消耗:",
                          style: TextStyle(
                            color: const Color(0xFF999999),
                            fontSize: 14.rpx,
                          ),
                          children: const [
                            TextSpan(
                              text: "142",
                              style: TextStyle(
                                color: Color(0xFF333333),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 12.rpx),
                itemCount: state.items.length,
                itemBuilder: (_, index) {
                  debugPrint("reload $index item");
                  var item = state.items[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.rpx),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(12.rpx),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "连续签到7天",
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: const Color(0xFF333333),
                                    fontSize: 16.rpx,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 6.rpx),
                                Text(
                                  "2024-07-21 18:59:40",
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: const Color(0xFF999999),
                                    fontSize: 14.rpx,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 8.rpx),
                          Text(
                            "+80",
                            maxLines: 1,
                            style: TextStyle(
                              color: const Color(0xFF8D310F),
                              fontSize: 16.rpx,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(height: 10.rpx);
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}

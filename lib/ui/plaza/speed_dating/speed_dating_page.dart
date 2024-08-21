import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/text_style_extension.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/app_back_button.dart';
import 'package:guanjia/widgets/app_image.dart';

import 'speed_dating_controller.dart';

class SpeedDatingPage extends StatelessWidget {
  SpeedDatingPage({
    super.key,
    required this.isVideo,
  });

  final bool isVideo;

  final controller = Get.put(SpeedDatingController());
  final state = Get.find<SpeedDatingController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          isVideo ? '视频速配' : '语音速配',
          style: AppTextStyle.st.textColor(Colors.white),
        ),
        backgroundColor: Colors.transparent,
        leading: AppBackButton.light(),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.red,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColor.gradientBackgroundBegin,
                  AppColor.gradientBackgroundEnd,
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Container(
                    width: 260.rpx,
                    height: 30.rpx,
                    margin: EdgeInsets.only(top: 16.rpx),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(15.rpx),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '与在线用户实时匹配，随缘聊天',
                      style:
                          AppTextStyle.st.size(14.rpx).textColor(Colors.white),
                    ),
                  ),
                  // TODO: 特效区域
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 80.rpx,
                    child: Stack(
                      children: [
                        Positioned(
                          top: 0,
                          right: 24.rpx,
                          child: Container(
                            height: 30.rpx,
                            width: 40.rpx,
                            padding: EdgeInsets.only(top: 4.rpx),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(12.rpx)),
                            ),
                            child: Text(
                              "免费",
                              textAlign: TextAlign.center,
                              style: AppTextStyle.st
                                  .size(12.rpx)
                                  .textColor(Colors.white)
                                  .textHeight(1),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: GestureDetector(
                            onTap: controller.onTapStart,
                            child: Container(
                              height: 50.rpx,
                              margin: EdgeInsets.symmetric(horizontal: 24.rpx)
                                  .copyWith(bottom: 12.rpx),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.rpx),
                              ),
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AppImage.asset(
                                    isVideo
                                        ? "assets/images/plaza/video.png"
                                        : "assets/images/plaza/voice.png",
                                    length: 24.rpx,
                                  ),
                                  SizedBox(width: 16.rpx),
                                  Text(
                                    isVideo ? '视频速配' : '语音速配',
                                    style: AppTextStyle.st
                                        .size(16.rpx)
                                        .textColor(AppColor.black3),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: '前1分钟免费聊天！',
                        ),
                        TextSpan(
                          text: '${isVideo ? '视频聊天' : '语音聊天'}120钻/15min',
                          style: AppTextStyle.st
                              .size(12.rpx)
                              .textColor(Colors.white),
                        ),
                      ],
                    ),
                    style: AppTextStyle.st.bold
                        .size(14.rpx)
                        .textColor(Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

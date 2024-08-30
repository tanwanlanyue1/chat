import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/text_style_extension.dart';
import 'package:guanjia/common/service/service.dart';
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
    return Obx(() {
      Widget content() {
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            title: Text(
              isVideo ? '视频速配' : '语音速配',
              style: AppTextStyle.st.textColor(Colors.white),
            ),
            backgroundColor: Colors.transparent,
            systemOverlayStyle: SystemUiOverlayStyle.light,
            leading: state.isAnimation.value
                ? const SizedBox()
                : AppBackButton.light(),
          ),
          body: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                decoration: const BoxDecoration(
                  gradient: AppColor.verticalGradient,
                ),
                child: AppImage.svga(
                  "assets/images/plaza/shooting_star.svga",
                ),
              ),
              SafeArea(
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
                        style: AppTextStyle.st
                            .size(14.rpx)
                            .textColor(Colors.white),
                      ),
                    ),
                    SizedBox(height: isVideo ? 51.rpx : 72.5.rpx),
                    isVideo ? _videoSpecialEffects() : _voiceSpecialEffects(),
                    const Spacer(),
                    if (state.isAnimation.value)
                      Text(
                        '正在速配有缘人，请稍等···',
                        style: AppTextStyle.st.medium
                            .size(16.rpx)
                            .textColor(Colors.white),
                      ),
                    SizedBox(
                      width: double.infinity,
                      height: 70.rpx,
                      child: Stack(
                        children: [
                          if (!state.isAnimation.value)
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
                              onTap: () => controller.onTapStart(isVideo),
                              child: Container(
                                height: 50.rpx,
                                margin:
                                    EdgeInsets.symmetric(horizontal: 24.rpx),
                                decoration: BoxDecoration(
                                  color: state.isAnimation.value
                                      ? Colors.white.withOpacity(0.3)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(8.rpx),
                                ),
                                alignment: Alignment.center,
                                child: state.isAnimation.value
                                    ? Text(
                                        '取消匹配',
                                        style: AppTextStyle.st
                                            .size(16.rpx)
                                            .textColor(AppColor.blackText),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                    Container(
                      width: double.infinity,
                      height: 38.rpx,
                      alignment: Alignment.center,
                      child: !state.isAnimation.value
                          ? Builder(builder: (context) {
                              final config = SS.appConfig.configRx.value;
                              final freeTime =
                                  ((config?.chatFreeSecond ?? 60) / 60)
                                      .floor()
                                      .toString();

                              final price = isVideo
                                  ? config?.videoChatPrice ?? 0
                                  : config?.voiceChatPrice ?? 0;

                              final priceAmount = (price * 15).toString();

                              return Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "前$freeTime分钟免费聊天！",
                                    ),
                                    TextSpan(
                                      text:
                                          '${isVideo ? '视频聊天' : '语音聊天'}$priceAmount钻/15min',
                                      style: AppTextStyle.st
                                          .size(12.rpx)
                                          .textColor(Colors.white),
                                    ),
                                  ],
                                ),
                                style: AppTextStyle.st.bold
                                    .size(14.rpx)
                                    .textColor(Colors.white),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              );
                            })
                          : null,
                    ),
                    SizedBox(height: 42.rpx),
                  ],
                ),
              ),
              if (isVideo && state.isAnimation.value) _camera(),
            ],
          ),
        );
      }

      return state.isAnimation.value
          ? WillPopScope(
              onWillPop: () async {
                return false;
              },
              child: content(),
            )
          : content();
    });
  }

  Widget _camera() {
    return Positioned(
      bottom: 210.rpx + Get.mediaQuery.padding.bottom,
      right: 16.rpx,
      child: GestureDetector(
        onTap: state.isCameraOpen.toggle,
        child: Container(
          width: 56.rpx,
          height: 56.rpx,
          decoration: BoxDecoration(
            color: AppColor.primaryBlue.withOpacity(0.3),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColor.primaryBlue.withOpacity(0.2),
                blurRadius: 4.rpx,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppImage.asset(
                state.isCameraOpen.value
                    ? "assets/images/plaza/camera_open.png"
                    : "assets/images/plaza/camera_close.png",
                length: 24.rpx,
              ),
              Text(
                state.isCameraOpen.value ? '开启' : '关闭',
                style: AppTextStyle.st.size(12.rpx).textColor(Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _videoSpecialEffects() {
    Widget buildRound({
      required double length,
      required double backgroundColorOpacity,
      required double borderColorOpacity,
    }) {
      return Container(
        width: length,
        height: length,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(backgroundColorOpacity),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withOpacity(borderColorOpacity),
          ),
        ),
      );
    }

    List<Widget> avatarList() {
      final list = [
        (top: 42, left: 209, length: 36),
        (top: 178, left: 209, length: 36),
        (top: 60, left: 74, length: 36),
        (top: 122, left: 22, length: 24),
        (top: 228, left: 107, length: 24)
      ];

      return List.generate(
          list.length,
          (index) => Positioned(
                top: list[index].top.rpx,
                left: list[index].left.rpx,
                child: Container(
                  width: list[index].length.rpx,
                  height: list[index].length.rpx,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white,
                        blurRadius: 4.rpx,
                      ),
                    ],
                  ),
                  child: AppImage.network(
                    state.avatars[index + state.avatarIndex.value],
                    length: list[index].length.rpx,
                    shape: BoxShape.circle,
                  ),
                ),
              ));
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        buildRound(
            length: 300.rpx,
            backgroundColorOpacity: 0.03,
            borderColorOpacity: 0.14),
        buildRound(
            length: 230.rpx,
            backgroundColorOpacity: 0.02,
            borderColorOpacity: 0.12),
        buildRound(
            length: 162.rpx,
            backgroundColorOpacity: 0.01,
            borderColorOpacity: 0.10),
        if (state.isAnimation.value)
          AppImage.svga(
            "assets/images/plaza/search_rotation.svga",
            width: 300.rpx,
            height: 300.rpx,
          ),
        Container(
          width: 80.rpx,
          height: 80.rpx,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.5),
                blurRadius: 8.rpx,
              ),
            ],
          ),
          child: AppImage.network(
            SS.login.avatar,
            length: 80.rpx,
            shape: BoxShape.circle,
          ),
        ),
        AppImage.asset(
          "assets/images/plaza/speed_head_default.png",
          length: 80.rpx,
        ),
        if (state.isAnimation.value) ...avatarList(),
      ],
    );
  }

  Widget _voiceSpecialEffects() {
    Widget avatarWidget({String? avatar}) {
      return SizedBox(
        width: 115.rpx,
        height: 115.rpx,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 100.rpx,
              height: 100.rpx,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.5),
                    blurRadius: 8.rpx,
                  ),
                ],
              ),
              child: AppImage.network(
                avatar ?? "",
                length: 100.rpx,
                shape: BoxShape.circle,
                placeholder: AppImage.asset(
                  "assets/images/plaza/speed_head_bg.png",
                  length: 100.rpx,
                ),
              ),
            ),
            AppImage.asset(
              "assets/images/plaza/speed_head_default.png",
              length: 100.rpx,
            ),
          ],
        ),
      );
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            avatarWidget(avatar: SS.login.avatar),
            SizedBox(width: 5.rpx),
            Stack(
              alignment: Alignment.center,
              children: [
                avatarWidget(
                    avatar: state.isAnimation.value
                        ? state.avatars[state.avatarIndex.value]
                        : null),
                AppImage.svga(
                  "assets/images/plaza/speed_head_circle_ripple.svga",
                  width: 115.rpx,
                  height: 115.rpx,
                ),
              ],
            ),
          ],
        ),
        if (state.isAnimation.value)
          AppImage.svga(
            "assets/images/plaza/electrocardiogram.svga",
            width: 50.rpx,
            height: 50.rpx,
          ),
      ],
    );
  }
}

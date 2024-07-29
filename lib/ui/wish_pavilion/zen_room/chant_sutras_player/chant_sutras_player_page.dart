import 'dart:math';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/wish_pavilion/zen_room/utils/chant_sutras_player_controller.dart';
import 'package:guanjia/ui/wish_pavilion/zen_room/widigets/zen_room_sutras_playlist_bottom_sheet.dart';
import 'package:guanjia/ui/wish_pavilion/zen_room/zen_room_controller.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/widgets.dart';

import 'chant_sutras_player_controller.dart';
import 'widgets/chant_sutras_line_tile.dart';

///诵经播放器-全屏视图
class ChantSutrasPlayerPage extends StatelessWidget {
  final controller = Get.put(ChantSutrasPlayerPageController());
  final state = Get.find<ChantSutrasPlayerPageController>().state;

  ChantSutrasPlayerController get chantSutrasController =>
      Get.find<ZenRoomController>().chantSutrasController;

  @override
  Widget build(BuildContext context) {
    final paddingVertical = MediaQuery.of(context).size.height * 0.066;
    return AnimatedBuilder(
        animation: chantSutrasController,
        builder: (_, child) {
          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              title: Text(chantSutrasController.currentSutras?.name ?? ''),
              backgroundColor: Colors.transparent,
            ),
            backgroundColor: const Color(0xFFFFF1E3),
            body: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AppAssetImage(
                    'assets/images/wish_pavilion/zen_room/player_bg.png',
                  ),
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: FEdgeInsets(
                        top: Get.mediaQuery.padding.top +
                            kToolbarHeight +
                            paddingVertical,
                        bottom: paddingVertical,
                      ),
                      child: LayoutBuilder(
                        builder: (_, constraints) {
                          controller.setMaxHeight(constraints.maxHeight);
                          return Obx(() {
                            final lines = state.linesRx();
                            final currentIndex = state.currentIndexRx();
                            final hasLrc = state.lrcRx() != null;
                            return FadingEdgeScrollView.fromScrollView(
                              child: ListView.builder(
                                padding: FEdgeInsets.zero,
                                controller: controller.scrollController,
                                itemCount: lines.length,
                                itemExtent: ChantSutrasLineTile.height,
                                physics: hasLrc
                                    ? const NeverScrollableScrollPhysics()
                                    : null,
                                itemBuilder: (_, index) {
                                  return ChantSutrasLineTile(
                                    text: lines[index],
                                    isHighlight: index == currentIndex,
                                  );
                                },
                              ),
                            );
                          });
                        },
                      ),
                    ),
                  ),
                  buildPosition(),
                  buildControlUI(),
                ],
              ),
            ),
          );
        });
  }

  ///进度条
  Widget buildPosition() {
    return StreamBuilder<Duration?>(
      initialData: Duration.zero,
      stream: chantSutrasController.durationStream,
      builder: (_, durationSnapshot) {
        return StreamBuilder<Duration>(
          initialData: Duration.zero,
          stream: chantSutrasController.positionStream,
          builder: (_, positionSnapshot) {
            final duration = durationSnapshot.data ?? Duration.zero;
            final position = positionSnapshot.data ?? Duration.zero;

            return Padding(
              padding: FEdgeInsets(horizontal: 12.rpx),
              child: ProgressBar(
                progress: position,
                total: duration,
                timeLabelLocation: TimeLabelLocation.sides,
                timeLabelTextStyle: AppTextStyle.fs12m.copyWith(
                  color: AppColor.gray5,
                ),
                barHeight: 4.rpx,
                baseBarColor: const Color(0x33967336),
                progressBarColor: const Color(0xFF967336),
                thumbColor: const Color(0xFF967336),
                thumbRadius: 8.rpx,
                thumbGlowRadius: 24.rpx,
                onSeek: (position) {
                  chantSutrasController.seek(position);
                },
              ),
            );
          },
        );
      },
    );
  }

  ///播放控制UI
  Widget buildControlUI() {
    iconButton(String icon, {VoidCallback? onTap}) {
      return Button.icon(
        onPressed: onTap,
        width: 36.rpx,
        height: 36.rpx,
        margin: FEdgeInsets(horizontal: 8.rpx),
        icon: AppImage.asset(
          icon,
          width: 20.rpx,
          height: 20.rpx,
          opacity: onTap != null ? null : const AlwaysStoppedAnimation(0.5),
        ),
      );
    }

    return Padding(
      padding: FEdgeInsets(
          top: 28.rpx, bottom: max(28.rpx, Get.mediaQuery.padding.bottom)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          iconButton(
            chantSutrasController.loopMode.icon,
            onTap: chantSutrasController.toggleLoopMode,
          ),
          iconButton(
            'assets/images/wish_pavilion/zen_room/ic_player_prev.png',
            onTap: chantSutrasController.hasPrevious
                ? () {
                    chantSutrasController.previous();
                  }
                : null,
          ),
          Button.icon(
            onPressed: chantSutrasController.togglePlay,
            margin: FEdgeInsets(horizontal: 16.rpx),
            width: 46.rpx,
            height: 46.rpx,
            icon: AppImage.asset(
              chantSutrasController.playing
                  ? 'assets/images/wish_pavilion/zen_room/ic_player_pause.png'
                  : 'assets/images/wish_pavilion/zen_room/ic_player_play.png',
            ),
          ),
          iconButton(
            'assets/images/wish_pavilion/zen_room/ic_player_next.png',
            onTap: chantSutrasController.hasNext
                ? () {
                    chantSutrasController.next();
                  }
                : null,
          ),
          iconButton(
            'assets/images/wish_pavilion/zen_room/ic_player_playlist.png',
            onTap: () {
              ZenRoomSutrasPlaylistBottomSheet.show();
            },
          ),
        ],
      ),
    );
  }

}

extension on Duration {
  String get durationFormat {
    final minutes = inMinutes.toString().padLeft(2, '0');
    final seconds = (inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}

extension on LoopMode {
  String get icon {
    switch (this) {
      case LoopMode.off:
      case LoopMode.all:
        return 'assets/images/wish_pavilion/zen_room/ic_player_loop_off.png';
      case LoopMode.one:
        return 'assets/images/wish_pavilion/zen_room/ic_player_loop_one.png';
    }
  }
}

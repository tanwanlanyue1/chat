import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/paging/default_status_indicators/no_items_found_indicator.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/wish_pavilion/zen_room/zen_room_controller.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/widgets.dart';

import '../utils/chant_sutras_player_controller.dart';
import 'sutras_list_tile.dart';

///诵经播放列表
class ZenRoomSutrasPlaylistBottomSheet extends StatefulWidget {
  const ZenRoomSutrasPlaylistBottomSheet._({super.key});

  static Future<void> show() {
    return Get.bottomSheet<void>(
      const ZenRoomSutrasPlaylistBottomSheet._(),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.rpx)),
      ),
      isScrollControlled: true,
    );
  }

  @override
  State<ZenRoomSutrasPlaylistBottomSheet> createState() =>
      _ZenRoomSutrasPlaylistBottomSheetState();
}

class _ZenRoomSutrasPlaylistBottomSheetState
    extends State<ZenRoomSutrasPlaylistBottomSheet> {
  ChantSutrasPlayerController get chantSutrasController =>
      Get.find<ZenRoomController>().chantSutrasController;

  var isDeleteMode = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height * 0.8,
      child: AnimatedBuilder(
        animation: chantSutrasController,
        builder: (_, child) {
          if (chantSutrasController.playlist.isEmpty) {
            isDeleteMode = false;
          }
          return Column(
            children: [
              buildTitle(),
              const Divider(height: 0),
              Expanded(child: buildListView(context)),
            ],
          );
        },
      ),
    );
  }

  Widget buildTitle() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      leading: buildLoopModelButton(),
      leadingWidth: (76+12).rpx,
      title: const Text('播放列表'),
      actions: chantSutrasController.playlist.isNotEmpty
          ? [buildDeleteButton()]
          : [],
    );
  }

  Widget buildLoopModelButton() {
    return Container(
      alignment: Alignment.center,
      padding: FEdgeInsets(left: 12.rpx),
      child: GestureDetector(
        onTap: chantSutrasController.toggleLoopMode,
        child: Container(
          width: 76.rpx,
          height: 24.rpx,
          decoration: const ShapeDecoration(
            shape: StadiumBorder(),
            color: Color(0x26999999),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppImage.asset(
                chantSutrasController.loopMode.icon,
                width: 16.rpx,
                height: 16.rpx,
              ),
              Padding(
                padding: FEdgeInsets(left: 4.rpx),
                child: Text(
                  chantSutrasController.loopMode.label,
                  style: AppTextStyle.fs10m.copyWith(
                    color: AppColor.gray5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDeleteButton() {
    if (isDeleteMode) {
      return TextButton(
        onPressed: () {
          setState(() {
            isDeleteMode = false;
          });
        },
        child: const Text(
          '取消',
          style: TextStyle(color: AppColor.gray5),
        ),
      );
    } else {
      return IconButton(
        icon: AppImage.asset(
          'assets/images/wish_pavilion/zen_room/ic_playlist_delete.png',
          width: 20.rpx,
          height: 20.rpx,
        ),
        onPressed: () {
          setState(() {
            isDeleteMode = true;
          });
        },
      );
    }
  }

  Widget buildListView(BuildContext context) {
    final list = chantSutrasController.playlist;
    final currentSutras = chantSutrasController.currentSutras;
    if (list.isEmpty) {
      return const NoItemsFoundIndicator(title: '播放列表为空');
    }
    return ListView.separated(
        itemBuilder: (_, index) {
          final item = list[index];
          return SutrasListTile(
            item: item,
            isPlaying: chantSutrasController.playing && currentSutras?.id == item.id,
            isCurrent: currentSutras?.id == item.id,
            onTapPlay: () {
              chantSutrasController.play(item);
            },
            onTapDelete: isDeleteMode
                ? () {
                    chantSutrasController.delete(item);
                  }
                : null,
          );
        },
        separatorBuilder: (_, index) {
          return Divider(height: 0, indent: 12.rpx, endIndent: 12.rpx);
        },
        itemCount: list.length);
  }
}

extension on LoopMode {
  String get label {
    switch (this) {
      case LoopMode.off:
        return '顺序播放';
      case LoopMode.one:
        return '单曲循环';
      case LoopMode.all:
        return '列表循环';
    }
  }
  String get icon {
    switch (this) {
      case LoopMode.off:
      case LoopMode.all:
        return 'assets/images/wish_pavilion/zen_room/ic_playlist_loop_off.png';
      case LoopMode.one:
        return 'assets/images/wish_pavilion/zen_room/ic_playlist_loop_one.png';
    }
  }
}

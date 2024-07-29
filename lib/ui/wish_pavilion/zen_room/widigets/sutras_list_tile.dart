import 'package:flutter/material.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/network/api/model/wish_pavilion/buddhist_sutras_model.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/wish_pavilion/zen_room/buddhist_sutras_list/widgets/buddhist_sutras_cover.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/widgets.dart';

///经书列表项
class SutrasListTile extends StatelessWidget {
  final BuddhistSutrasModel item;
  ///正在播放中
  final bool isPlaying;
  ///当前播放(已暂停，已播放结束，播放中)
  final bool isCurrent;
  final VoidCallback? onTap;
  final VoidCallback? onTapPlay;
  final VoidCallback? onTapDelete;

  const SutrasListTile({
    super.key,
    required this.item,
    required this.isPlaying,
    required this.isCurrent,
    this.onTap,
    this.onTapPlay,
    this.onTapDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: FEdgeInsets(vertical: 14.rpx, horizontal: 12.rpx),
        child: Row(
          children: [
            Container(
              width: 36.rpx,
              height: 36.rpx,
              decoration: ShapeDecoration(
                shape: const CircleBorder(),
                color: Colors.grey.withOpacity(0.3),
              ),
              clipBehavior: Clip.antiAlias,
              child: FittedBox(
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
                child: BuddhistSutrasCover(name: item.name),
              ),
            ),
            Expanded(
              child: Padding(
                padding: FEdgeInsets(left: 8.rpx),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item.name,
                      style: AppTextStyle.fs14m.copyWith(
                        color: isCurrent ? AppColor.red1 : AppColor.gray5,
                        fontWeight: isCurrent ? FontWeight.bold : null,
                      ),
                    ),
                    Padding(
                      padding: FEdgeInsets(top: 4.rpx),
                      child: Text(
                        item.durationFormat,
                        style:
                            AppTextStyle.fs12m.copyWith(color: AppColor.gray9),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Button.icon(
              onPressed: isPlaying ? null : onTapPlay,
              width: 24.rpx,
              height: 24.rpx,
              icon: AppImage.asset(
                isPlaying
                    ? 'assets/images/wish_pavilion/zen_room/ic_playing.png'
                    : 'assets/images/wish_pavilion/zen_room/ic_play_icon.png',
              ),
            ),
            if (onTapDelete != null)
              Button.icon(
                onPressed: onTapDelete,
                width: 36.rpx,
                height: 36.rpx,
                margin: FEdgeInsets(left: 4.rpx),
                icon: AppImage.asset(
                  'assets/images/wish_pavilion/zen_room/ic_playlist_close.png',
                  width: 16.rpx,
                  height: 16.rpx,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

extension on BuddhistSutrasModel {
  ///秒钟转换为mm::ss
  String get durationFormat {
    if (duration <= 0) {
      return '00:00';
    }
    final timeDuration = Duration(seconds: duration);
    String fmt(int value) {
      return value.toString().padLeft(2, '0');
    }

    final minutes = timeDuration.inMinutes;
    final seconds = timeDuration.inSeconds;
    return '${fmt(minutes)}:${fmt(seconds % 60)}';
  }
}

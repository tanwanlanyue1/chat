import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/date_time_extension.dart';
import 'package:guanjia/common/extension/int_extension.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/widgets.dart';

class MineMessageListTile extends StatelessWidget {
  final MessageModel item;
  final VoidCallback? onTap;

  const MineMessageListTile({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: FEdgeInsets(right: 8.rpx),
            child: buildAvatar(),
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      item.systemMessage?.title ?? '',
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.fs16m.copyWith(
                        color: AppColor.black3,
                        height: 1.0,
                      ),
                    ),
                  ),
                  Text(
                    item.systemMessage?.createTime?.dateTime.friendlyTime ??
                        '',
                    style: AppTextStyle.fs12.copyWith(color: AppColor.gray9),
                  ),
                ],
              ),
              if (item.systemMessage?.content?.isNotEmpty == true)
                Padding(
                  padding: FEdgeInsets(top: 8.rpx),
                  child: Text(
                    item.systemMessage?.content ?? '',
                    style: AppTextStyle.fs14.copyWith(
                      color: AppColor.black3,
                      height: 1.5,
                    ),
                  ),
                ),
              if (item.systemMessage?.image?.isNotEmpty == true)
                Padding(
                  padding: FEdgeInsets(top: 8.rpx),
                  child: AspectRatio(
                    aspectRatio: 295 / 100,
                    child: AppImage.network(
                      item.systemMessage?.image ?? '',
                      memCacheWidth: 295.rpx,
                      memCacheHeight: 100.rpx,
                      borderRadius: BorderRadius.circular(8.rpx),
                    ),
                  ),
                ),
              if (item.systemMessage?.highlightText?.isNotEmpty == true)
                Padding(
                  padding: FEdgeInsets(top: 8.rpx),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        item.systemMessage?.highlightText ?? '',
                        style: AppTextStyle.fs12.copyWith(
                          color: AppColor.babyBlueButton,
                          height: 1,
                        ),
                      ),
                      AppImage.asset(
                        'assets/images/mine/ic_arrow_right_blue.png',
                        size: 12.rpx,
                      ),
                    ],
                  ),
                ),
              Padding(
                padding: FEdgeInsets(top: 12.rpx),
                child: const Divider(height: 1),
              ),
            ],
          )),
        ],
      ),
    );
  }

  Widget buildAvatar() {
    return Stack(
      children: [
        AppImage.asset(
          'assets/images/chat/ic_sys_notice.png',
          size: 40.rpx,
        ),
        Positioned(
          top: 0,
          left: 0,
          child: AppImage.asset(
            'assets/images/mine/ic_sys_msg.png',
            size: 16.rpx,
          ),
        ),
        if (item.read != 1)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 10.rpx,
              height: 10.rpx,
              decoration: ShapeDecoration(
                shape: CircleBorder(
                  side: BorderSide(width: 1.5.rpx, color: Colors.white),
                ),
                color: AppColor.green1D,
              ),
            ),
          ),
      ],
    );
  }
}

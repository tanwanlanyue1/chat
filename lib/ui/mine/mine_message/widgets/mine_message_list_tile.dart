import 'package:flutter/material.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/date_time_extension.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/common/extension/int_extension.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/edge_insets.dart';

class MineMessageListTile extends StatelessWidget {
  final MessageModel item;
  final VoidCallback? onTap;

  const MineMessageListTile({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.white,
        padding: FEdgeInsets(vertical: 16.rpx, horizontal: 12.rpx),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 10.rpx,
                  height: 10.rpx,
                  margin: EdgeInsets.only(right: 8.rpx),
                  decoration: BoxDecoration(
                    color: item.color ?? AppColor.primaryBlue,
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  child: Text(
                    (item.systemMessage?.title ?? '') * 3,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.fs16b.copyWith(
                      color: AppColor.blackText,
                      height: 1.0,
                    ),
                  ),
                ),
                Text(
                  item.systemMessage?.createTime?.dateTime.format2 ?? '',
                  style: AppTextStyle.fs12m.copyWith(color: AppColor.gray9),
                ),
              ],
            ),
            Divider(height: 32.rpx),
            if (item.image.isNotEmpty)
              Padding(
                padding: FEdgeInsets(bottom: 12.rpx),
                child: AppImage.network(
                  item.image,
                  width: 320.rpx,
                  height: 100.rpx,
                ),
              ),
            Text(
              item.systemMessage?.content ?? '',
              style: AppTextStyle.fs14m.copyWith(
                color: AppColor.blackText,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

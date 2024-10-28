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
      child: Container(
        color: Colors.white,
        padding: FEdgeInsets(vertical: 12.rpx, horizontal: 12.rpx),
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
                    color: item.systemMessage?.color ?? AppColor.primaryBlue,
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  child: Text(
                    item.systemMessage?.title ?? '',
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.fs16m.copyWith(
                      color: AppColor.blackText,
                      height: 1.0,
                    ),
                  ),
                ),
                Text(
                  item.systemMessage?.createTime?.dateTime.format2 ?? '',
                  style: AppTextStyle.fs10.copyWith(color: AppColor.gray9),
                ),
              ],
            ),
            SizedBox(height: 8.rpx,),
            if (item.systemMessage?.image?.isNotEmpty == true)
              Padding(
                padding: FEdgeInsets(bottom: 12.rpx),
                child: AppImage.network(
                  item.systemMessage?.image ?? '',
                  width: 320.rpx,
                  height: 100.rpx,
                ),
              ),
            buildContent(),
          ],
        ),
      ),
    );
  }

  Widget buildContent() {
    final content = item.systemMessage?.content ?? '';
    final highlightText = item.systemMessage?.highlightText ?? '';
    if (content.isEmpty) {
      return Spacing.blank;
    }
    final index = content.indexOf(highlightText);
    if (highlightText.isEmpty || index == -1) {
      return Text(
        item.systemMessage?.content ?? '',
        style: AppTextStyle.fs12.copyWith(
          color: AppColor.blackText,
          height: 1.5,
        ),
      );
    }

    final items = [
      content.substring(0, index),
      highlightText,
      content.substring(index + highlightText.length),
    ];

    return Text.rich(TextSpan(
        style: AppTextStyle.fs12.copyWith(
          color: AppColor.blackText,
          height: 1.5,
        ),
        children: [
          if (items[0].isNotEmpty) TextSpan(text: items[0]),
          if (items[1].isNotEmpty)
            TextSpan(
              text: "\n${items[1]}",
              style: AppTextStyle.fs14.copyWith(
                color: AppColor.primaryBlue,
                height: 1.5,
              ),
            ),
          if (items[2].isNotEmpty) TextSpan(text: items[2]),
        ]));
  }
}

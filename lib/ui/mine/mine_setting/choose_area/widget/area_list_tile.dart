import 'package:flutter/material.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/text_style_extension.dart';
import 'package:guanjia/common/network/api/model/user/area_model.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/widgets.dart';

class AreaListTile extends StatelessWidget {
  final AreaModel item;
  final VoidCallback? onTap;

  const AreaListTile({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.white,
        height: 48.rpx,
        padding: FEdgeInsets(left: 16.rpx, right: 12.rpx),
        child: Row(
          children: [
            Expanded(
              child: Text(
                item.name,
                style: AppTextStyle.fs16m.copyWith(
                  color: AppColor.black3,
                ),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_right,
              size: 24.rpx,
              color: const Color(0xFFC5C6CB),
            ),
          ],
        ),
      ),
    );
  }
}

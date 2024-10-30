import 'package:flutter/material.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/network/api/model/user/user_model.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/edge_insets.dart';

///职场组件
class OccupationWidget extends StatelessWidget {
  final UserOccupation occupation;

  const OccupationWidget({super.key, required this.occupation});

  @override
  Widget build(BuildContext context) {
    Color color;
    String icon;
    String text;
    switch (occupation) {
      case UserOccupation.unknown:
        return const SizedBox.shrink();
      case UserOccupation.employees:
        color = AppColor.primaryBlue;
        icon = 'assets/images/plaza/workplace.png';
        text = S.current.workplace;
        break;
      case UserOccupation.student:
        color = AppColor.green1D;
        icon = 'assets/images/plaza/student.png';
        text = S.current.student;
        break;
    }
    const skewX = 0.2;
    return Container(
      padding: FEdgeInsets(right: 4.rpx),
      height: 12.rpx,
      transform: Matrix4.skewX(-skewX),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2.rpx),
        color: color.withOpacity(0.1),
      ),
      child: Transform(
        transform: Matrix4.skewX(skewX),
        child: Row(
          children: [
            AppImage.asset(icon, width: 12.rpx),
            Padding(
              padding: FEdgeInsets(left: 1.rpx),
              child: Text(
                text,
                style: AppTextStyle.fs8.copyWith(color: color, height: 1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

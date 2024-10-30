import 'package:flutter/material.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/network/api/model/open/app_config_model.dart';
import 'package:guanjia/common/network/api/model/user/user_model.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/edge_insets.dart';

///用户风格列表
class UserStyle extends StatelessWidget {
  final LabelModel styleList;

  const UserStyle({super.key, required this.styleList});

  @override
  Widget build(BuildContext context) {
    const skewX = 0.2;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.rpx,vertical: 2.rpx),
      transform: Matrix4.skewX(-skewX),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2.rpx),
        color: AppColor.orange6.withOpacity(0.1),
      ),
      margin: EdgeInsets.only(right: 4.rpx),
      child: Transform(
        transform: Matrix4.skewX(skewX),
        child: Row(
          children: [
            AppImage.network(styleList.icon, width: 16.rpx,height: 16.rpx,),
            Padding(
              padding: FEdgeInsets(left: 1.rpx),
              child: Text(
                styleList.tag,
                style: AppTextStyle.fs10.copyWith(color: AppColor.black20, height: 1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

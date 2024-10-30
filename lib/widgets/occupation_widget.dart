import 'package:flutter/material.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/network/api/model/user/user_model.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/widgets/app_image.dart';

///职场组件
class OccupationWidget extends StatelessWidget {
  final UserOccupation occupation;
  const OccupationWidget({super.key, required this.occupation});


  @override
  Widget build(BuildContext context) {
    return occupation != UserOccupation.unknown ?
    Container(
      width: 37.rpx,
      height: 12.rpx,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AppAssetImage(occupation != UserOccupation.student ?
            "assets/images/plaza/student_back.png":"assets/images/plaza/workplace_back.png")
        ),
      ),
      child: Row(
        children: [
         AppImage.asset(occupation != UserOccupation.student ?
         "assets/images/plaza/student.png":"assets/images/plaza/workplace.png"),
          Text(occupation != UserOccupation.student ?
          S.current.student:S.current.workplace,style: AppTextStyle.fs8.copyWith(color: occupation != UserOccupation.student ? AppColor.green1D: AppColor.primaryBlue),)
        ],
      ),
    ):Container();
  }

}

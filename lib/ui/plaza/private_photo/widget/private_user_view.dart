import 'package:flutter/material.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

import '../../../../common/network/api/model/plaza/plaza_list_model.dart';
import '../../../../widgets/app_image.dart';
import '../../../../widgets/user_avatar.dart';

class PrivateUserView extends StatelessWidget {
  const PrivateUserView({Key? key, required this.item}) : super(key: key);

  final PlazaListModel item;
  @override
  Widget build(BuildContext context) {
    return buildUserAvatar();
  }
  Widget buildUserAvatar() {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        AppImage.svga(
          'assets/images/plaza/头像.svga',
          width: 70.rpx,
          height: 70.rpx,
        ),
        Container(
          width: 51.5.rpx,
          height: 51.5.rpx,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Color(0xffC644FC), // 描边颜色
              width: 1.5.rpx, // 描边宽度
            ),
          ),
        ),
        UserAvatar.circle(
          item.avatar ?? "",
          size: 50.rpx,
        ),
        Positioned(
            top: 49.rpx,
            child: AppImage.asset(
              "assets/images/plaza/hi_ic.png",
              width: 45.rpx,
              height: 20.rpx,
            ))
      ],
    );
  }
}

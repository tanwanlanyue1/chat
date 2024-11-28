import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

import '../../../../common/app_text_style.dart';
import '../../../../widgets/app_image.dart';

class PrivatePhotoListItem extends StatelessWidget {
  PrivatePhotoListItem({Key? key, this.onItemTap})
      : super(key: key);
  final VoidCallback? onItemTap; // 定义回调函数
  RxBool isLook = false.obs;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onItemTap,
      child: Stack(children: [
        Container(
          height: 200.rpx,
          color: Colors.black,
        ),
        Obx(() => Visibility(
            visible: isLook.value,
            child: Container(
              height: 220.rpx,
              color: Colors.black.withOpacity(0.1),
              alignment: Alignment.center,
              child: Text('刚刚看过',
                  style: AppTextStyle.fs14.copyWith(color: Colors.white)),
            ))),
        Positioned(
          bottom: 10,
          right: 10,
          child: AppImage.asset("assets/images/plaza/attention.png"),
          height: 18.rpx,
          width: 18.rpx,
        ),
        Positioned(
          top: 10,
          right: 10,
          child: AppImage.asset("assets/images/plaza/attention.png"),
          height: 18.rpx,
          width: 18.rpx,
        )
      ]),
    );
  }
}

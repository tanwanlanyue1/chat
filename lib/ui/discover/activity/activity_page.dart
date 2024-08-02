import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/extension/iterable_extension.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/app_image.dart';

import 'activity_controller.dart';

//发现-热门活动
class ActivityPage extends StatelessWidget {
  ActivityPage({Key? key}) : super(key: key);

  final controller = Get.put(ActivityController());
  final state = Get.find<ActivityController>().state;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 16.rpx).copyWith(top: 16.rpx),
      children: [
        AppImage.asset('assets/images/discover/activity_card.png'),
        SizedBox(height: 16.rpx),
        AppImage.asset('assets/images/discover/activity_card2.png'),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/widgets.dart';

import 'beautiful_status_switch.dart';

///佳丽状态提示文本
class BeautifulStatusTips extends StatelessWidget {
  final BeautifulStatus status;

  const BeautifulStatusTips({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    if (status == BeautifulStatus.inProgress) {
      return SizedBox(height: 26.rpx);
    }

    return Container(
      height: 26.rpx,
      decoration: const ShapeDecoration(
        color: Colors.white,
        shape: StadiumBorder(),
      ),
      padding: FEdgeInsets(horizontal: 16.rpx),
      child: Row(
        children: [
          Padding(
            padding: FEdgeInsets(right: 8.rpx),
            child: AppImage.asset(
              status.icon,
              width: 16.rpx,
              height: 16.rpx,
            ),
          ),
          Expanded(
            child: Text(
              status.text,
              style: AppTextStyle.fs12m.copyWith(color: AppColor.gray5),
            ),
          ),
        ],
      ),
    );
  }
}

extension on BeautifulStatus {
  String get icon {
    switch (this) {
      case BeautifulStatus.offline:
        return 'assets/images/mine/ic_offline.png';
      case BeautifulStatus.online:
        return 'assets/images/mine/ic_online.png';
      default:
        return '';
    }
  }

  String get text {
    switch (this) {
      case BeautifulStatus.offline:
        return '您已下线，再次点击切换继续接单哦。';
      case BeautifulStatus.online:
        return '您已经开始接约啦~';
      default:
        return '';
    }
  }
}

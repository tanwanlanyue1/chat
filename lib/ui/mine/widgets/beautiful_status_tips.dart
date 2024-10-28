import 'package:flutter/material.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/network/api/model/user/user_model.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/widgets.dart';

///佳丽状态提示文本
class BeautifulStatusTips extends StatelessWidget {
  final UserStatus status;

  const BeautifulStatusTips({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    if (status == UserStatus.inProgress) {
      return SizedBox(height: 26.rpx);
    }

    return Container(
      height: 28.rpx,
      decoration: const ShapeDecoration(
        color: Colors.white,
        shape: StadiumBorder(),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: FEdgeInsets(right: 8.rpx),
            child: AppImage.asset(
              status.icon,
              width: 16.rpx,
              height: 16.rpx,
            ),
          ),
          Text(
            status.text,
            style: AppTextStyle.fs12.copyWith(color: AppColor.blackText),
          ),
        ],
      ),
    );
  }
}

extension on UserStatus {
  String get icon {
    switch (this) {
      case UserStatus.offline:
        return 'assets/images/mine/ic_offline.png';
      case UserStatus.online:
        return 'assets/images/mine/ic_online.png';
      default:
        return '';
    }
  }

  String get text {
    switch (this) {
      case UserStatus.offline:
        return S.current.beautifulOfflineTips;
      case UserStatus.online:
        return S.current.beautifulOnlineTips;
      default:
        return '';
    }
  }
}

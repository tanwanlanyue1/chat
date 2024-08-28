import 'package:flutter/material.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/network/api/model/user/user_model.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/widgets.dart';

///佳丽状态切换按钮
class BeautifulStatusSwitch extends StatelessWidget {
  final UserStatus status;
  final ValueChanged<UserStatus>? onChange;

  const BeautifulStatusSwitch({
    super.key,
    required this.status,
    this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    Widget text = Text(status.label, style: AppTextStyle.fs12b);
    if (status == UserStatus.offline) {
      text = Text.rich(
        TextSpan(
          style: AppTextStyle.fs12b,
          children: [
            TextSpan(text: status.label),
            TextSpan(
              text: '\n（点击切换）',
              style: AppTextStyle.fs10m,
            ),
          ],
        ),
        textAlign: TextAlign.center,
      );
    }

    return Button(
      width: 80.rpx,
      height: 40.rpx,
      backgroundColor: status.backgroundColor,
      onPressed: () {
        onChange?.call(status.next());
      },
      child: text,
    );
  }
}

extension UserStatusX on UserStatus {

  static UserStatus? valueOf(int value){
    return UserStatus.values.elementAtOrNull(value);
  }

  int get value => index;

  String get label {
    switch (this) {
      case UserStatus.offline:
        return '当前不接约';
      case UserStatus.online:
        return '接约中···';
      case UserStatus.inProgress:
        return '约会中';
    }
  }

  Color get backgroundColor {
    switch (this) {
      case UserStatus.offline:
        return AppColor.babyBlueButton;
      case UserStatus.online:
        return AppColor.dateButton;
      case UserStatus.inProgress:
        return AppColor.grayText;
    }
  }

  ///只切换上线，下线
  UserStatus next() {
    switch (this) {
      case UserStatus.offline:
        return UserStatus.online;
      case UserStatus.online:
        return UserStatus.offline;
      case UserStatus.inProgress:
        return this;
    }

    // var i = index + 1;
    // if (i >= BeautifulStatus.values.length) {
    //   i = 0;
    // }
    // return BeautifulStatus.values[i];
  }
}

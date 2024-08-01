import 'package:flutter/material.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/widgets.dart';

///佳丽状态切换按钮
class BeautifulStatusSwitch extends StatelessWidget {
  final BeautifulStatus status;
  final ValueChanged<BeautifulStatus>? onChange;

  const BeautifulStatusSwitch({
    super.key,
    required this.status,
    this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    Widget text = Text(status.label);
    if (status == BeautifulStatus.offline) {
      text = Text.rich(
        TextSpan(
          style: AppTextStyle.fs12m,
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

///佳丽状态
enum BeautifulStatus {
  ///下线(不接单)
  offline,

  ///上线（接单中）
  online,

  ///约会中
  inProgress,
}

extension on BeautifulStatus {
  String get label {
    switch (this) {
      case BeautifulStatus.offline:
        return '当前不接约';
      case BeautifulStatus.online:
        return '接约中···';
      case BeautifulStatus.inProgress:
        return '约会中';
    }
  }

  Color get backgroundColor {
    switch (this) {
      case BeautifulStatus.offline:
        return AppColor.gray9;
      case BeautifulStatus.online:
        return AppColor.purple6;
      case BeautifulStatus.inProgress:
        return const Color(0xFF4166F2);
    }
  }

  BeautifulStatus next() {
    var i = index + 1;
    if (i >= BeautifulStatus.values.length) {
      i = 0;
    }
    return BeautifulStatus.values[i];
  }
}

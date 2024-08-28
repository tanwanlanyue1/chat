import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/list_extension.dart';
import 'package:guanjia/common/extension/text_style_extension.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';

class CommonBottomSheet extends StatelessWidget {
  /// titles: 名称
  /// onTap: 点击事件
  /// hasCancel: 是否带有默认的取消按钮
  /// autoBack: 点击后是否立即调用Get.back()
  const CommonBottomSheet({
    super.key,
    required this.titles,
    this.onTap,
    this.hasCancel = true,
    this.autoBack = true,
  });

  final List<String> titles;
  final void Function(int index)? onTap;
  final bool hasCancel;
  final bool autoBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: 32.rpx, right: 32.rpx, bottom: Get.mediaQuery.padding.bottom),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8.rpx),
          topRight: Radius.circular(8.rpx),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...List.generate(titles.length, (index) {
            return InkWell(
              child: Container(
                alignment: Alignment.center,
                height: 54.rpx,
                decoration: BoxDecoration(
                  border: !hasCancel && index == titles.length - 1
                      ? null
                      : Border(
                          bottom: BorderSide(
                          width: 1.rpx,
                          color: AppColor.scaffoldBackground,
                        )),
                ),
                child: Text(
                  titles.safeElementAt(index) ?? "",
                  style:
                      AppTextStyle.st.size(14.rpx).textColor(AppColor.black3),
                  textAlign: TextAlign.center,
                ),
              ),
              onTap: () {
                if (autoBack) Get.back();
                if (onTap != null) onTap!(index);
              },
            );
          }),
          if (hasCancel)
            InkWell(
              onTap: Get.back,
              child: Container(
                height: 50.rpx,
                alignment: Alignment.center,
                child: Text(
                  S.current.cancel,
                  style:
                      AppTextStyle.st.size(14.rpx).textColor(AppColor.black9),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

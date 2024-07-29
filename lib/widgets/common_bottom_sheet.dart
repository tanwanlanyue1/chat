import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/extension/list_extension.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

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
          left: 12.rpx, right: 12.rpx, bottom: Get.mediaQuery.padding.bottom),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(14.rpx),
          topRight: Radius.circular(14.rpx),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...List.generate(titles.length, (index) {
            return InkWell(
              child: Container(
                alignment: Alignment.center,
                height: 50.rpx,
                decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          width: 1.rpx, color: const Color(0XffF6F7F9))),
                ),
                child: Text(
                  titles.safeElementAt(index) ?? "",
                  style: TextStyle(
                      fontSize: 14.rpx, color: const Color(0xff323233)),
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
                decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          width: 1.rpx, color: const Color(0XffF6F7F9))),
                ),
                child: Text(
                  '取消',
                  style: TextStyle(
                      fontSize: 14.rpx, color: const Color(0xff999999)),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

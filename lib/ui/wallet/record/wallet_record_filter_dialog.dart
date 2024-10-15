import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/get_extension.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/wallet/record/wallet_record_controller.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/widgets.dart';

///钱包记录筛选对话框
class WalletRecordFilterDialog extends StatelessWidget {
  final List<RecordType> items;

  const WalletRecordFilterDialog._({
    super.key,
    required this.items,
  });

  static Future<RecordType?> show({required List<RecordType> items}) {
    return Get.bottomSheet(
        WalletRecordFilterDialog._(
          items: items,
        ),
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(8.rpx)),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildTitleBar(),
        Padding(
          padding: FEdgeInsets(horizontal: 16.rpx, bottom: 16.rpx + Get.padding.bottom),
          child: Wrap(
            spacing: 8.rpx,
            runSpacing: 8.rpx,
            children: items.map((item) {
              return GestureDetector(
                onTap: () => Get.back(result: item),
                child: Container(
                  padding: FEdgeInsets(horizontal: 16.rpx, vertical: 12.rpx),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.rpx),
                    color: AppColor.background,
                  ),
                  child: Text(
                    item.label,
                    style: AppTextStyle.fs14m.copyWith(
                      color: AppColor.black3,
                      height: 1.0,
                    ),
                  ),
                ),
              );
            }).toList(growable: false),
          ),
        ),
      ],
    );
  }

  Widget buildTitleBar() {
    return Padding(
      padding: FEdgeInsets(left: 16.rpx, vertical: 4.rpx),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '快捷筛选',
              style: AppTextStyle.fs16b.copyWith(
                color: AppColor.blackBlue,
              ),
            ),
          ),
          IconButton(
            onPressed: Get.back,
            icon: AppImage.asset(
              'assets/images/common/close.png',
              width: 24.rpx,
              height: 24.rpx,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/widgets/widgets.dart';

///修改契约单模板对话框
class ContractEditDialog extends StatelessWidget {
  const ContractEditDialog._({super.key});

  static void show() {
    Get.dialog(
      const ContractEditDialog._(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.rpx),
        child: Container(
          width: 311.rpx,
          height: 466.rpx,
          child: Column(
            children: [
              buildTitleBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTitleBar(){
    return Stack(
      children: [
        Padding(
          padding: FEdgeInsets(top: 36.rpx, bottom: 24.rpx),
          child: Text(
            S.current.contractEdit,
            style: AppTextStyle.fs18m.copyWith(
              color: AppColor.gray5,
            ),
          ),
        ),
      ],
    );
  }
}

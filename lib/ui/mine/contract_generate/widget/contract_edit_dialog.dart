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
        child: SizedBox(
          width: 311.rpx,
          height: 466.rpx,
          child: Column(
            children: [
              buildTitleBar(),
              buildInput(),
              Padding(
                padding: FEdgeInsets(horizontal: 16.rpx, vertical: 24.rpx),
                child: CommonGradientButton(
                  height: 50.rpx,
                  text: S.current.updateNow,
                  onTap: Get.back,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTitleBar() {
    return SizedBox(
      width: double.infinity,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Padding(
            padding: FEdgeInsets(vertical: 24.rpx),
            child: Text(
              S.current.contractEdit,
              style: AppTextStyle.fs18m.copyWith(
                color: AppColor.gray5,
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              icon: const Icon(Icons.close, color: AppColor.gray5),
              onPressed: Get.back,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInput() {
    final defaultText =
        '       甲方/乙方双方于今日自愿结成经纪人与艺人系，关系存续期间，甲方负责乙方在管佳APP的约会接单事宜。';
    final controller = TextEditingController(text: defaultText);
    return Expanded(
      child: Padding(
        padding: FEdgeInsets(horizontal: 16.rpx),
        child: TextField(
          controller: controller,
          expands: true,
          maxLines: null,
          style: AppTextStyle.fs14b.copyWith(
            color: AppColor.gray5,
            height: 21 / 14,
          ),
          textAlignVertical: TextAlignVertical.top,
          decoration: InputDecoration(
            fillColor: AppColor.grayF7,
            filled: true,
            contentPadding: FEdgeInsets(horizontal: 16.rpx, vertical: 24.rpx),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(8.rpx),
              gapPadding: 0,
            ),
          ),
        ),
      ),
    );
  }
}

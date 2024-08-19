import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/math_extension.dart';
import 'package:guanjia/common/network/api/model/user/contract_model.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/mine/contract_detail/contract_detail_state.dart';
import 'package:guanjia/widgets/widgets.dart';

///修改契约单模板对话框
class ContractEditDialog extends StatelessWidget {
  final ContractModel contract;

  const ContractEditDialog._({super.key, required this.contract});

  ///修改成功后返回最新的合约模板
  static Future<ContractModel?> show(ContractModel contract) {
    return Get.dialog<ContractModel>(
      ContractEditDialog._(contract: contract),
    );
    // return showDialog<ContractModel>(context: Get.context!, builder: (_) {
    //   return ContractEditDialog._(contract: contract);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          width: 311.rpx,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.rpx),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildTitleBar(),
              Container(
                padding: FEdgeInsets(horizontal: 16.rpx, vertical: 24.rpx),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.rpx),
                  color: AppColor.grayF7,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(contract.content),
                    buildScaleItem(
                      template: contract.brokerageServiceTemplate,
                      placeholder: contract.brokerageServicePlaceholder,
                      value: contract.brokerageService.toPercent(),
                    ),
                    buildScaleItem(
                      template: contract.brokerageChattingTemplate,
                      placeholder: contract.brokerageChattingPlaceholder,
                      value: contract.brokerageChatting.toPercent(),
                    ),
                  ],
                ),
              ),
              // buildInput(),
              Padding(
                padding: FEdgeInsets(horizontal: 16.rpx, vertical: 24.rpx),
                child: CommonGradientButton(
                  height: 50.rpx,
                  text: S.current.updateNow,
                  onTap: () {},
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
    final controller = TextEditingController(text: contract.fullContent);
    return Padding(
      padding: FEdgeInsets(horizontal: 16.rpx),
      child: TextField(
        controller: controller,
        maxLines: 8,
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
    );
  }

  Widget buildScaleItem({
    required String template,
    required String placeholder,
    required String value,
  }) {
    return Padding(
      padding: FEdgeInsets(top: 24.rpx),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildScaleText(
            template: template,
            placeholder: placeholder,
            value: value,
          ),
          buildScaleInput(),
          buildScaleButtons(),
        ],
      ),
    );
  }

  Widget buildScaleText({
    required String template,
    required String placeholder,
    required String value,
  }) {
    final index = template.indexOf(placeholder);
    final children = <TextSpan>[];
    if (index > -1) {
      children.addAll([
        TextSpan(
          text: template.substring(0, index),
        ),
        TextSpan(
          text: value,
          style: const TextStyle(color: AppColor.textYellow),
        ),
        TextSpan(
          text: template.substring(index + placeholder.length),
        ),
      ]);
    } else {
      children.add(TextSpan(
        text: template,
      ));
    }

    return Text.rich(
      style: AppTextStyle.fs12m.copyWith(
        height: 18 / 12,
        color: AppColor.gray5,
      ),
      TextSpan(children: children),
    );
  }

  Widget buildScaleInput({TextEditingController? controller}) {
    return Padding(
      padding: FEdgeInsets(top: 8.rpx),
      child: TextField(
        controller: controller,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        style: AppTextStyle.fs14m.copyWith(
          color: AppColor.gray5,
        ),
        maxLines: 1,
        inputFormatters: [LengthLimitingTextInputFormatter(10)],
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColor.gray9.withOpacity(0.2),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.rpx),
            borderSide: BorderSide.none,
          ),
          hintText: '输入数字0-100%',
          hintStyle: const TextStyle(color: AppColor.gray9),
          prefixIcon: SizedBox(width: 0),
          prefixIconConstraints: BoxConstraints(minHeight: 40.rpx),
          constraints: const BoxConstraints(),
          contentPadding: FEdgeInsets(horizontal: 16.rpx),
          isDense: true,
        ),
      ),
    );
  }

  Widget buildScaleButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [15, 25, 35, 45].map((item) {
        return GestureDetector(
          child: Container(
            width: 50.rpx,
            height: 24.rpx,
            decoration: BoxDecoration(
              color: AppColor.gray9.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4.rpx),
            ),
            child: Text(
              '$item%',
              style: AppTextStyle.fs12m.copyWith(
                color: AppColor.gray5,
              ),
            ),
          ),
        );
      }).toList(growable: false),
    );
  }
}

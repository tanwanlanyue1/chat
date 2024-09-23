import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/get_extension.dart';
import 'package:guanjia/common/extension/math_extension.dart';
import 'package:guanjia/common/network/api/model/user/contract_model.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/mine/contract_detail/contract_detail_state.dart';
import 'package:guanjia/widgets/widgets.dart';

///修改契约单模板对话框
class ContractEditDialog extends StatefulWidget {
  final ContractModel contract;

  const ContractEditDialog._({super.key, required this.contract});

  ///修改成功后返回最新的合约模板
  static Future<ContractModel?> show(ContractModel contract) {
    return Get.dialog<ContractModel>(
      ContractEditDialog._(contract: contract),
    );
  }

  @override
  State<ContractEditDialog> createState() => _ContractEditDialogState();
}

class _ContractEditDialogState extends State<ContractEditDialog> {
  final brokerageServiceController = TextEditingController();
  final brokerageChattingController = TextEditingController();
  late ContractModel contract;
  final brokerageServiceRx = ''.obs;
  final brokerageChattingRx = ''.obs;

  @override
  void initState() {
    super.initState();
    contract = widget.contract;
    brokerageServiceController.bindTextRx(brokerageServiceRx);
    brokerageChattingController.bindTextRx(brokerageChattingRx);
    brokerageServiceController.text =
        contract.brokerageService.toStringAsTrimZero();
    brokerageChattingController.text =
        contract.brokerageChatting.toStringAsTrimZero();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: SingleChildScrollView(
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
                  constraints: BoxConstraints(maxHeight: Get.height - 240.rpx),
                  margin: FEdgeInsets(horizontal: 16.rpx),
                  padding: FEdgeInsets(horizontal: 16.rpx, vertical: 24.rpx),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.rpx),
                    color: AppColor.grayF7,
                  ),
                  child: Obx(() {
                    final brokerageService = '${brokerageServiceRx()}%';
                    final brokerageChatting = '${brokerageChattingRx()}%';
                    return ListView(
                      shrinkWrap: true,
                      children: [
                        Text(contract.content),
                        buildScaleItem(
                          textController: brokerageServiceController,
                          template: contract.brokerageServiceTemplate,
                          placeholder: contract.brokerageServicePlaceholder,
                          value: brokerageService,
                        ),
                        buildScaleItem(
                          textController: brokerageChattingController,
                          template: contract.brokerageChattingTemplate,
                          placeholder: contract.brokerageChattingPlaceholder,
                          value: brokerageChatting,
                        ),
                      ],
                    );
                  }),
                ),
                // buildInput(),
                Padding(
                  padding: FEdgeInsets(horizontal: 16.rpx, vertical: 24.rpx),
                  child: CommonGradientButton(
                    height: 50.rpx,
                    text: S.current.updateNow,
                    onTap: onConfirm,
                  ),
                ),
              ],
            ),
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
    TextEditingController? textController,
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
          buildScaleInput(textController: textController),
          buildScaleButtons(textController: textController),
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

  Widget buildScaleInput({TextEditingController? textController}) {
    return Padding(
      padding: FEdgeInsets(top: 8.rpx),
      child: TextField(
        controller: textController,
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
          hintText: S.current.enterNumber,
          hintStyle: const TextStyle(color: AppColor.gray9),
          prefixIcon: const SizedBox(width: 0),
          prefixIconConstraints: BoxConstraints(minHeight: 40.rpx),
          constraints: const BoxConstraints(),
          contentPadding: FEdgeInsets(horizontal: 16.rpx),
          isDense: true,
        ),
      ),
    );
  }

  Widget buildScaleButtons({TextEditingController? textController}) {
    return Padding(
      padding: FEdgeInsets(top: 12.rpx),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [15.0, 25.0, 35.0, 45.0].map((item) {
          return GestureDetector(
            onTap: () {
              textController?.text = item.toStringAsTrimZero();
            },
            child: Container(
              width: 50.rpx,
              height: 24.rpx,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColor.gray9.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4.rpx),
              ),
              child: Text(
                item.toPercent(scale: 1),
                style: AppTextStyle.fs12m.copyWith(
                  color: AppColor.gray5,
                ),
              ),
            ),
          );
        }).toList(growable: false),
      ),
    );
  }

  void onConfirm(){
    final brokerageService = double.tryParse(brokerageServiceRx()) ?? 0;
    final brokerageChatting = double.tryParse(brokerageChattingRx()) ?? 0;
    if (brokerageService < 0 ||
        brokerageService > 100 ||
        brokerageChatting < 0 ||
        brokerageChatting > 100) {
      Loading.showToast(S.current.ratioCannotNegative);
      return;
    }
    Get.back(
      result: contract.copyWith(
        brokerageService: brokerageService,
        brokerageChatting: brokerageChatting,
      ),
    );
  }
}

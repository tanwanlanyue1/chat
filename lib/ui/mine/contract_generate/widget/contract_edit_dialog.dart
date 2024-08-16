import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/network/api/model/user/contract_model.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/widgets/widgets.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

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

    return Center(
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.rpx),
        child: SizedBox(
          width: 311.rpx,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildTitleBar(),
              // Container(
              //   padding: FEdgeInsets(horizontal: 16.rpx, vertical: 24.rpx),
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(8.rpx),
              //     color: AppColor.grayF7,
              //   ),
              //   child: Column(
              //     mainAxisSize: MainAxisSize.min,
              //     children: [
              //       Text(contract.content),
              //
              //     ],
              //   ),
              // ),
              buildInput(),
              Padding(
                padding: FEdgeInsets(horizontal: 16.rpx, vertical: 24.rpx),
                child: CommonGradientButton(
                  height: 50.rpx,
                  text: S.current.updateNow,
                  onTap: (){

                  },
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
}

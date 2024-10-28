import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/network/api/model/user/contract_model.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/widgets.dart';

///合约解除对话框
class ContractTerminateDialog extends StatelessWidget {
  final ContractModel contract;
  final bool isAgent;

  const ContractTerminateDialog._({
    super.key,
    required this.contract,
    required this.isAgent,
  });

  static Future<bool?> show({required ContractModel contract, required bool isAgent}) {
    return Get.dialog<bool>(
      ContractTerminateDialog._(contract: contract, isAgent: isAgent),
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildTitleBar(),
              Padding(
                padding: FEdgeInsets(horizontal: 16.rpx, bottom: 24.rpx),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isAgent ? S.current.confirmRescissionOrNot(contract.partyBName) : S.current.contractTerminateHint,
                      textAlign: TextAlign.center,
                      style: AppTextStyle.fs16.copyWith(
                        color: AppColor.gray5,
                        height: 24 / 16,
                      ),
                    ),
                    buildAvatar(),
                    CommonGradientButton(
                      height: 50.rpx,
                      text: S.current.confirmTerminate,
                      onTap: () => Get.back(result: true),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTitleBar() {
    return Container(
      alignment: Alignment.topRight,
      child: IconButton(
        icon: const Icon(Icons.close, color: AppColor.gray5),
        onPressed: Get.back,
      ),
    );
  }

  Widget buildAvatar() {
    return Padding(
      padding: FEdgeInsets(top: 24.rpx, bottom: 36.rpx),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildUserAvatar(),
          Padding(
            padding: FEdgeInsets(horizontal: 24.rpx),
            child: AppImage.asset(
              'assets/images/mine/ic_contract_terminate.png',
              width: 35.rpx,
              height: 35.rpx,
            ),
          ),
          buildSelfAvatar(),
        ],
      ),
    );
  }

  Widget buildSelfAvatar() {
    return AppImage.network(
      isAgent ? contract.partyAHead : contract.partyBHead,
      width: 60.rpx,
      height: 60.rpx,
      shape: BoxShape.circle,
    );
  }

  Widget buildUserAvatar() {
    return AppImage.network(
      isAgent ? contract.partyBHead : contract.partyAHead,
      width: 60.rpx,
      height: 60.rpx,
      shape: BoxShape.circle,
    );
  }
}

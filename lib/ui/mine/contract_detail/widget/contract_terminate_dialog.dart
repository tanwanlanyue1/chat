import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/network/api/model/user/contract_model.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/chat/widgets/chat_avatar.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/widgets.dart';

///合约解除对话框
class ContractTerminateDialog extends StatelessWidget {
  final ContractModel contract;

  const ContractTerminateDialog._({
    super.key,
    required this.contract,
  });

  static Future<bool?> show(ContractModel contract) {
    return Get.dialog<bool>(
      ContractTerminateDialog._(contract: contract),
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
                      S.current.contractTerminateHint,
                      style: AppTextStyle.fs16m.copyWith(
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
      SS.login.info?.avatar ?? '',
      width: 60.rpx,
      height: 60.rpx,
      shape: BoxShape.circle,
    );
  }

  Widget buildUserAvatar() {
    return ChatAvatar.circle(
      userId: contract.partyA.toString(),
      width: 60.rpx,
      height: 60.rpx,
    );
  }
}

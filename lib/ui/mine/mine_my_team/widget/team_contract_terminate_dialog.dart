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
class TeamContractTerminateDialog extends StatelessWidget {
  final ContractModel contract;

  const TeamContractTerminateDialog._({
    super.key,
    required this.contract,
  });

  static Future<bool?> show({required ContractModel contract,}) {
    return Get.dialog<bool>(
      TeamContractTerminateDialog._(contract: contract,),
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
                    buildAvatar(),
                    Padding(
                      padding: EdgeInsets.only(bottom: 36.rpx),
                      child: Text(
                        '是否同意佳丽 ${contract.partyBName} 确定解除契约吗？',
                        textAlign: TextAlign.center,
                        style: AppTextStyle.fs16m.copyWith(
                          color: AppColor.gray5,
                          height: 24 / 16,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: (){
                            Get.back();
                          },
                          child: Container(
                            width: 120.rpx,
                            height: 50.rpx,
                            decoration: BoxDecoration(
                              color: AppColor.black9,
                              borderRadius: BorderRadius.circular(8.rpx),
                            ),
                            alignment: Alignment.center,
                            child: Text("取消",style: AppTextStyle.fs16m.copyWith(color: Colors.white),),
                          ),
                        ),
                        SizedBox(
                          width: 120.rpx,
                          child: CommonGradientButton(
                            height: 50.rpx,
                            text: '立即解约',
                            onTap: () => Get.back(result: true),
                          ),
                        ),
                      ],
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
      padding: FEdgeInsets(top: 8.rpx, bottom: 24.rpx),
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
      contract.partyAHead,
      width: 60.rpx,
      height: 60.rpx,
      shape: BoxShape.circle,
    );
  }

  Widget buildUserAvatar() {
    return AppImage.network(
      contract.partyBHead,
      width: 60.rpx,
      height: 60.rpx,
      shape: BoxShape.circle,
    );
  }
}

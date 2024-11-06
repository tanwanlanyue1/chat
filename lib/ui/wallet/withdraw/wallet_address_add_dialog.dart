import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/widgets.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';


///新增钱包地址对话框
class WalletAddressAddDialog extends StatefulWidget {
  const WalletAddressAddDialog._({super.key});

  static Future<String?> show() {
    return Get.dialog<String>(const WalletAddressAddDialog._());
  }


  @override
  State<WalletAddressAddDialog> createState() => _WalletAddressAddDialogState();
}

class _WalletAddressAddDialogState extends State<WalletAddressAddDialog> {

  final addressEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.rpx),
      ),
      content: Stack(
        children: [
          SizedBox(
            width: 311.rpx,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: FEdgeInsets(vertical: 16.rpx),
                  child: Text(
                    S.current.addWalletAddress,
                    style: AppTextStyle.fs18m.copyWith(
                      color: AppColor.blackBlue,
                      height: 1.0,
                    ),
                  ),
                ),
                Divider(height: 1, indent: 16.rpx, endIndent: 16.rpx),
                buildInput(),
                Padding(
                  padding: FEdgeInsets(
                    horizontal: 16.rpx,
                    top: 24.rpx,
                    bottom: 24.rpx,
                  ),
                  child: CommonGradientButton(
                    height: 50.rpx,
                    text: S.current.firmCommit,
                    onTap: () => Get.back(result: addressEditingController.text),
                  ),
                )
              ],
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              onPressed: Get.back,
              icon: AppImage.asset(
                'assets/images/common/close.png',
                width: 24.rpx,
                height: 24.rpx,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInput() {
    final border = OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(8.rpx),
    );
    return Padding(
      padding: FEdgeInsets(horizontal: 16.rpx, top: 24.rpx),
      child: TextField(
        controller: addressEditingController,
        style: AppTextStyle.fs12.copyWith(
          color: AppColor.black3,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColor.grayBackground,
          border: border,
          enabledBorder: border,
          focusedBorder: border,
          hintText: S.current.inputWalletAddress,
          hintStyle: AppTextStyle.fs12.copyWith(
            color: AppColor.black9,
          ),
          contentPadding: FEdgeInsets(horizontal: 12.rpx, vertical: 14.rpx),
        ),
      ),
    );
  }
}

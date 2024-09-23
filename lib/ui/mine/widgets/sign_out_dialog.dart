import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/text_style_extension.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/widgets.dart';

///退出登录对话框
class SignOutDialog extends StatelessWidget {
  const SignOutDialog._({super.key});

  static Future<bool?> show() {
    return Get.dialog<bool>(
      const SignOutDialog._(),
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
                    Text(
                      S.current.areYouSure,
                      style: AppTextStyle.fs18b.copyWith(
                        color: AppColor.blackBlue,
                      ),
                    ),
                    Padding(
                      padding: FEdgeInsets(top: 12.rpx, bottom: 24.rpx),
                      child: Text(
                       S.current.afterLoggingOut,
                        style: AppTextStyle.fs12b.copyWith(
                          color: AppColor.blackText,
                          height: 1.5,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CommonGradientButton(
                          height: 50.rpx,
                          width: 120.rpx,
                          text: S.current.cancel,
                          onTap: Get.back,
                          textStyle: AppTextStyle.fs16m.copyWith(color: Colors.white),
                        ),
                        Button(
                          onPressed: () => Get.back(result: true),
                          height: 50.rpx,
                          width: 120.rpx,
                          backgroundColor: AppColor.gray9,
                          child: Text(
                            S.current.sureLogOut,
                            style: AppTextStyle.fs16m
                          ),
                        ),
                      ],
                    )
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
      padding: FEdgeInsets(top: 4.rpx, right: 4.rpx),
      child: IconButton(
        icon: const Icon(Icons.close, color: AppColor.gray5),
        onPressed: Get.back,
      ),
    );
  }

  Widget buildAvatar() {
    return Padding(
      padding: FEdgeInsets(bottom: 16.rpx),
      child: AppImage.network(
        SS.login.info?.avatar ?? '',
        width: 60.rpx,
        height: 60.rpx,
        shape: BoxShape.circle,
      ),
    );
  }
}

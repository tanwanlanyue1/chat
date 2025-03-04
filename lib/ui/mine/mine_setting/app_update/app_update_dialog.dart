import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/mine/mine_setting/push_setting/notification_permission_util.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/widgets.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'app_update_manager.dart';

///APP版本更新
class AppUpdateDialog extends StatelessWidget {
  static var _visible = false;
  final AppUpdateVersionModel info;
  final bool userAction;

  AppUpdateManager get updateManager => AppUpdateManager.instance;

  const AppUpdateDialog._({
    super.key,
    required this.info,
    required this.userAction,
  });

  ///显示版本更新对话框
  ///- info 更新信息
  ///- userAction 是否是用户主动点击检测更新
  static void show({
    required AppUpdateVersionModel info,
    bool userAction = false,
  }) {
    if (!_visible) {
      _visible = true;
      Get.dialog(
        barrierDismissible: info.force != 1,
        AppUpdateDialog._(info: info, userAction: userAction),
      ).whenComplete(() => _visible = false);
    }
  }

  void dismiss() {
    if (_visible) {
      _visible = false;
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: isCancelable,
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: Stack(
            children: [
              _buildContent(),
              if (isCancelable) _buildCloseIcon(),
            ],
          ),
        ),
      ),
    );
  }

  bool get isCancelable => info.force != 1;

  Widget _buildContent() {
    return Container(
      width: 311.rpx,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.rpx),
        color: Colors.white,
      ),
      padding: FEdgeInsets(horizontal: 16.rpx, top: 36.rpx, bottom: 24.rpx),
      child: Obx(() {
        final downloadInfo = updateManager.downloadUpdateInfoRx();
        final isDownloadFinish = updateManager.downloadProgressRx() == 100;
        final isSingleButton = !isCancelable || isDownloadFinish;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              S.current.discoverNewVersion,
              style: AppTextStyle.fs18m.copyWith(
                color: AppColor.blackBlue,
                height: 1,
              ),
            ),
            Spacing.h16,
            Container(
              width: double.infinity,
              padding: FEdgeInsets(all: 16.rpx),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.rpx),
                color: AppColor.background,
              ),
              child: Text(
                info.content,
                style: AppTextStyle.fs14.copyWith(
                  color: AppColor.blackBlue,
                ),
              ),
            ),
            Spacing.h24,
            if (downloadInfo == null)
              Row(
                mainAxisAlignment: !isSingleButton
                    ? MainAxisAlignment.spaceBetween
                    : MainAxisAlignment.center,
                children: [
                  if (!isSingleButton)
                    Button(
                      onPressed: dismiss,
                      height: 50.rpx,
                      width: 120.rpx,
                      backgroundColor: AppColor.gray9,
                      child: Text(S.current.ignoreForNow, style: AppTextStyle.fs16),
                    ),
                  CommonGradientButton(
                    height: 50.rpx,
                    width: isSingleButton ? 260.rpx : 120.rpx,
                    text: isDownloadFinish ? S.current.immediateInstallation : S.current.upgradeNow,
                    onTap: () {
                      if (info.flag == 2 &&
                          info.link.trim().startsWith('http')) {
                        //有通知栏显示进度，且不是强制更新时，才需要隐藏对话框
                        if (isCancelable &&
                            NotificationPermissionUtil.instance.isGrantedRx()) {
                          dismiss();
                        }
                        updateManager.downloadAndInstall(info);
                      } else {
                        _jumpToAppMarket();
                      }
                    },
                    textStyle: AppTextStyle.fs16.copyWith(color: Colors.white),
                  ),
                ],
              ),
            if (downloadInfo != null && (NotificationPermissionUtil.instance.isGrantedRx.isFalse || !isCancelable))
              _buildDownloadProgress(),
          ],
        );
      }),
    );
  }

  Widget _buildDownloadProgress() {
    final buttonSize = Size(230.rpx, 36.rpx);
    return ClipRRect(
      clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.circular(buttonSize.height / 2),
      child: ObxValue<Rxn<int>>((progressRx) {
          final progress = progressRx() ?? 0;
          return Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: buttonSize.width,
                height: buttonSize.height,
                color: const Color(0xFFCCCCCC),
              ),
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  width: buttonSize.width * (progress/100),
                  height: buttonSize.height,
                  color: AppColor.primaryBlue,
                ),
              ),
              Text(
                '${S.current.downloadingProgress} $progress%',
                textAlign: TextAlign.center,
                style: AppTextStyle.fs14.copyWith(
                  color: Colors.white,
                ),
              ),
            ],
          );
        },
        updateManager.downloadProgressRx,
      ),
    );
  }

  ///跳转应用市场
  void _jumpToAppMarket() async {
    final packageName = (await PackageInfo.fromPlatform()).packageName;
    launchUrlString('market://details?id=$packageName');
  }

  Widget _buildCloseIcon() {
    return Positioned(
      top: 0,
      right: 0,
      child: GestureDetector(
        onTap: dismiss,
        behavior: HitTestBehavior.translucent,
        child: Container(
          alignment: Alignment.center,
          width: 40.rpx,
          height: 40.rpx,
          child: Icon(
            Icons.close,
            color: AppColor.black3,
            size: 22.rpx,
          ),
        ),
      ),
    );
  }
}

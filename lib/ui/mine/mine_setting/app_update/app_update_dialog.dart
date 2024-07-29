import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      canPop: info.force != 1,
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: Stack(
            children: [
              _buildContent(),
              if (info.force != 1) _buildCloseIcon(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      width: 326.rpx,
      height: 203.rpx,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AppAssetImage('assets/images/mine/update_bg.png')
        )
      ),
      padding: FEdgeInsets(all: 20.rpx),
      child: ObxValue<Rxn<AppUpdateVersionModel>>((downloadInfoRx) {
        final downloadInfo = downloadInfoRx();
        final isCancelable = info.force != 1 && downloadInfo == null;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '发现新版本',
              style: AppTextStyle.fs18b.copyWith(
                color: AppColor.gray5,
                height: 22 / 16,
              ),
            ),
            Spacing.h8,
            Expanded(
              child: SingleChildScrollView(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    info.content,
                    style: AppTextStyle.fs12m.copyWith(
                      color: AppColor.gray5,
                      height: 24 / 13,
                    ),
                  ),
                ),
              ),
            ),
            Spacing.h8,
            if (downloadInfo == null)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isCancelable) ...[
                    Button.image(
                      image: AppImage.asset('assets/images/mine/btn_ignore_update.png', fit: BoxFit.fill,),
                      width: 117.rpx,
                      height: 35.rpx,
                      child: Text(userAction ? '暂不更新' : '忽略'),
                      onPressed: () {
                        if (!userAction) {
                          updateManager.setIgnoreUpdate(info.version);
                        }
                        dismiss();
                      },
                    ),
                    Spacing.w(30),
                  ],
                  Button.image(
                    image: AppImage.asset('assets/images/mine/btn_update_now.png', fit: BoxFit.fill,),
                    width: 117.rpx,
                    height: 35.rpx,
                    child: const Text('马上升级'),
                    onPressed: () {
                      if (info.flag == 2 &&
                          info.link.trim().startsWith('http')) {
                        updateManager.downloadAndInstall(info);
                      } else {
                        _jumpToAppMarket();
                      }
                    },
                  )
                ],
              ),
            if (downloadInfo != null) _buildDownloadProgress(),
          ],
        );
      }, updateManager.downloadUpdateInfoRx),
    );
  }

  ///跳转应用市场
  void _jumpToAppMarket() async {
    final packageName = (await PackageInfo.fromPlatform()).packageName;
    launchUrlString('market://details?id=$packageName');
    // launchUrlString('market://details?id=com.hl.tbsport');
  }

  Widget _buildDownloadProgress() {
    final buttonSize = Size(230.rpx, 35.rpx);
    return ClipRRect(
      clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.circular(buttonSize.height / 2),
      child: ObxValue<RxDouble>(
        (progressRx) {
          final progress = progressRx();
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
                  width: buttonSize.width * progress,
                  height: buttonSize.height,
                  color: AppColor.primary,
                ),
              ),
              Text(
                '正在下载... ${(progress * 100).toStringAsFixed(0)}%',
                textAlign: TextAlign.center,
                style: AppTextStyle.fs14m.copyWith(
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

  Widget _buildCloseIcon() {
    return Positioned(
      top: 0,
      right: 0,
      child: GestureDetector(
        onTap: dismiss,
        behavior: HitTestBehavior.translucent,
        child: Container(
          alignment: Alignment.center,
          width: 48.rpx,
          height: 48.rpx,
          child: Icon(
            Icons.close,
            color: AppColor.gray5,
            size: 18.rpx,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/widgets/widgets.dart';

///展示弹窗
class ShowDialog extends StatelessWidget {
  Widget child;
  Function()? callBack;
  ShowDialog({super.key,required this.child,this.callBack});

  static Future<bool?> show({required Widget child,Function()? callBack}) {
    return Get.dialog<bool>(
      ShowDialog(
        callBack: callBack,
        child: child,
      ),
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
              child,
              Padding(
                padding: FEdgeInsets(horizontal: 16.rpx, bottom: 24.rpx),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CommonGradientButton(
                          height: 50.rpx,
                          width: 120.rpx,
                          text: S.current.cancel,
                          onTap: Get.back,
                          textStyle: AppTextStyle.fs16.copyWith(color: Colors.white),
                        ),
                        Button(
                          onPressed: ()=>callBack?.call(),
                          height: 50.rpx,
                          width: 120.rpx,
                          backgroundColor: AppColor.gray9,
                          child: Text(
                              S.current.confirm,
                              style: AppTextStyle.fs16
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

}


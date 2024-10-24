import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/chat/widgets/chat_avatar.dart';
import 'package:guanjia/ui/chat/widgets/chat_user_builder.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/widgets.dart';

///客户发起约会-弹窗
class OrderCreateDialog extends StatelessWidget {
  final int userId;

  const OrderCreateDialog._({super.key, required this.userId});

  ///- true 确认发起， false取消
  static Future<bool> show({required int userId}) async{
    final ret = await Get.dialog<bool>(
      OrderCreateDialog._(
        userId: userId,
      ),
    );
    return ret == true;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 311.rpx,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8.rpx)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: Get.back,
                icon: AppImage.asset(
                  'assets/images/common/close.png',
                  width: 24.rpx,
                  height: 24.rpx,
                ),
              ),
            ),
            Wrap(
              spacing: -13.rpx,
              children: [
                buildUserAvatar(),
                buildSelfAvatar(),
              ],
            ),
            Padding(
              padding: FEdgeInsets(top: 14.rpx, horizontal: 16.rpx),
              child: buildDesc(),
            ),
            Padding(
              padding: FEdgeInsets(horizontal: 16.rpx, top: 36.rpx, vertical: 24.rpx),
              child: CommonGradientButton(
                height: 50.rpx,
                text: S.current.initiateAppointment,
                onTap: () => Get.back(result: true),
              ),
            )
          ],
        ),
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
      userId: userId.toString(),
      size: 60.rpx,
    );
  }

  Widget buildDesc() {
    return ChatUserBuilder(userId: userId.toString(), builder: (info){
      return Text(
        S.current.sureToInitiateDateWith(info?.baseInfo.userName ?? ''),
        textAlign: TextAlign.center,
        style: AppTextStyle.fs14b.copyWith(
          color: AppColor.blackBlue,
          height: 1.5,
        ),
      );
    });
  }
}

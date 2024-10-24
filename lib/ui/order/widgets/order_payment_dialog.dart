import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/math_extension.dart';
import 'package:guanjia/common/network/api/model/order/order_list_model.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/chat/widgets/chat_avatar.dart';
import 'package:guanjia/ui/chat/widgets/chat_user_builder.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/widgets.dart';

///缴纳保证金、服务费对话框
class OrderPaymentDialog extends StatelessWidget {
  final OrderItemModel order;

  const OrderPaymentDialog._({super.key, required this.order});

  ///- return true 跳转缴纳
  static Future<bool?> show({required OrderItemModel order}) {
    return Get.dialog<bool>(
      OrderPaymentDialog._(order: order),
    );
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
            SS.login.userId == order.requestId ? requestView() : receiveView(),
            Padding(
              padding: FEdgeInsets(all: 16.rpx, vertical: 24.rpx),
              child: CommonGradientButton(
                height: 50.rpx,
                text: S.current.goToPay,
                onTap: () {
                  Get.back(result: true);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///订单发起方(缴纳保证金和服务费)
  Widget requestView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
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
        Container(
          decoration: BoxDecoration(
            color: AppColor.background,
            borderRadius: BorderRadius.all(Radius.circular(8.rpx)),
          ),
          margin: FEdgeInsets(horizontal: 16.rpx, top: 16.rpx),
          padding: EdgeInsets.all(24.rpx),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    S.current.serviceCharge,
                    style: AppTextStyle.fs14m.copyWith(color: AppColor.black6),
                  ),
                  Text(
                    order.serviceCharge.toCurrencyString(),
                    style: AppTextStyle.fs14b.copyWith(color: AppColor.blackBlue),
                  ),
                ],
              ),
              Padding(
                padding: FEdgeInsets(vertical: 16.rpx),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      S.current.earnestMoney,
                      style:
                          AppTextStyle.fs14m.copyWith(color: AppColor.black6),
                    ),
                    Text(
                      order.deposit.toCurrencyString(),
                      style:
                          AppTextStyle.fs14b.copyWith(color: AppColor.primaryBlue),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Padding(
                padding: FEdgeInsets(top: 16.rpx),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      S.current.totalCost,
                      style:
                          AppTextStyle.fs14m.copyWith(color: AppColor.black6),
                    ),
                    Text(
                      (order.deposit + order.serviceCharge).toCurrencyString(),
                      style: AppTextStyle.fs14b.copyWith(color: AppColor.blackBlue),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  ///订单接收方（缴纳保证金）
  Widget receiveView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: FEdgeInsets(top: 12.rpx, horizontal: 16.rpx),
          child: Text(
            S.current.securityDepositHint(order.deposit.toCurrencyString()),
            textAlign: TextAlign.center,
            style: AppTextStyle.fs16b.copyWith(color: AppColor.blackBlue, height: 1.5),
          ),
        ),
        Padding(
          padding: FEdgeInsets(top: 12.rpx, horizontal: 16.rpx),
          child: Text(
            S.current.noteDepositWillBeRefunded,
            textAlign: TextAlign.start,
            style: AppTextStyle.fs12m.copyWith(
              color: AppColor.gray9,
              height: 1.0,
            ),
          ),
        ),
      ],
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
      userId: order.receiveId.toString(),
      size: 60.rpx,
    );
  }

  Widget buildDesc() {
    return ChatUserBuilder(
        userId: order.receiveId.toString(),
        builder: (info) {
          var text = '';
          if (order.type.isNormal) {
            text = S.current.haveAgreedYourInvitation(info?.baseInfo.userName ?? '');
          } else {
            text = S.current.haveAgreedYourDate(info?.baseInfo.userName ?? '');
          }
          return Text(
            text,
            textAlign: TextAlign.center,
            style: AppTextStyle.fs16b.copyWith(
              color: AppColor.blackBlue,
              height: 1.5,
            ),
          );
        });
  }
}

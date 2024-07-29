import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_config.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/int_extension.dart';
import 'package:guanjia/common/extension/iterable_extension.dart';
import 'package:guanjia/common/extension/list_extension.dart';
import 'package:guanjia/common/extension/text_style_extension.dart';
import 'package:guanjia/common/payment/model/payment_enum.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/web/web_page.dart';

import 'mine_purchase_controller.dart';

class MinePurchasePage extends StatelessWidget {
  MinePurchasePage({super.key});

  final controller =
      Get.put<MinePurchaseController>(MinePurchaseController.create());
  final state = Get.find<MinePurchaseController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColor.brown14,
      appBar: AppBar(
        title: const Text("充值"),
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          AppImage.asset(
            "assets/images/mine/purchase_bg.png",
            height: 202.rpx,
          ),
          SafeArea(
            bottom: false,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 12.rpx),
              children: [
                _goldNumberWidget(),
                _paymentPriceWidget(),
                if (Platform.isAndroid) _customPaymentWidget(),
                if (Platform.isAndroid) _paymentTypeWidget(),
                _serviceWidget(),
                _paymentButtonWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _customPaymentWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            height: 46.rpx,
            margin: EdgeInsets.only(top: 12.rpx),
            padding: EdgeInsets.symmetric(horizontal: 8.rpx),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColor.brown2,
              borderRadius: BorderRadius.circular(8.rpx),
            ),
            child: Row(
              children: [
                Text(
                  "自定义充值",
                  style: AppTextStyle.st.size(14.rpx).textColor(AppColor.gray5),
                ),
                SizedBox(width: 8.rpx),
                Expanded(
                  child: TextField(
                    controller: controller.customQuantityInputController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter(RegExp("[0-9]"), allow: true),
                      LengthLimitingTextInputFormatter(10)
                    ],
                    decoration: InputDecoration(
                      hintText: "请输入充值境修币数量",
                      hintStyle: AppTextStyle.st
                          .size(14.rpx)
                          .textColor(AppColor.gray9),
                      labelStyle: AppTextStyle.st
                          .size(14.rpx)
                          .textColor(AppColor.gray5),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
              ],
            )),
        SizedBox(height: 8.rpx),
        Obx(() {
          return Text(
            state.appConfigRx()?.payGoldRule ?? '',
            style: AppTextStyle.st.medium
                .size(12.rpx)
                .textColor(const Color(0xFFBBBBBB)),
          );
        }),
      ],
    );
  }

  Container _paymentButtonWidget() {
    return Container(
      margin: EdgeInsets.only(bottom: 20.rpx),
      alignment: Alignment.center,
      child: Obx(() {
        final amount = controller.paymentState.payableAmountRx();
        var text = '立即支付';
        if (amount > 0) {
          text += ' ${amount.toCoinString()} 元';
        }
        return GestureDetector(
          onTap: controller.payNow,
          child: Container(
            width: 200.rpx,
            height: 40.rpx,
            decoration: BoxDecoration(
              color: const Color(0xFF8D310F),
              borderRadius: BorderRadius.circular(20.rpx),
            ),
            alignment: Alignment.center,
            child: Text(
              text,
              style: AppTextStyle.fs16b.copyWith(color: Colors.white),
            ),
          ),
        );
      }),
    );
  }

  Container _serviceWidget() {
    return Container(
      margin: EdgeInsets.only(top: 12.rpx, bottom: 20.rpx),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: "充值即视为同意",
              style: AppTextStyle.notoSerifSC.copyWith(
                color: const Color(0xFF999999),
                fontSize: 12.rpx,
                fontWeight: FontWeight.w500,
              ),
              children: [
                TextSpan(
                  text: "《充值服务协议》",
                  style: TextStyle(
                    color: AppColor.red1,
                    fontSize: 12.rpx,
                    fontWeight: FontWeight.w500,
                  ),
                  //点击事件
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      WebPage.go(
                          url: AppConfig.urlRechargeService, title: '充值服务协议');
                    },
                )
              ],
            ),
          ),
          SizedBox(height: 12.rpx),
          Container(
            padding: EdgeInsets.only(
                top: 8.rpx, bottom: 12.rpx, left: 12.rpx, right: 12.rpx),
            decoration: BoxDecoration(
              color: AppColor.gray99,
              borderRadius: BorderRadius.circular(8.rpx),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "温馨提示",
                  style: TextStyle(
                    color: const Color(0xFF666666),
                    fontSize: 12.rpx,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 6.rpx),
                Text(
                  "注:充值成功后，到账可能有一定的延迟，请耐心等候:境修币一经充值成功不支持退款、提现等操作;境修币充值和消费过程中遇到问题，请及时联系客服。客服时间：09:30-22:00",
                  style: TextStyle(
                    color: const Color(0xFF999999),
                    fontSize: 12.rpx,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Container _paymentTypeWidget() {
    return Container(
      padding: EdgeInsets.only(top: 16.rpx),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "支付方式",
            textAlign: TextAlign.center,
            style: AppTextStyle.fs16m.copyWith(color: AppColor.gray5),
          ),
          Obx(() {
            final paymentState = controller.paymentState;
            final list = paymentState.paymentChannelListRx();
            final selectedChannelType = paymentState.selectedChannelTypeRx();
            return Container(
              margin: EdgeInsets.only(top: 11.rpx),
              decoration: BoxDecoration(
                color: AppColor.brown2,
                borderRadius: BorderRadius.circular(8.rpx),
              ),
              child: Column(
                children: list
                    .map<Widget>((item) {
                      final isSelect = item.channelType == selectedChannelType;
                      return GestureDetector(
                        onTap: () {
                          paymentState.selectedChannelTypeRx.value =
                              item.channelType;
                        },
                        behavior: HitTestBehavior.opaque,
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12.rpx, vertical: 8.rpx),
                              child: Row(
                                children: [
                                  AppImage.asset(
                                    item.channelType.icon,
                                    width: 24.rpx,
                                    height: 24.rpx,
                                  ),
                                  SizedBox(width: 8.rpx),
                                  Expanded(
                                    child: Text(
                                      item.channelType.label,
                                      style: TextStyle(
                                        color: const Color(0xFF333333),
                                        fontSize: 14.rpx,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  AppImage.asset(
                                    isSelect
                                        ? "assets/images/mine/purchase_choose_select.png"
                                        : "assets/images/mine/purchase_choose_normal.png",
                                    width: 16.rpx,
                                    height: 16.rpx,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    })
                    .separated(const Divider(height: 0))
                    .toList(),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _paymentPriceWidget() {
    return Obx(() {
      return Container(
        decoration: BoxDecoration(
          color: AppColor.brown2,
          borderRadius: BorderRadius.circular(8.rpx),
        ),
        child: GridView.builder(
          padding: EdgeInsets.symmetric(vertical: 20.rpx, horizontal: 12.rpx),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 10.rpx,
            crossAxisSpacing: 13.rpx,
            mainAxisExtent: 100.rpx,
          ),
          itemCount: state.rechargeAmountListRx.length,
          itemBuilder: (_, index) {
            final item = state.rechargeAmountListRx.safeElementAt(index);
            if (item == null) {
              return const SizedBox.shrink();
            }

            return GestureDetector(
              onTap: () => controller.onTapConfig(item.id),
              child: Obx(() {
                final isSelect = item.id == state.selectedAmountItemRx?.id;

                final tipText = item.giveText;

                return Container(
                  decoration: BoxDecoration(
                    color: isSelect ? AppColor.brown8 : AppColor.brown14,
                    borderRadius: BorderRadius.circular(8.rpx),
                    border: Border.all(
                        color: isSelect ? AppColor.primary : AppColor.brown37,
                        width: isSelect ? 1.5.rpx : 1.rpx),
                  ),
                  child: Stack(
                    children: [
                      Visibility(
                        visible: tipText.isNotEmpty,
                        child: Container(
                          width: 74.rpx,
                          height: 20.rpx,
                          decoration: BoxDecoration(
                              color: AppColor.primary,
                              borderRadius: BorderRadius.only(
                                topLeft:
                                    Radius.circular(isSelect ? 6.5.rpx : 7.rpx),
                                bottomRight: Radius.circular(16.rpx),
                              )),
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(horizontal: 6.rpx),
                          child: FittedBox(
                            child: Text(
                              tipText,
                              textAlign: TextAlign.center,
                              style: AppTextStyle.st.medium
                                  .size(12.rpx)
                                  .textColor(Colors.white),
                            ),
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AppImage.asset(
                                "assets/images/disambiguation/repair.png",
                                width: 20.rpx,
                                height: 20.rpx,
                              ),
                              SizedBox(width: 8.rpx),
                              Text(
                                item.coinValue.toString(),
                                textAlign: TextAlign.center,
                                style: AppTextStyle.fs20m.copyWith(
                                    color: isSelect
                                        ? AppColor.primary
                                        : AppColor.gray5),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 6.rpx,
                          ),
                          Text(
                            item.price.toCoinString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color:
                                  isSelect ? AppColor.primary : AppColor.gray9,
                              fontSize: 16.rpx,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
            );
          },
        ),
      );
    });
  }

  Container _goldNumberWidget() {
    return Container(
      height: 90.rpx,
      padding: EdgeInsets.only(left: 16.rpx),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 6.rpx),
            child: Text(
              "境修币",
              style: AppTextStyle.fs14m
                  .copyWith(color: AppColor.gray9, height: 1.5),
            ),
          ),
          Obx(() {
            return Text(
              controller.loginService.levelMoneyInfo?.money.toString() ?? "0",
              style: AppTextStyle.fs24m.copyWith(color: AppColor.gray5),
            );
          }),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_constant.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/get_extension.dart';
import 'package:guanjia/common/extension/text_style_extension.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/order/enum/order_enum.dart';
import 'package:guanjia/ui/order/model/order_detail.dart';
import 'package:guanjia/ui/order/order_detail/widget/order_detail_operation_buttons.dart';
import 'package:guanjia/widgets/app_back_button.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/system_ui.dart';
import 'package:guanjia/widgets/title_space_between_widget.dart';

import 'order_detail_controller.dart';

class OrderDetailPage extends StatelessWidget {
  OrderDetailPage({super.key});

  final controller = Get.find<OrderDetailController>();
  final state = Get.find<OrderDetailController>().state;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final model = state.detailModel.value;
      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text(
            '订单详情',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.transparent,
          systemOverlayStyle: SystemUI.lightStyle,
          leading: AppBackButton.light(),
          actions: [
            if (model != null && model.hasCancel)
              GestureDetector(
                onTap: () {
                  controller.onTapOrderCancel(model.id);
                },
                child: Container(
                  padding: EdgeInsets.only(right: 16.rpx),
                  alignment: Alignment.center,
                  child: Text(
                    '取消订单',
                    style: AppTextStyle.st.medium
                        .size(14.rpx)
                        .textColor(Colors.white),
                  ),
                ),
              ),
          ],
        ),
        body: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AppImage.asset(
                "assets/images/order/detail_top_bg.png",
                height: Get.padding.top + kNavigationBarHeight + 162.rpx,
                fit: BoxFit.fill,
              ),
            ),
            if (model != null)
              Positioned.fill(
                child: SafeArea(
                  child: _buildContent(model),
                ),
              ),
          ],
        ),
      );
    });
  }

  Column _buildContent(OrderDetail model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16.rpx)
              .copyWith(top: 16.rpx, bottom: 24.rpx),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                model.stateText,
                style:
                    AppTextStyle.st.medium.size(20.rpx).textColor(Colors.white),
                maxLines: 2,
              ),
              SizedBox(height: 8.rpx),
              Text(
                model.stateDetailText,
                style:
                    AppTextStyle.st.medium.size(14.rpx).textColor(Colors.white),
                maxLines: 2,
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16.rpx),
            child: Container(
              width: Get.width - 32.rpx,
              constraints: BoxConstraints(
                minHeight: (Get.width - 32.rpx) * 486 / 343,
              ),
              padding:
                  EdgeInsets.symmetric(horizontal: 16.rpx, vertical: 16.rpx),
              decoration: BoxDecoration(
                image: AppDecorations.backgroundImage(
                  "assets/images/order/detail_content_bg.png",
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Column(
                        children: model.upDisplayTypes
                            .map(
                                (e) => _buildUpTitleSpaceBetweenWidget(item: e))
                            .toList(),
                      ),
                      if (model.hasDivider)
                        Divider(
                          height: 33.rpx,
                          color: AppColor.scaffoldBackground,
                        ),
                      Column(
                        children: model.downDisplayTypes
                            .map((e) =>
                                _buildDownTitleSpaceBetweenWidget(item: e))
                            .toList(),
                      ),
                      SizedBox(height: 16.rpx),
                    ],
                  ),
                  if (model.bottomTipText != null)
                    Text(
                      model.bottomTipText ?? "",
                      style: AppTextStyle.st
                          .size(12.rpx)
                          .textColor(AppColor.black9),
                    ),
                ],
              ),
            ),
          ),
        ),
        OrderDetailOperationButtons(model: model),
      ],
    );
  }

  TitleSpaceBetweenWidget _buildUpTitleSpaceBetweenWidget(
      {required OrderDetailItem item}) {
    final avatar = item.avatar;

    Color? detailColor;
    if (item.displayType == OrderDetailDisplayType.reason) {
      detailColor = AppColor.textRed;
    }

    return TitleSpaceBetweenWidget(
      height: 30.rpx,
      title: item.title,
      detail: item.detail,
      detailColor: detailColor,
      detailLeading: avatar != null
          ? Padding(
              padding: EdgeInsets.only(right: 8.rpx),
              child: AppImage.network(
                avatar,
                length: 24.rpx,
                shape: BoxShape.circle,
              ),
            )
          : null,
    );
  }

  TitleSpaceBetweenWidget _buildDownTitleSpaceBetweenWidget({
    required OrderDetailItem item,
    Color? detailColor,
    double? detailSize,
  }) {
    if (item.displayType == OrderDetailDisplayType.amount) {
      detailColor = AppColor.textYellow;
      detailSize = 16.rpx;
    }

    return TitleSpaceBetweenWidget(
      height: 30.rpx,
      title: item.title,
      titleColor: AppColor.black9,
      detail: item.detail,
      detailSize: detailSize,
      detailColor: detailColor ?? AppColor.black3,
    );
  }
}

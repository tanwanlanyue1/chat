import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/text_style_extension.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/order/enum/order_enum.dart';
import 'package:guanjia/ui/order/order_list/order_list_controller.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/common_gradient_button.dart';

class OrderOperationButtons extends StatelessWidget {
  OrderOperationButtons({
    super.key,
    required this.type,
    required this.operationType,
  });

  final OrderListType type;

  final OrderOperationType operationType;

  late final controller = Get.find<OrderListController>(tag: type.name);

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];

    switch (operationType) {
      case OrderOperationType.confirm:
        children.addAll([
          _buildCancel(),
          SizedBox(width: 24.rpx),
          _buildButton(
            onTap: controller.onTapConfirm,
            text: "立即接单",
          ),
        ]);
        break;
      case OrderOperationType.assign:
        children.addAll([
          _buildCancel(),
          SizedBox(width: 24.rpx),
          _buildButton(
            onTap: controller.onTapAssign,
            text: "指派接单",
          ),
        ]);
        break;
      case OrderOperationType.payment:
        children.addAll([
          _buildCancel(),
          SizedBox(width: 24.rpx),
          _buildButton(
            onTap: controller.onTapPayment,
            text: "立即缴纳",
          ),
        ]);
        break;
      case OrderOperationType.finish:
        children.addAll([
          _buildCancel(),
          SizedBox(width: 24.rpx),
          _buildButton(
            onTap: controller.onTapFinish,
            text: "确认完成",
          ),
        ]);
        break;
      case OrderOperationType.cancel:
        children.add(_buildCancel());
        break;
      case OrderOperationType.connect:
        children.add(_buildConnect());
        break;
      case OrderOperationType.evaluation:
        children.add(_buildButton(
          onTap: controller.onTapEvaluation,
          text: "立即评价",
        ));
        break;
      case OrderOperationType.none:
        break;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: children,
    );
  }

  Widget _buildCancel() {
    return GestureDetector(
      onTap: controller.onTapCancel,
      child: Container(
        width: 60.rpx,
        height: 26.rpx,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.rpx),
          border: Border.all(
            color: AppColor.black9,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          "取消订单",
          style: AppTextStyle.st.size(12.rpx).textColor(AppColor.black6),
        ),
      ),
    );
  }

  Widget _buildButton({
    required VoidCallback? onTap,
    required String text,
  }) {
    return CommonGradientButton(
      onTap: onTap,
      text: text,
      width: 60.rpx,
      height: 26.rpx,
      borderRadius: BorderRadius.circular(4.rpx),
      textStyle: AppTextStyle.st.size(12.rpx).textColor(Colors.white),
    );
  }

  Widget _buildConnect() {
    return GestureDetector(
      onTap: controller.onTapConnect,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 48.rpx,
        height: 40.rpx,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppImage.asset(
              "assets/images/common/contact.png",
              length: 20.rpx,
            ),
            Text(
              "联系佳丽",
              style: AppTextStyle.st.medium
                  .size(12.rpx)
                  .textColor(AppColor.textPurple),
            ),
          ],
        ),
      ),
    );
  }
}

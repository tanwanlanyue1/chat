import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/order/enum/order_enum.dart';
import 'package:guanjia/ui/order/model/order_detail.dart';
import 'package:guanjia/ui/order/order_detail/order_detail_controller.dart';
import 'package:guanjia/widgets/common_gradient_button.dart';

class OrderDetailOperationButtons extends StatelessWidget {
  OrderDetailOperationButtons({
    super.key,
    required this.model,
  });

  final OrderDetail model; // 订单详情模型数据

  late final controller = Get.find<OrderDetailController>();

  @override
  Widget build(BuildContext context) {
    final String title;
    final VoidCallback? onTap;

    switch (model.operation) {
      case OrderOperationType.accept:
        title = "立即接单";
        onTap = () => controller.onTapOrderAcceptOrReject(true, model.id);
        break;
      case OrderOperationType.assign:
        title = "指派接单";
        onTap = () => controller.onTapOrderAssign(model.id);
        break;
      case OrderOperationType.payment:
        title = "立即缴纳";
        onTap = () => controller.toOrderPayment(model.itemModel);
        break;
      case OrderOperationType.cancelAndFinish:
        title = "我已到位";
        onTap = () => controller.onTapOrderFinish(model.id);
        break;
      case OrderOperationType.finish:
        title = "确认完成";
        onTap = () => controller.onTapOrderFinish(model.id);
        break;
      case OrderOperationType.evaluation:
        title = "立即评价";
        onTap = () => controller.toOrderEvaluation(model.id);
        break;
      default:
        title = "";
        onTap = null;
        break;
    }
    if (title.isEmpty && onTap == null) return const SizedBox();
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 38.rpx, vertical: 24.rpx),
        child: CommonGradientButton(
          text: title,
          height: 50.rpx,
        ),
      ),
    );
  }
}

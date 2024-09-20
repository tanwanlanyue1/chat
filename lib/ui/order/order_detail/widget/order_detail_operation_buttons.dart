import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
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
        title = S.current.immediateOrder;
        onTap = () => controller.onTapOrderAcceptOrReject(true, model.id);
        break;
      case OrderOperationType.assign:
        title = S.current.assignmentOfOrder;
        onTap = () => controller.onTapOrderAssign(model.id);
        break;
      case OrderOperationType.payment:
        title = S.current.depositNow;
        onTap = () => controller.toOrderPayment(model.itemModel);
        break;
      case OrderOperationType.cancelAndFinish:
        title = S.current.imInPlace;
        onTap = () => controller.onTapOrderFinish(model.id);
        break;
      case OrderOperationType.finish:
        title = S.current.confirmCompletion;
        onTap = () => controller.onTapOrderFinish(model.id);
        break;
      case OrderOperationType.evaluation:
        title = S.current.immediateEvaluation;
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

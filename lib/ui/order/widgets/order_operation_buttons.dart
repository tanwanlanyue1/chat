import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/text_style_extension.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/order/enum/order_enum.dart';
import 'package:guanjia/ui/order/model/order_list_item.dart';
import 'package:guanjia/ui/order/order_detail/widget/order_cancel_dialog.dart';
import 'package:guanjia/ui/order/order_list/order_list_controller.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/common_gradient_button.dart';

class OrderOperationButtons extends StatelessWidget {
  OrderOperationButtons({
    super.key,
    required this.type,
    required this.item,
  });

  final OrderListType type; // 订单列表类型，用于查找对应的控制器

  final OrderListItem item; // 订单模型数据

  late final controller = Get.find<OrderListController>(tag: type.name);

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];

    switch (item.operationType) {
      case OrderOperationType.accept:
        children.addAll([
          _buildLeft(
            onTap: () async{
              final receiveId = item.itemModel.receiveId;
              final requestId = item.itemModel.requestId;
              final userId = SS.login.info?.uid == receiveId ? requestId : receiveId;
              final cancel = await OrderCancelDialog.show(userId);
              if(cancel == true){
                controller.onTapOrderAcceptOrReject(false, item.id);
              }
            },
          ),
          SizedBox(width: 24.rpx),
          _buildRight(
            onTap: () => controller.onTapOrderAcceptOrReject(true, item.id),
            text: S.current.immediateOrder,
          ),
        ]);
        break;
      case OrderOperationType.assign:
        children.addAll([
          _buildLeft(),
          SizedBox(width: 24.rpx),
          _buildRight(
            onTap: () => controller.onTapOrderAssign(item.id),
            text: S.current.assignmentOfOrder,
          ),
        ]);
        break;
      case OrderOperationType.payment:
        children.addAll([
          _buildLeft(),
          SizedBox(width: 24.rpx),
          _buildRight(
            onTap: () => controller.toOrderPayment(item.itemModel),
            text: S.current.depositNow,
          ),
        ]);
        break;
      case OrderOperationType.cancelAndFinish:
        children.addAll([
          _buildLeft(),
          SizedBox(width: 24.rpx),
          _buildRight(
            onTap: () => controller.onTapOrderFinish(item.id),
            text: S.current.imInPlace,
          ),
        ]);
        break;
      case OrderOperationType.finish:
        children.add(_buildRight(
          onTap: () => controller.onTapOrderFinish(item.id),
          text: S.current.confirmCompletion,
        ));
        break;
      case OrderOperationType.cancel:
        children.add(_buildLeft());
        break;
      case OrderOperationType.connect:
        if (item.itemModel.receiveId != 0) {
          children.add(_buildConnect());
        }
        break;
      case OrderOperationType.evaluation:
        children.add(_buildRight(
          onTap: () => controller.toOrderEvaluation(item.id),
          text: S.current.immediateEvaluation,
        ));
        break;
      case OrderOperationType.none:
      case OrderOperationType.create:
      case OrderOperationType.confirm:
        break;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: children,
    );
  }

  Widget _buildLeft({
    VoidCallback? onTap,
    String? text,
  }) {
    return GestureDetector(
      onTap: onTap ?? () => controller.onTapOrderCancel(item.id,item.itemModel.receiveId,item.itemModel.requestId),
      child: Container(
        width: 60.rpx,
        height: 26.rpx,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.rpx),
          color: AppColor.black9,
        ),
        alignment: Alignment.center,
        child: Text(
          text ?? S.current.cancellationOrder,
          style: AppTextStyle.st.size(12.rpx).textColor(Colors.white),
        ),
      ),
    );
  }

  Widget _buildRight({
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
      onTap: () => controller.toOrderConnect(item.itemModel.receiveId),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 48.rpx,
        height: 40.rpx,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppImage.asset(
              "assets/images/common/contact.png",
              size: 20.rpx,
            ),
            Text(
              S.current.contactToBeauty,
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

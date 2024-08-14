import 'package:guanjia/common/network/api/model/order/order_list_model.dart';
import 'package:guanjia/ui/order/enum/order_enum.dart';
import 'package:guanjia/ui/order/model/order_list_item.dart';

class OrderDetailItemWrapper {
  final String stateText; // 订单状态文本
  final String stateDetailText; // 订单状态下方文本
  final bool hasCancel; // 是否有取消
  final bool hasDivider; // 是否有分割线
  final String? bottomTipText; // 底部提醒文本
  final OrderOperationType operation; // 订单操作类型

  OrderDetailItemWrapper({
    required this.stateText,
    required this.stateDetailText,
    this.hasCancel = false,
    this.hasDivider = false,
    this.bottomTipText,
    this.operation = OrderOperationType.none,
  });
}

class OrderDetailItem {
  OrderDetailItem({
    required this.itemModel,
  }) {
    itemType = OrderListItem.getType(itemModel);
  }

  // 原始数据
  final OrderItemModel itemModel;

  // 订单类型
  late final OrderItemState itemType;

  // 订单id
  int get id => itemModel.id;
}

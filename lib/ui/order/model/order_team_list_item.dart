import 'package:guanjia/common/network/api/api.dart';

import 'order_list_item.dart';

class OrderTeamListItem {
  OrderTeamListItem({
    required this.itemModel,
  }) {
    list = itemModel.list.map((e) => OrderListItem(itemModel: e)).toList();
  }

  // 是否选中
  bool isSelect = false;

  // 原始数据
  final OrderTeamModel itemModel;

  // 详细订单列表
  late final List<OrderListItem> list;

  // 头像
  String get avatar => itemModel.userInfo?.avatar ?? "";

  // 昵称
  String get nickname => itemModel.userInfo?.nickname ?? "";

  // 总单数
  int get amountCount => itemModel.allCompleteCount;

  // 已完成数量
  int get finishCount => itemModel.completeCount;

  // 待评论数量
  int get waitingEvaluateCount => itemModel.evaluateCount;
}

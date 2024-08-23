import 'dart:convert';

import 'package:guanjia/common/extension/functions_extension.dart';
import 'package:guanjia/common/network/api/model/order/order_list_model.dart';
import 'package:guanjia/common/utils/app_logger.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

///订单消息内容
class MessageOrderContent {

  ///展示到聊天页的文本内容
  final String message;
  final OrderItemModel order;

  MessageOrderContent({required this.message, required this.order});

  factory MessageOrderContent.fromJson(Map<String, dynamic> json) {
    return MessageOrderContent(
      message: json['message'],
      order: OrderItemModel.fromJson(json),
    );
  }
}

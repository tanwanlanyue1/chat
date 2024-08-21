import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:guanjia/common/network/api/model/user/binding_info.dart';
import 'package:guanjia/common/network/api/model/user/contract_model.dart';
import 'package:guanjia/common/network/api/model/user/level_money_info.dart';
import 'package:guanjia/common/network/httpclient/http_client.dart';
import 'package:guanjia/common/network/api/api.dart';

/// IM API
class IMApi {
  const IMApi._();

  /// 转账
  ///- toUid 转账接收人id
  ///- amount 转账金额
  ///- payPassword 支付密码
  static Future<ApiResponse> transfer({
    required int toUid,
    required num amount,
    required String payPassword,
  }) {
    return HttpClient.post(
      '/api/im/transferMoney',
      data: {
        "toUid": toUid,
        "amount": amount,
        "payPassword": payPassword,
      },
    );
  }

  /// 发送消息
  ///- type 消息类型 1文字 2图片 3视频 4定位
  ///- msg 消息内容
  static Future<ApiResponse> sendMessage({
    required int type,
    required Map<String, dynamic> msg,
  }) {
    return HttpClient.post(
      '/api/im/sendMessage',
      data: {
        "type": type,
        "msg": msg,
      },
    );
  }

  /// 创建音视频通话订单
  ///- type ：1视频 2语音
  ///- toUid 接收方用户ID
  ///- return 订单ID
  static Future<ApiResponse<int>> createCallOrder({required int type, required int toUid}) {
    return HttpClient.post(
      '/api/im/createOrder',
      data: {
        "code": type,
        "toUid": toUid,
      },
    );
  }

  /// 通话-实时扣费接口
  ///- orderId 订单ID
  static Future<ApiResponse<void>> chatOrderPay(int orderId) {
    return HttpClient.post(
      '/api/im/chatOrderPay',
      data: {
        "id": orderId,
      },
    );
  }

}

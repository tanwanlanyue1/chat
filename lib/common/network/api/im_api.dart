import 'package:guanjia/common/network/httpclient/http_client.dart';

import 'model/im/chat_call_pay_model.dart';
import 'model/im/chat_user_model.dart';
import 'model/im/red_packet_model.dart';

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
  static Future<ApiResponse<int>> createCallOrder(
      {required int type, required int toUid}) {
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
  ///- uuid 扣费uuid 只能用一次
  static Future<ApiResponse<ChatCallPayModel>> chatOrderPay(
      {required int orderId, String? uuid}) {
    return HttpClient.post(
      '/api/im/chatOrderPay',
      data: {
        "id": orderId,
        if (uuid != null) "uuid": uuid,
      },
      dataConverter: (json) => ChatCallPayModel.fromJson(json),
    );
  }

  /// 发送红包
  ///- toUid 接收方用户ID
  ///- amount 红包金额
  ///- message 红包描述
  ///- background 红包背景
  ///- payPassword 支付密码
  static Future<ApiResponse<void>> sendRedEnvelopes({
    required int toUid,
    required num amount,
    required String message,
    String? background,
    required String payPassword,
  }) {
    return HttpClient.post(
      '/api/im/sendRedEnvelopes',
      data: {
        "toUid": toUid,
        "amount": amount,
        "message": message,
        if (background != null) "background": background,
        "payPassword": payPassword,
      },
    );
  }

  /// 领取红包
  ///- msgId 消息 ID。全局唯一
  ///- number 红包流水号
  static Future<ApiResponse<void>> receiveRedEnvelopes({
    required String msgId,
    required int number,
  }) {
    /* 错误码
    (3100, "红包不存在"),
    (3101, "红包已领取"),
    (3102, "红包已过期"),
    (3103, "红包已撤回"),
     */

    return HttpClient.post(
      '/api/im/receiveRedEnvelopes',
      data: {
        "msgId": msgId,
        "number": number,
      },
    );
  }

  /// 撤回红包
  ///- msgId 消息 ID。全局唯一
  ///- number 红包流水号
  static Future<ApiResponse<void>> withdrawRedEnvelopes({
    required String msgId,
    required int number,
  }) {
    /* 错误码
    (3100, "红包不存在"),
    (3101, "红包已领取"),
    (3102, "红包已过期"),
    (3103, "红包已撤回"),
     */

    return HttpClient.post(
      '/api/im/withdrawRedEnvelopes',
      data: {
        "msgId": msgId,
        "number": number,
      },
    );
  }

  /// 查询红包
  ///- msgId 消息 ID。全局唯一
  ///- number 红包流水号
  static Future<ApiResponse<RedPacketModel>> getRedEnvelope({
    required String msgId,
    required int number,
  }) {
    return HttpClient.post(
      '/api/im/getRedEnvelope',
      data: {
        "msgId": msgId,
        "number": number,
      },
      dataConverter: (json) => RedPacketModel.fromJson(json),
    );
  }

  /// 通话-速配接口
  ///- type ：1视频 2语音
  ///- return orderId
  static Future<ApiResponse<int>> startSpeedDating({required int type}) {
    return HttpClient.post(
      '/api/im/sendMatchingMsg',
      data: {
        "code": type,
      },
    );
  }

  /// 通话-取消速配接口
  ///- type ：1视频 2语音
  static Future<ApiResponse> cancelSpeedDating({required int orderId}) {
    return HttpClient.post(
      '/api/im/cancelMatching',
      data: {
        "id": orderId,
      },
    );
  }

  /// 通话-抢单接口
  ///- orderId 速配订单id
  static Future<ApiResponse> grabSpeedDating({required int orderId}) {
    return HttpClient.post(
      '/api/im/grabOrder',
      data: {
        "id": orderId,
      },
    );
  }

  /// 通话-抢单接口
  ///- orderId 速配订单id
  static Future<ApiResponse<List<ChatUserModel>>> getChatUserList(List<String> userIds) {
    return HttpClient.get(
      '/api/im/getImUserList',
      params: {
        "userIds": userIds,
      },
      dataConverter: (data){
        if(data is List){
          return data.map((json) => ChatUserModel.fromJson(json)).toList();
        }
        return [];
      }
    );
  }
}

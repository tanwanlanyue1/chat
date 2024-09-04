import 'package:guanjia/common/network/network.dart';

/// 支付API
class PaymentApi {
  const PaymentApi._();

  /// 查询境修币选项、活动列表
  /// - type 0安卓，1苹果，2web
  static Future<ApiResponse<List<PaymentConfigRes>>> configList(int type) {
    return HttpClient.get(
      '/api/pay/getConfigList',
      params: {
        'type': type,
      },
      dataConverter: (json) {
        if (json is List) {
          return json.map((e) => PaymentConfigRes.fromJson(e)).toList();
        }
        return [];
      },
    );
  }

  /// 查询充值渠道列表
  /// - type 0安卓，1苹果，2web
  static Future<ApiResponse<List<PaymentChannelRes>>> channelList(int type) {
    return HttpClient.get(
      '/api/pay/getChannelList',
      params: {
        'type': type,
      },
      dataConverter: (json) {
        if (json is List) {
          return json.map((e) => PaymentChannelRes.fromJson(e)).toList();
        }
        return [];
      },
    );
  }

  /// 用户充值操作
  ///- payChannelId 渠道ID
  ///- type 下单类型： 1APP下单(直接请求支付参数) 2小程序下单(只保存订单记录), 3苹果内购
  ///- configId 快捷选择境修币ID(自定义充值不用传)
  ///- goldNum 自定义充值币的数量
  static Future<ApiResponse<dynamic>> createOrder({
    required int payChannelId,
    required int type,
    int? configId,
    int? goldNum,
  }) {
    return HttpClient.post(
      '/api/pay/createOrder',
      data: {
        'payChannelId': payChannelId,
        'type': type,
        if (configId != null) 'configId': configId,
        if (goldNum != null) 'goldNum': goldNum,
      },
    );
  }

  /// 查询订单状态
  /// - return 0未付款 1已付款 2已退款
  static Future<ApiResponse<int>> getOrderState(String orderNo) {
    return HttpClient.get(
      '/api/pay/getOrderStatus',
      params: {
        'orderNo': orderNo,
      },
    );
  }

  /// 查询订单详情
  /// orderNo: 订单号
  static Future<ApiResponse<PaymentOrderInfoModel>> getOrderInfo(
      {required String orderNo}) {
    return HttpClient.get(
      '/api/pay/getOrderInfo',
      params: {
        'orderNo': orderNo,
      },
      dataConverter: (data) {
        return PaymentOrderInfoModel.fromJson(data);
      },
    );
  }

  /// 获取小程序跳转路径
  static Future<ApiResponse<String?>> getWechatMiniProgramLink() {
    return HttpClient.post('/api/wx/miniapp/openlink', dataConverter: (data) {
      if (data is String) {
        return data;
      }
      return null;
    });
  }

  /// 苹果内购支付
  /// - orderNo
  /// - productId
  /// - transactionReceipt
  static Future<ApiResponse<void>> applePay({
    required String orderNo,
    required String productId,
    required String transactionReceipt,
  }) {
    return HttpClient.post(
      '/api/pay/applePay',
      data: {
        'orderNo': orderNo,
        'productId': productId,
        'transactionReceipt': transactionReceipt,
      },
    );
  }
}

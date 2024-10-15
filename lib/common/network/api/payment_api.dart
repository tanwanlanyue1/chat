import 'package:guanjia/common/network/network.dart';
import 'model/payment/payment_order_model.dart';

///支付 API
class PaymentApi {
  const PaymentApi._();

  /// 创建充值订单
  ///- amount 充值金额
  static Future<ApiResponse<PaymentOrderModel>> createRechargeOrder(num amount) {
    return HttpClient.post(
      '/api/pay/createOrder',
      data: {
        'amount': amount,
      },
      dataConverter: (json) => PaymentOrderModel.fromJson(json),
    );
  }

  /// 查询订单状态
  /// - return 0待支付 1已支付 2已超时
  static Future<ApiResponse<int>> getOrderState(String orderNo) {
    return HttpClient.get(
      '/api/pay/getOrderStatus',
      params: {
        'orderNo': orderNo,
      },
    );
  }

  /// 查询订单详情
  ///- orderNo: 订单号
  static Future<ApiResponse<PaymentOrderModel>> getOrderInfo(String orderNo) {
    return HttpClient.get(
      '/api/pay/getOrderInfo',
      params: {
        'orderNo': orderNo,
      },
      dataConverter: (data) {
        return PaymentOrderModel.fromJson(data);
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

import 'package:guanjia/common/network/network.dart';
import 'model/payment/payment_order_model.dart';
import 'model/payment/withdraw_order_model.dart';

///支付 API
class PaymentApi {
  const PaymentApi._();

  /// 创建充值订单
  ///- amount 充值金额
  static Future<ApiResponse<PaymentOrderModel>> createRechargeOrder(
      num amount) {
    return HttpClient.post<PaymentOrderModel>(
      '/api/pay/createOrder',
      data: {
        'amount': amount,
      },
      dataConverter: (json) => PaymentOrderModel.fromJson(json),
    );
  }

  /// 创建提现订单
  ///- amount 金额
  ///- address 钱包地址
  ///- password 支付密码
  static Future<ApiResponse<void>> createWithdrawOrder({
    required num amount,
    required String address,
    required String password,
  }) {
    return HttpClient.post(
      '/api/pay/withdrawal',
      data: {
        'amount': amount,
        'address': address,
        'password': password,
      },
    );
  }

  /// 获取用户钱包充值记录
  static Future<ApiResponse<List<PaymentOrderModel>>> getRechargeOrderList({
    required int page,
    required int size,
  }) {
    return HttpClient.get('/api/pay/getOrderList', params: {
      'page': page,
      'size': size,
    }, dataConverter: (data) {
      if (data is List) {
        return data.map((e) => PaymentOrderModel.fromJson(e)).toList();
      }
      return [];
    });
  }

  /// 获取用户提现记录
  static Future<ApiResponse<List<WithdrawOrderModel>>> getWithdrawOrderList({
    required int page,
    required int size,
  }) {
    return HttpClient.get('/api/pay/getWithdrawalList', params: {
      'page': page,
      'size': size,
    }, dataConverter: (data) {
      if (data is List) {
        return data.map((e) => WithdrawOrderModel.fromJson(e)).toList();
      }
      return [];
    });
  }

  /// 查询订单详情
  ///- orderNo: 订单号
  static Future<ApiResponse<PaymentOrderModel>> getOrderInfo(String orderNo) {
    return HttpClient.get<PaymentOrderModel>(
      '/api/pay/getOrderInfo',
      params: {
        'orderNo': orderNo,
      },
      dataConverter: (data) {
        return PaymentOrderModel.fromJson(data);
      },
    );
  }

  /// 获取钱包地址列表
  static Future<ApiResponse<List<String>>> getWalletAddress() {
    return HttpClient.get(
      '/api/pay/getWalletAddress',
      dataConverter: (data){
        if(data is List){
          return data.cast<String>();
        }
        return [];
      }
    );
  }

  /// 添加或删除钱包地址
  ///- address 地址
  ///- type 操作类型 0新增 1删除
  static Future<ApiResponse<void>> setWalletAddress({
    required String address,
    required int type,
  }) {
    return HttpClient.post('/api/pay/walletAddress', data: {
      'type': type,
      'address': address,
    });
  }
}

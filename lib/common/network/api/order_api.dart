import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/network/httpclient/http_client.dart';

/// 订单接口API
class OrderApi {
  const OrderApi._();

  /// 订单缴纳保证金或服务费
  /// - orderId	订单id
  /// - password 用户支付密码
  static Future<ApiResponse> pay({
    required int orderId,
    required String password,
  }) {
    return HttpClient.post(
      '/api/order/pay',
      data: {
        'orderId': orderId,
        'password': password,
      },
    );
  }

  /// 评价订单
  /// - orderId	订单id
  /// - content 评价内容
  /// - tag	评价标签
  /// - score 评价星级	(默认5)
  static Future<ApiResponse> evaluate({
    required int orderId,
    String? content,
    String? tag,
    int score = 5,
  }) {
    return HttpClient.post(
      '/api/order/evaluate',
      data: {
        'orderId': orderId,
        'content': content,
        'tag': tag,
        'score': score,
      },
    );
  }

  /// 完成订单
  /// - orderId	订单id
  static Future<ApiResponse> finish({
    required int orderId,
  }) {
    return HttpClient.post(
      '/api/order/complete',
      data: {
        'orderId': orderId,
      },
    );
  }

  /// 接单人选择接受或拒绝
  /// - orderId	订单id
  /// - type 1同意 2拒绝
  static Future<ApiResponse> acceptOrReject({
    required int orderId,
    required int type,
  }) {
    return HttpClient.post(
      '/api/order/choice',
      data: {
        'orderId': orderId,
        'type': type,
      },
    );
  }

  /// 取消订单
  /// - orderId	订单id
  static Future<ApiResponse> cancel({
    required int orderId,
  }) {
    return HttpClient.post(
      '/api/order/cancel',
      data: {
        'orderId': orderId,
      },
    );
  }

  /// 经纪人指派订单
  /// - orderId	订单id
  /// - receiveId 接单人id
  static Future<ApiResponse> assign({
    required int orderId,
    required int receiveId,
  }) {
    return HttpClient.post(
      '/api/order/assign',
      data: {
        'orderId': orderId,
        'receiveId': receiveId,
      },
    );
  }

  /// 发起订单
  /// - uid	接单人id
  static Future<ApiResponse> add({
    required int uid,
  }) {
    return HttpClient.post(
      '/api/order/add',
      data: {
        'uid': uid,
      },
    );
  }

  /// 获取团队已完成订单列表
  /// - day	统计天数
  static Future<ApiResponse<List<OrderListModel>>> getTeamList({
    int day = 0,
  }) {
    return HttpClient.get(
      '/api/order/teamCompleteList',
      params: {
        'day': day,
      },
      dataConverter: (data) {
        if (data is List) {
          return data.map((e) => OrderListModel.fromJson(e)).toList();
        }
        return [];
      },
    );
  }

  /// 获取订单列表
  /// - state	订单状态 1进行中 3已完成 4已取消
  /// - day	统计天数
  /// - page 页码 默认1,示例值(1)
  /// - size 每页数量（默认10）,示例值(999)
  static Future<ApiResponse<OrderListModel>> getList({
    required int state,
    int? day,
    int page = 1,
    int size = 10,
  }) {
    return HttpClient.get(
      '/api/order/list',
      params: {
        'state': state,
        'day': day,
        'page': page,
        'size': size,
      },
      dataConverter: (data) {
        return OrderListModel.fromJson(data);
      },
    );
  }

  /// 获取订单详情
  /// - orderId 订单id
  static Future<ApiResponse<OrderItemModel>> get({
    required int orderId,
  }) {
    return HttpClient.get(
      '/api/order/get',
      params: {
        'orderId': orderId,
      },
      dataConverter: (data) {
        return OrderItemModel.fromJson(data);
      },
    );
  }

  /// 获取与对方的最后一条订单
  /// - otherUid 对方用户id
  static Future<ApiResponse<OrderItemModel?>> getLastByUid({
    required int otherUid,
  }) {
    return HttpClient.get(
      '/api/order/getLastByUid',
      params: {
        'otherUid': otherUid,
      },
      dataConverter: (data) {
        if (data is Map<String, dynamic>) {
          return OrderItemModel.fromJson(data);
        }
        return null;
      },
    );
  }

  /// 获取佳丽的客户列表
  /// - page 页码 默认1,示例值(1)
  /// - size 每页数量（默认10）,示例值(999)
  static Future<ApiResponse<List<UserModel>>> getMyClientList({
    int page = 1,
    int size = 10,
  }) {
    return HttpClient.get(
      '/api/order/getMyClientList',
      params: {
        'page': page,
        'size': size,
      },
      dataConverter: (data) {
        if (data is List) {
          return data.map((e) => UserModel.fromJson(e)).toList();
        }
        return [];
      },
    );
  }

  /// 获取评价列表
  /// - type 1我评价的 2评价我的 3团队评价
  /// - page 页码 默认1,示例值(1)
  /// - size 每页数量（默认10）,示例值(999)
  static Future<ApiResponse<EvaluationListModel>> getEvaluateList({
    required int type,
    int page = 1,
    int size = 10,
  }) {
    return HttpClient.get(
      '/api/order/getEvaluateList',
      params: {
        'type': type,
        'page': page,
        'size': size,
      },
      dataConverter: (data) {
        return EvaluationListModel.fromJson(data ?? {});
      },
    );
  }
}

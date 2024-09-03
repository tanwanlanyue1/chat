import 'package:guanjia/common/network/api/model/user/vip_model.dart';
import 'package:guanjia/common/network/httpclient/http_client.dart';

/// Vip API
class VipApi {
  const VipApi._();

  /// 会员主页
  static Future<ApiResponse<VipModel>> getVipIndex() {
    return HttpClient.get(
      '/api/vip/getVipIndex',
      dataConverter: (data) => VipModel.fromJson(data),
    );
  }

  /// 开通会员
  ///- packageId 套餐id
  static Future<ApiResponse> openVip({
    required int packageId,
  }) {
    return HttpClient.post(
      '/api/vip/openVip',
      params: {
        "packageId": packageId,
      },
    );
  }
}

import 'package:guanjia/common/network/network.dart';

/// 钱包API
class WalletApi {
  const WalletApi._();

  /// 获取钱包记录
  /// month: 月份,示例值(2024-05)
  /// type：推荐类型（默认0充值，1交易收益，2交易支出）
  /// page：页码（默认1）,示例值(1)
  /// size：每页数量（默认10）,示例值(10)
  static Future<ApiResponse<WalletRecordListRes>> recordList({
    required String month,
    int? type,
    int? page,
    int? size,
  }) {
    return HttpClient.get(
      '/api/purse/logList',
      params: {
        "month": month,
        "type": type,
        "page": page,
        "size": size,
      },
      dataConverter: (json) => WalletRecordListRes.fromJson(json),
    );
  }
}

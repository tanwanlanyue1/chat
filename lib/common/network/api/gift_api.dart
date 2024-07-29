import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/network/httpclient/http_client.dart';

class GiftApi {
  const GiftApi._();

  /// 获取礼物列表
  /// type: 礼物类型：1上香2供品，3河灯，4天灯，5供灯
  /// subType: 子类型
  /// page: 页码（默认1）,示例值(1)
  /// size: 每页数量（默认10）,示例值(10)
  static Future<ApiResponse<List<GiftModel>>> list({
    required int type,
    int? subType,
    int page = 1,
    int size = 10,
  }) {
    return HttpClient.get('/api/gift/getLanternList', params: {
      "type": type,
      "sub_type": subType,
      "page": page,
      "size": size,
    }, dataConverter: (data) {
      if (data is List) {
        return data.map((e) => GiftModel.fromJson(e)).toList();
      }
      return [];
    });
  }
}

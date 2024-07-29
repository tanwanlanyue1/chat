import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/network/api/model/wish_pavilion/charm_record.dart';
import 'package:guanjia/common/network/httpclient/http_client.dart';

/// 请符法坛API
class CharmApi {
  const CharmApi._();

  /// 获取当前用户请符需要的境修币 0=免费
  static Future<ApiResponse<CharmInfo>> getCost() {
    return HttpClient.get(
      '/api/wish/mantra/getCost',
      dataConverter: (json) {
        return CharmInfo.fromJson(json);
      },
    );
  }

  /// 获取灵符壁纸列表
  /// type: 灵符壁纸类型 0热门 1佛菩萨 2度母佛母 3本尊护法 4符咒
  /// page: 页码（默认1）,示例值(1)
  /// size: 每页数量（默认10）,示例值(10)
  static Future<ApiResponse<List<CharmRes>>> getWallpaperList({
    required int type,
    int page = 1,
    int size = 10,
  }) {
    return HttpClient.get(
      '/api/wish/mantra/getWallpaperList',
      params: {
        "type": type,
        "page": page,
        "size": size,
      },
      dataConverter: (json) {
        if (json is List) {
          return json.map((e) => CharmRes.fromJson(e)).toList();
        }
        return [];
      },
    );
  }

  /// 我的灵符-统计页面接口
  /// type: 灵符类型 0最新 1佛菩萨 2度母佛母 3本尊护法 4符咒
  /// page: 页码（默认1）,示例值(1)
  /// size: 每页数量（默认10）,示例值(10)
  static Future<ApiResponse<List<CharmRecord>>> getStatisticsList({
    required int type,
    int page = 1,
    int size = 10,
  }) {
    return HttpClient.get(
      '/api/wish/mantra/getStatisticsList',
      params: {
        "type": type,
        "page": page,
        "size": size,
      },
      dataConverter: (json) {
        if (json is List) {
          return json.map((e) => CharmRecord.fromJson(e)).toList();
        }
        return [];
      },
    );
  }

  /// 获取当前用户的请符记录列表
  /// page: 页码 默认1,示例值(1)
  /// size: 每页数量 默认10,示例值(10)
  static Future<ApiResponse<List<CharmRecord>>> getRecordList({
    int page = 1,
    int size = 10,
  }) {
    return HttpClient.get(
      '/api/wish/mantra/getRecordList',
      params: {
        "page": page,
        "size": size,
      },
      dataConverter: (json) {
        if (json is List) {
          return json.map((e) => CharmRecord.fromJson(e)).toList();
        }
        return [];
      },
    );
  }

  /// 请符法坛-获取灵符信息
  /// id: 我的灵符id
  static Future<ApiResponse<CharmRecord>> getRecord({
    required int id,
  }) {
    return HttpClient.get(
      '/api/wish/mantra/getRecord',
      params: {
        "id": id,
      },
      dataConverter: (json) {
        return CharmRecord.fromJson(json);
      },
    );
  }

  /// 请符-购买壁纸接口
  /// type: 请符类型 0请符 1购买壁纸
  /// giftId: 购买壁纸时传入，壁纸（礼物）id
  static Future<ApiResponse<CharmRecord>> inviteOrPayment({
    required int type,
    int? giftId,
  }) {
    return HttpClient.post(
      '/api/wish/mantra/save',
      data: {
        "type": type,
        "giftId": giftId,
      },
      dataConverter: (json) {
        return CharmRecord.fromJson(json);
      },
    );
  }

  /// 开光-加持接口
  /// id: 我的灵符id
  /// type: 操作类型 0开光 1加持
  static Future<ApiResponse> updateRecord({
    required int id,
    int type = 0,
  }) {
    return HttpClient.post(
      '/api/wish/mantra/updateRecord',
      data: {
        "id": id,
        "type": type,
      },
    );
  }

  /// 开光-加持接口
  /// id: 灵符id
  static Future<ApiResponse> receiveMav({
    required int id,
  }) {
    return HttpClient.post(
      '/api/wish/mantra/receiveMav',
      data: {
        "id": id,
      },
    );
  }
}

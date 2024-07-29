import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/network/httpclient/http_client.dart';

class LightsPrayApi {
  const LightsPrayApi._();

  /// 请灯
  /// lanternId: 灯ID
  /// name：姓名
  /// birthday：生辰
  /// birthdayType：生辰类型 0公历1农历
  /// back：回向内容
  /// open：是否公开 0：公开 1：不公开
  /// direction：供灯方向（0东1南2西3北）
  /// position：位置
  static Future<ApiResponse> invite({
    required int giftId,
    required String name,
    required String birthday,
    int birthdayType = 0,
    String? back,
    int open = 0,
    required int direction,
    required int position,
  }) {
    return HttpClient.post(
      '/api/pray/lantern/put',
      data: {
        "giftId": giftId,
        "name": name,
        "birthday": birthday,
        "birthdayType": birthdayType,
        "back": back,
        "open": open,
        "direction": direction,
        "position": position,
      },
    );
  }

  /// 阿弥陀佛（点赞）
  /// id: id
  static Future<ApiResponse> praise({
    required int id,
  }) {
    return HttpClient.get(
      '/api/pray/lantern/bless',
      params: {
        "id": id,
      },
    );
  }

  /// 获取灯列表
  /// direction: 供灯方向（0东1南2西3北） 不传则为全部
  static Future<ApiResponse<List<LightsPrayModel>>> list({
    int? direction,
  }) {
    return HttpClient.get('/api/pray/lantern/list', params: {
      "direction": direction,
    }, dataConverter: (data) {
      if (data is List) {
        return data.map((e) => LightsPrayModel.fromJson(e)).toList();
      }
      return [];
    });
  }

  /// 获取当前用户未过期的灯列表
  static Future<ApiResponse<List<LightsPrayModel>>> myList() {
    return HttpClient.get('/api/pray/lantern/getListByUid',
        dataConverter: (data) {
      if (data is List) {
        return data.map((e) => LightsPrayModel.fromJson(e)).toList();
      }
      return [];
    });
  }

  /// 查看灯内容
  /// id: 供灯id
  static Future<ApiResponse<LightsPrayModel>> info({
    required int id,
  }) {
    return HttpClient.get('/api/pray/lantern/get', params: {
      "id": id,
    }, dataConverter: (data) {
      return LightsPrayModel.fromJson(data);
    });
  }
}

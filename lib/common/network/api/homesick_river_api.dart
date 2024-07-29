import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/network/httpclient/http_client.dart';

/// 思亲河
class HomesickRiverApi {
  const HomesickRiverApi._();

  /// 根据礼物ID获取售价配置信息
  /// lanternId: 礼物id
  /// acquiesce: 默认的时效，0非默认，1默认
  static Future<ApiResponse<List<TimeConfigModel>>> getConfig({
    required int lanternId,
    int? acquiesce,
  }) {
    return HttpClient.get('/api/miss/getConfig',
        params: {"lanternId": lanternId, "acquiesce": acquiesce},
        dataConverter: (data) {
      if (data is List) {
        return data.map((e) => TimeConfigModel.fromJson(e)).toList();
      }
      return [];
    });
  }

  /// 用户点河灯-放天灯操作
  /// giftId:礼物id
  /// configId:	灯的时效和费用配置ID
  /// name:	接福者姓名
  /// desire:	愿望、思念或者祝福语
  /// open:	是否公开 0：公开 1：不公开
  static Future<ApiResponse> saveRecord({
    required int giftId,
    int? configId,
    String? name,
    String? desire,
    int? open,
  }) {
    return HttpClient.post('/api/miss/saveRecord',
        data: {
          "giftId": giftId,
          "configId": configId,
          "name": name,
          "desire": desire,
          "open": open,
        },
        dataConverter: (data) => data);
  }

  /// 获取天灯许愿模板(格式 模板词：内容)
  static Future<ApiResponse> getTemplateList() {
    return HttpClient.get('/api/miss/getTemplateList',
        dataConverter: (data) => data);
  }

  /// 获取放灯记录
  /// type: 灯类型 3:河灯 4：天灯
  /// isAll: 是否查询所有放灯的记录 0：只查用户自己的 1：查所有的
  /// page: 页码
  /// size: 大小
  static Future<ApiResponse<List<RecordLightModel>>> getRecordList({
    int? type,
    int? isAll,
    int? page = 1,
    int? size = 10,
  }) {
    return HttpClient.get('/api/miss/getRecordList', params: {
      "type": type,
      "isAll": isAll,
      "page": page,
      "size": size,
    }, dataConverter: (data) {
      if (data is List) {
        return data.map((e) => RecordLightModel.fromJson(e)).toList();
      }
      return [];
    });
  }

  /// 修改灯的状态（河灯收起|重新放灯 天灯完愿）
  /// recordId:	放灯记录ID
  static Future<ApiResponse> updateRecord({
    required int recordId,
  }) {
    return HttpClient.post('/api/miss/updateRecord',
        params: {
          "recordId": recordId,
        },
        dataConverter: (data) => data);
  }

  /// 获取记录详情
  /// recordId:	放灯记录ID
  static Future<ApiResponse<RecordDetailsModel>> getRecordById({
    required int id,
  }) {
    return HttpClient.get('/api/miss/getRecordById',
        params: {
          "id": id,
        },
        dataConverter: (data) => RecordDetailsModel.fromJson(data));
  }

  /// 用户祝福操作
  /// recordId:	放灯记录ID
  static Future<ApiResponse> recordBlessing({
    required int recordId,
  }) {
    return HttpClient.post('/api/miss/blessing',
        params: {
          "recordId": recordId,
        },
        dataConverter: (data) => data);
  }

  /// 获取热门天灯
  static Future<ApiResponse<List<GiftModel>>> getHotList() {
    return HttpClient.get(
      '/api/miss/getHotList',
      dataConverter: (data) {
        if (data is List) {
          return data.map((e) => GiftModel.fromJson(e)).toList();
        }
        return [];
      },
    );
  }

  /// 获取思亲河首页数据
  static Future<ApiResponse<List<RecordLightModel>>> getHomePageList() {
    return HttpClient.get(
      '/api/miss/getHomePageList',
      dataConverter: (data) {
        if (data is List) {
          return data.map((e) => RecordLightModel.fromJson(e)).toList();
        }
        return [];
      },
    );
  }
}

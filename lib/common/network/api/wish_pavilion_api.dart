import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/network/httpclient/http_client.dart';
import 'model/wish_pavilion/WoodenFishRecordModel.dart';
import 'model/wish_pavilion/cultivation_ranking_model.dart';

/// 心愿阁API
class WishPavilionApi {
  const WishPavilionApi._();

  /// 佛像列表
  static Future<ApiResponse<List<BuddhaModel>>> getBuddhaList() {
    return HttpClient.get('/api/temple/buddha/buddhaList',
        dataConverter: (data) {
      if (data is List) {
        return data.map((e) => BuddhaModel.fromJson(e)).toList();
      }
      return [];
    });
  }

  /// 禅房供品列表
  /// - type 类型 1：上香 2：供品
  /// - page 页码（默认1）,示例值(1)
  /// - size 每页数量（默认10）,示例值(10)
  static Future<ApiResponse<List<ZenRoomGiftModel>>> getZenRoomGiftList({
    required int type,
    required int page,
    required int size,
  }) {
    return HttpClient.get(
      '/api/temple/buddha/giftList',
      params: {
        'type': type,
        'page': page,
        'size': size,
      },
      dataConverter: (data) {
        if (data is List) {
          return data.map((e) => ZenRoomGiftModel.fromJson(e)).toList();
        }
        return [];
      },
    );
  }

  /// 顶礼
  /// - buddhaId 佛像ID
  /// - giftId 供品ID
  /// - direction 上供方向（0：左 1：右, 不传则是上香）
  static Future<ApiResponse<void>> offering({
    required int buddhaId,
    required int giftId,
    int? direction,
  }) {
    return HttpClient.post('/api/temple/buddha/saveRecord', data: {
      'buddhaId': buddhaId,
      'giftId': giftId,
      'direction': direction,
    });
  }

  /// 查询佛像当前供奉的供品信息
  /// - giftId 供品ID
  static Future<ApiResponse<List<OfferingGiftInfoModel>>> getOfferingGifts(
      int buddhaId) {
    return HttpClient.get('/api/temple/buddha/getRecord', params: {
      'buddhaId': buddhaId,
    }, dataConverter: (data) {
      if (data is List) {
        return data.map((e) => OfferingGiftInfoModel.fromJson(e)).toList();
      }
      return [];
    });
  }

  /// 查询当前供奉的佛像
  static Future<ApiResponse<BuddhaModel?>> getOfferingBuddha() {
    return HttpClient.get('/api/temple/buddha/getLastBuddha',
        dataConverter: (data) {
      if (data != null) {
        return BuddhaModel.fromJson(data);
      }
      return null;
    });
  }

  /// 点击禅垫，获得悟道的语句
  static Future<ApiResponse<ZenLanguageModel>> getZenLanguage() {
    return HttpClient.get(
      '/api/temple/cushion/getOne',
      dataConverter: (json) => ZenLanguageModel.fromJson(json),
    );
  }

  ///获取页面uuid
  ///- type 0：木鱼 1：念珠
  static Future<ApiResponse<String>> getPageUuid(int type) {
    return HttpClient.get(
      '/openapi/getUuid',
      params: {
        'type': type,
      },
    );
  }

  /// 保存木鱼敲击记录
  /// - uuid 页面uuid，通过getPageUuid接口获取
  /// - count 本次法器敲击次数
  /// - startTime 开始时间
  /// - endTime 结束时间
  /// - scripturesId 佛经id
  /// - completionRate 本次完成度
  /// - number 今日第几次诵此经
  static Future<ApiResponse<void>> saveRecitation({
    required String uuid,
    required int count,
    required String startTime,
    required String endTime,
    int scripturesId = 0,
    double completionRate = 0,
    int number = 0,
  }) {
    return HttpClient.post(
      '/api/temple/buddha/saveRecitation',
      headers: {'uuid': uuid},
      data: {
        'count': count,
        'startTime': startTime,
        'endTime': endTime,
        'scripturesId': scripturesId,
        'completionRate': completionRate,
        'number': number,
      },
    );
  }

  /// 佛经列表
  ///- type 佛经类型 0：经书 1：咒语
  ///- page 页码
  ///- size 页大小
  ///- isAudio 0无音频，1有音频，null所有
  static Future<ApiResponse<List<BuddhistSutrasModel>>> getBuddhistSutrasList({
    required int type,
    required int page,
    required int size,
    int? isAudio,
  }) {
    return HttpClient.get('/api/temple/scriptures/getList', params: {
      'type': type,
      'page': page,
      'size': size,
      if(isAudio != null) 'isAudio': isAudio,
    }, dataConverter: (data) {
      if (data is List) {
        return data.map((e) => BuddhistSutrasModel.fromJson(e)).toList();
      }
      return [];
    });
  }

  /// 搜索佛经
  ///- type 佛经类型 0：经书 1：咒语
  ///- name 经书名称
  ///- page 页码
  ///- size 页大小
  static Future<ApiResponse<List<BuddhistSutrasModel>>>
      queryBuddhistSutrasList({
    required int type,
    required String name,
    required int page,
    required int size,
  }) {
    return HttpClient.get(
      '/api/temple/scriptures/searchByName',
      params: {
        'type': type,
        'name': name,
        'page': page,
        'size': size,
      },
      dataConverter: (data) {
        if (data is List) {
          return data.map((e) => BuddhistSutrasModel.fromJson(e)).toList();
        }
        return [];
      },
    );
  }

  /// 查询今日修行统计
  static Future<ApiResponse<TodayCultivationStatsModel>> getTodayCount() {
    return HttpClient.get(
      '/api/temple/buddha/getTodayCount',
      dataConverter: (json) => TodayCultivationStatsModel.fromJson(json),
    );
  }

  /// 保存念珠记录
  /// - uuid 页面uuid，通过getPageUuid接口获取
  /// - count 本次念珠次数
  /// - startTime 开始时间
  /// - endTime 结束时间
  static Future<ApiResponse<void>> saveDirection({
    required String uuid,
    required int count,
    required String startTime,
    required String endTime,
  }) {
    return HttpClient.post(
      '/api/temple/buddha/saveDirection',
      headers: {'uuid': uuid},
      data: {
        'count': count,
        'startTime': startTime,
        'endTime': endTime,
      },
    );
  }

  /// 查询当前用户的念诵(佛珠)场景配置
  static Future<ApiResponse<RosaryBeadsConfigModel?>> getRosaryBeadsConfig() {
    return HttpClient.get(
      '/api/temple/buddha/getUserConfig',
      dataConverter: (json){
        try{
          return RosaryBeadsConfigModel.fromJson(json);
        }catch(ex){
          return null;
        }
      },
    );
  }

  /// 保存念诵(佛珠)场景用户配置
  static Future<ApiResponse<void>> saveRosaryBeadsConfig(
      RosaryBeadsConfigModel config) {
    return HttpClient.post(
      '/api/temple/buddha/saveConfig',
      data: config.toJson(),
    );
  }

  /// 获取念珠场景商品列表
  /// - type 	0:佛珠 1：背景
  static Future<ApiResponse<List<RosaryBeadsProductModel>>>
      getRosaryBeadsProductList(int type) {
    return HttpClient.get(
      '/api/temple/buddha/getDirectionList',
      params: {'type': type},
      dataConverter: (data) {
        if (data is List) {
          return data.map((e) => RosaryBeadsProductModel.fromJson(e)).toList();
        }
        return [];
      },
    );
  }

  /// 购买念珠场景商品
  /// - productId
  static Future<ApiResponse<void>> buyRosaryBeadsProduct(int productId) {
    return HttpClient.post(
      '/api/temple/buddha/buyDirection',
      params: {'id': productId},
    );
  }


  /// 根据传入的日期查询用户的所有记录
  /// - date 日期
  static Future<ApiResponse<List<CultivationRecordModel>>> getAllRecordByDate(String date) {
    return HttpClient.get(
      '/api/temple/buddha/getAllRecordByDate',
      params: {'date': date},
      dataConverter: (data) {
        if (data is List) {
          return data.map((e) => CultivationRecordModel.fromJson(e)).toList();
        }
        return [];
      },
    );
  }


  /// 查询用户当天的上供记录
  /// - type 	类型 1:上香 2:供礼
  static Future<ApiResponse<List<OfferingRecordModel>>> getRecordCountByType(int type) {
    return HttpClient.get(
      '/api/temple/buddha/getRecordCountByType',
      params: {'type': type},
      dataConverter: (data) {
        if (data is List) {
          return data.map((e) => OfferingRecordModel.fromJson(e)).toList();
        }
        return [];
      },
    );
  }


  /// 查询用户当天的佛珠记录
  static Future<ApiResponse<List<RosaryBeadsRecordModel>>> getTodayDirectionRecord() {
    return HttpClient.get(
      '/api/temple/buddha/getTodayDirectionRecord',
      dataConverter: (data) {
        if (data is List) {
          return data.map((e) => RosaryBeadsRecordModel.fromJson(e)).toList();
        }
        return [];
      },
    );
  }

  /// 查询用户当天木鱼诵经的统计和记录
  static Future<ApiResponse<WoodenFishRecordModel>> getRecitationCount() {
    return HttpClient.get(
      '/api/temple/buddha/getRecitationCount',
      dataConverter: (data) => WoodenFishRecordModel.fromJson(data),
    );
  }

  /// 获取用户最后诵念的佛经
  static Future<ApiResponse<BuddhistSutrasModel?>> getLastScriptures() {
    return HttpClient.get(
      '/api/temple/scriptures/getLastScriptures',
      dataConverter: (data){
        try{
          final model =  BuddhistSutrasModel.fromJson(data);
          if(model.name.isNotEmpty){
            return model;
          }
        }catch(ex){
          return null;
        }
      },
    );
  }

  /// 查询修行排行榜
  /// - type 0=功德值排行 1=累计修行天数排行 2=连续修行排行 3=上香 4=供礼 5=敲诵 6=念珠
  static Future<ApiResponse<List<CultivationRankingModel>>> getRankingList(int type) {
    return HttpClient.get(
      '/api/temple/buddha/getRankingList',
      params: {'type': type},
      dataConverter: (data) {
        if (data is List) {
          return data.map((e) => CultivationRankingModel.fromJson(e)).toList();
        }
        return [];
      },
    );
  }


}

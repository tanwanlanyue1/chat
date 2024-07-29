import 'package:guanjia/common/network/httpclient/http_client.dart';

import 'model/disambiguation/talk_disambiguation.dart';


/// 解疑API
class DisambiguationApi {
  const DisambiguationApi._();

  /// 星座运势
  /// constellation: 星座英文,(gemini)
  /// timeType：	时间范围(0今 1明 2本周 3本月 4本年),示例值(2)
  /// timeTypeStr/constellationStr，中文
  static Future<ApiResponse<StarFortuneModel>> fortune({
    String constellationStr = '',
    String constellation = '',
    String timeTypeStr = '',
    int? timeType,
  }) {
    return HttpClient.post(
      '/api/disabuse/constellation/fortune',
      data: {
        "timeType": timeType,
        "timeTypeStr": timeTypeStr,
        "constellation": constellation,
        "constellationStr": constellationStr,
      },
      dataConverter: (data) => StarFortuneModel.fromJson(data)
    );
  }

  /// 星座星盘
  /// province:省份
  /// city:城市
  static Future<ApiResponse<List<AstrolabeModel>>> horoscope({
    String year = '',
    String month = '',
    String day = '',
    String hour = '',
    String minute = '0',
    String province = '',
    String city = '',
  }) {
    return HttpClient.post(
        '/api/disabuse/constellation/horoscope',
        data: {
          "year": year,
          "month": month,
          "day": day,
          "hour": hour,
          "minute": minute,
          "province": province,
          "city": city,
        },
      dataConverter: (data) {
        if(data is List) {
          return data.map((e) => AstrolabeModel.fromJson(e)).toList();
        }
        return [];
      },
    );
  }

  /// 星座配对
  /// woman:星座中文-女,示例值(天秤女)
  /// man:星座中文-男,示例值(天秤男)
  static Future<ApiResponse<StartPairModel>> pair({
    String woman = '',
    String man = '',
  }) {
    return HttpClient.post(
      '/api/disabuse/constellation/pair',
      data: {
        "woman": woman,
        "man": man,
      },
      dataConverter: (data) => StartPairModel.fromJson(data)
    );
  }

  /// 测算运势
  /// name: 姓名
  /// sex: 性别
  /// birthday: 生日
  /// type: 查询类型（1财运 2爱情 3健康 4事业）
  static Future<ApiResponse<FortuneModel>> getFortune({
    String name = '',
    String sex = '',
    String birthday = '',
    String typeStr = '',
    int type = 1,
  }) {
    return HttpClient.post(
        '/api/disabuse/luck/getFortune',
        data: {
          "name": name,
          "sex": sex,
          "birthday": birthday,
          "type": type,
          "typeStr": typeStr,
        },
        dataConverter: (data) => FortuneModel.fromJson(data)
    );
  }

  /// 取名
  /// surname: 姓氏
  /// sex: 性别
  /// birthday:生日 格式 yyyy-MM-dd
  static Future<ApiResponse<List<TalkNameModel>>> saveName({
    String surname = '',
    String? sex = '',
    String? birthday = '',
    String? birth = '',
  }) {
    return HttpClient.post(
        '/api/disabuse/naming/save',
        data: {
          "surname": surname,
          "sex": sex,
          "birthday": birthday,
          "birth": birth,
        },
      dataConverter: (data) {
        if(data is List) {
          return data.map((e) => TalkNameModel.fromJson(e)).toList();
        }
        return [];
      },
    );
  }

  /// 解梦
  /// content: 梦的内容
  static Future<ApiResponse> saveDream({
    String content = '',
    String sex = '',
  }) {
    return HttpClient.post(
      '/api/disabuse/dream/save',
      data: {
        "content": content,
        "sex": sex,
      },
      dataConverter: (data) => data,
    );
  }

  /// 六爻-周易
  /// yao: 卦象（少阴 0，老阴 2，少阳 1， 老阳 3）,示例值(331011)
  /// question 疑惑
  static Future<ApiResponse> sixYao({
    String yao = '',
    String question = '',
  }) {
    return HttpClient.post(
      '/api/disabuse/divination/sixYao',
      data: {
        "yao": yao,
        "question": question,
      },
      dataConverter: (data) => data,
    );
  }

  /// 解惑-塔罗牌-获取三张随机牌
  static Future<ApiResponse<List>> getTarot() {
    return HttpClient.get(
      '/api/disabuse/tarot/getList',
      dataConverter: (data) => data,
    );
  }

  /// 解惑-塔罗牌
  /// question-	疑惑
  /// tarot-	塔罗牌url 格式：多个用英文逗号隔开
  static Future<ApiResponse<List>> saveTarot({
    String? question,
    String? tarot,
    String? url,
}) {
    return HttpClient.post(
      '/api/disabuse/tarot/save',
      data: {
        "question":question,
        "tarot":tarot,
        "url":url,
      },
      dataConverter: (data) => data,
    );
  }

  /// 查询用户解惑玩法历史
  /// type-	玩法类型（1占卜 2塔罗牌 3取名 4星座-运势 5星座-星盘 6星座-配对 7运势 8解梦）
  static Future<ApiResponse<List<HistoryModel>>> getProblemList({
    int? type,
    int page = 1,
    int size = 20,
  }) {
    return HttpClient.get(
      '/api/disabuse/log/getList',
      params: {
        "type":type,
        "page":page,
        "pageSize":size,
      },
      dataConverter: (data) {
        if(data is List) {
          return data.map((e) => HistoryModel.fromJson(e)).toList();
        }
        return [];
      },
    );
  }

  /// 根据点击的疑惑，查看详细对话
  /// id-	疑惑词关联的id
  static Future<ApiResponse<HistoryModel>> getLogDetail({
    int? id,
  }) {
    return HttpClient.get(
      '/api/disabuse/log/getDoubt',
      params: {
        "id":id,
      },
        dataConverter: (data) => HistoryModel.fromJson(data)
    );
  }

  /// 查询大家的疑惑（仅周易和塔罗牌玩法有疑惑）
  /// 	type 1周易占卜 2塔罗牌
  static Future<ApiResponse<List>> getDoubtList({
    int? type
}) {
    return HttpClient.get(
        '/api/disabuse/log/getDoubtList',
        params: {
          "type":type
        },
        dataConverter: (data) => data
    );
  }

  /// 解疑-获取玩法需要的境修币和是否免费
  /// type 玩法类型（1占卜 2塔罗牌 3取名 4星座-运势 5星座-星盘 6星座-配对 7运势 8解梦）
  static Future<ApiResponse<DisabuseGoldModel>> getGold({
    int? type = 1
  }) {
    return HttpClient.get(
        '/api/disabuse/log/getConfig',
        params: {
          "type":type
        },
        dataConverter: (data) => DisabuseGoldModel.fromJson(data)
    );
  }

  /// 解疑-删除解惑玩法历史记录
  /// id	历史记录id
  static Future<ApiResponse> getDelete({
    required int id
  }) {
    return HttpClient.get(
        '/api/disabuse/log/delete',
        params: {
          "id":id
        },
        dataConverter: (data) => data
    );
  }
}
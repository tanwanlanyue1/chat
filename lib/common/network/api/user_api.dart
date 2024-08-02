import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:guanjia/common/network/api/model/user/binding_info.dart';
import 'package:guanjia/common/network/api/model/user/level_money_info.dart';
import 'package:guanjia/common/network/httpclient/http_client.dart';
import 'package:guanjia/common/network/api/api.dart';

/// 用户API
class UserApi {
  const UserApi._();

  /// 初始化用户信息
  /// gender: 性别 1：男 2：女
  /// birth：生日
  /// likeSex：喜好性别 0：其它 1：男 2：女
  /// likeStyle：喜好风格id 字符串格式 英文逗号拼接
  static Future<ApiResponse> initUserInfo({
    int? gender,
    String? birth,
    int? likeSex,
    String? likeStyle,
  }) {
    return HttpClient.post(
      '/api/user/initUserInfo',
      data: {
        "gender": gender,
        "birth": birth,
        "likeSex": likeSex,
        "likeStyle": likeStyle,
      },
    );
  }

  /// 绑定手机号或第三方
  /// type: 1.微信 2.苹果 3.手机号
  /// state：类型 0解绑 1绑定
  /// code：第三方code
  /// phone：手机号
  /// verifyCode: 验证码
  static Future<ApiResponse> binding({
    required int type,
    required int state,
    String? code,
    String? phone,
    String? verifyCode,
  }) {
    return HttpClient.post(
      '/api/user/isBind',
      data: {
        "type": type,
        "state": state,
        "code": code,
        "phone": phone,
        "verifyCode": verifyCode,
      },
    );
  }

  /// 用户反馈
  /// type: 反馈类型
  /// contact：联系方式
  /// content：反馈内容
  /// images：图片，json格式
  static Future<ApiResponse> feedback({
    int type = 0,
    String? contact,
    String? content,
    String? images,
  }) {
    return HttpClient.post(
      '/api/user/feedback',
      data: {
        "type": type,
        "contact": contact,
        "content": content,
        "images": images,
      },
    );
  }

  /// 修改用户信息（不需要审核的）
  /// gender: 用户性别 0：保密 1：男 2：女
  /// zodiac：生肖
  /// star：星座
  /// birth：生日yyyy-MM-dd
  static Future<ApiResponse> modifyUserInfoNoCheck({
    int? gender,
    String? zodiac,
    String? star,
    String? birth,
  }) {
    return HttpClient.post(
      '/api/user/changeNoCheck',
      data: {
        "gender": gender,
        "zodiac": zodiac,
        "star": star,
        "birth": birth,
      },
    );
  }

  /// 修改用户信息（需要审核的）
  /// type: 修改类型(1:昵称 2:头像 3:个性签名)
  /// content：修改内容
  static Future<ApiResponse> modifyUserInfo({
    required int type,
    required String content,
  }) {
    return HttpClient.post(
      '/api/user/change',
      data: {
        "type": type,
        "content": content,
      },
    );
  }

  /// 是否关注
  /// uid: 查询对象的uid
  static Future<ApiResponse> isAttention({
    required int uid,
  }) {
    return HttpClient.get(
      '/api/user/isFollow',
      params: {
        "likedUid": uid,
      },
    );
  }

  /// 关注或者取关用户（关注成功返回0，取关成功返回1）
  /// uid: 关注或者取关对象的uid
  static Future<ApiResponse<int>> attention({
    required int uid,
  }) {
    return HttpClient.get(
      '/api/user/follow',
      params: {
        "likedUid": uid,
      },
    );
  }

  /// 获取关注或者粉丝列表
  /// type: 0.关注列表 1.粉丝列表
  /// page: 页码（默认1）,示例值(1)
  /// size: 每页数量（默认10）,示例值(10)
  static Future<ApiResponse<List<UserModel>>> attentionOrFansList({
    required int type,
    int? page,
    int? size,
  }) {
    return HttpClient.get(
      '/api/user/followList',
      params: {
        "type": type,
        "page": page,
        "size": size,
      },
      dataConverter: (json) {
        if (json is List) {
          return json.map((e) => UserModel.fromJson(e)).toList();
        }
        return [];
      },
    );
  }

  /// 获取用户信息
  static Future<ApiResponse<UserModel>> info({
    required int uid,
  }) {
    return HttpClient.get(
      '/api/user/info',
      params: {
        "uid": uid,
      },
      dataConverter: (json) => UserModel.fromJson(json),
    );
  }

  /// 我的-获取创作列表
  /// uid:用户id
  static Future<ApiResponse<List<PlazaListModel>>> getCreateList({
    required int id,
    int? page,
    int? size,
  }) {
    return HttpClient.get(
      '/api/user/getCreateList',
      params: {
        "uid": id,
        "page": page,
        "size": size,
      },
      dataConverter: (data) {
        if (data is List) {
          return data.map((e) => PlazaListModel.fromJson(e)).toList();
        }
        return [];
      },
    );
  }

  /// 获取绑定信息
  static Future<ApiResponse<BindingRes>> getBindingInfo() {
    return HttpClient.get(
      '/api/user/bindInfo',
      dataConverter: (json) {
        return BindingRes.fromJson(json);
      },
    );
  }

  /// 获取等级境修币信息
  static Future<ApiResponse<LevelMoneyRes>> getLevelAndMoney() {
    return HttpClient.get(
      '/api/user/levelAndMoney',
      dataConverter: (json) {
        return LevelMoneyRes.fromJson(json);
      },
    );
  }

  /// 获取用户 功德值 或 修行值 等级机制
  /// type: 0:功德值 1:修行值
  static Future<ApiResponse<List<LevelRes>>> getLevelList({
    required int type,
  }) {
    return HttpClient.get(
      '/api/user/getLevel',
      params: {
        "type": type,
      },
      dataConverter: (json) {
        if (json is List) {
          return json.map((e) => LevelRes.fromJson(e)).toList();
        }
        return [];
      },
    );
  }

  /// 获取关注数和粉丝数和创作数
  /// uid: 用户id
  static Future<ApiResponse> getFollowFansCount({
    required int uid,
  }) {
    return HttpClient.get(
      '/api/user/getFollowFansCount',
      params: {
        "uid": uid,
      },
    );
  }

  /// 获取收藏列表
  /// uid: 用户id
  /// page 页码（默认1）
  /// size 每页数量（默认10）,示例值(10)
  static Future<ApiResponse<List<PlazaListModel>>> getCollectList({
    required int uid,
    int page = 1,
    int size = 10,
  }) {
    return HttpClient.get(
      '/api/user/getCollectList',
      params: {
        "uid": uid,
        "page": page,
        "size": size,
      },
      dataConverter: (data) {
        if (data is List) {
          return data.map((e) => PlazaListModel.fromJson(e)).toList();
        }
        return [];
      },
    );
  }

  /// 用户功德记录
  /// month: 月份
  /// page 页码（默认1）
  /// size 每页数量（默认10）,示例值(10)
  static Future<ApiResponse<MeritVirtueList>> getMeritVirtueList({
    required String month,
    int page = 1,
    int size = 10,
  }) {
    return HttpClient.get(
      '/api/user/meritList',
      params: {
        "month": month,
        "page": page,
        "size": size,
      },
      dataConverter: (data) {
        return MeritVirtueList.fromJson(data);
      },
    );
  }

  /// 用户退出登录
  static Future<ApiResponse> signOut() {
    return HttpClient.get(
      '/api/user/logout',
    );
  }

  /// 添加修改用户档案（修改传档案id）
  /// id: id
  /// sex: 0:男 1:女
  /// avatar：头像
  /// nickname：反馈内容
  /// label：档案标签
  /// birth: 生日String（因为有未知）
  /// birthPlace: 出生地点
  /// currentResidence: 现居地
  /// timeZone: 时区
  static Future<ApiResponse> addOrModifyArchive({
    int? id,
    int? sex,
    String? avatar,
    String? nickname,
    String? label,
    String? birth,
    String? birthPlace,
    String? currentResidence,
    String? timeZone,
  }) {
    return HttpClient.post(
      '/api/user/saveProfiles',
      data: {
        "id": id,
        "sex": sex,
        "avatar": avatar,
        "nickname": nickname,
        "label": label,
        "birth": birth,
        "birthPlace": birthPlace,
        "currentResidence": currentResidence,
        "timeZone": timeZone,
      },
    );
  }

  /// 用户档案列表
  static Future<ApiResponse<List<ArchivesInfo>>> archiveList({
    int? page,
    int? size,
  }) {
    return HttpClient.get(
      '/api/user/ProfilesList',
      params: {
        "page": page,
        "size": size,
      },
      dataConverter: (json) {
        if (json is List) {
          return json.map((e) => ArchivesInfo.fromJson(e)).toList();
        }
        return [];
      },
    );
  }

  /// 文件上传
  /// file: 文件
  /// fileName: 文件名称（可选）
  /// onSendProgress: 发送进度
  static Future<ApiResponse<String>> upload({
    required String filePath,
    String? fileName,
    final void Function(int count, int total)? onSendProgress,
  }) async {
    final fileData = await MultipartFile.fromFile(
      filePath,
      filename: fileName,
    );

    return HttpClient.upload(
      '/api/user/upload',
      data: FormData.fromMap(
        {
          "file": fileData,
        },
      ),
      onSendProgress: onSendProgress,
    );
  }

  /// 文件上传
  /// file: 文件
  /// fileName: 文件名称（可选）
  /// onSendProgress: 发送进度
  static Future<ApiResponse<String>> uploadImageBytes({
    required Uint8List data,
    String? fileName,
    final void Function(int count, int total)? onSendProgress,
  }) async {
    final fileData = MultipartFile.fromBytes(data, filename: fileName);
    return HttpClient.upload(
      '/api/user/upload',
      data: FormData.fromMap(
        {
          "file": fileData,
        },
      ),
      onSendProgress: onSendProgress,
    );
  }

  /// 获取用户消息列表
  /// type: 消息类型:0系统消息，1赞，2收藏，3评论，4回复评论，5新增关注，6系统公告，7评论消息(3和4)
  static Future<ApiResponse<List<MessageList>>> getMessageList({
    required int type,
    int page = 1,
    int size = 10,
  }) {
    return HttpClient.get(
      '/api/user/getMessageList',
      params: {
        "type": type,
        "page": page,
        "size": size,
      },
      dataConverter: (json) {
        if (json is List) {
          return json.map((e) => MessageList.fromJson(e)).toList();
        }
        return [];
      },
    );
  }

  /// 删除消息
  /// ids	要删除的消息id
  static Future<ApiResponse> deleteMessage({
    required String ids,
  }) {
    return HttpClient.post(
      '/api/user/deleteMessage',
      data: {"ids": ids},
      dataConverter: (json) => json,
    );
  }

  /// 获取用户未读消息数量
  static Future<ApiResponse> getMessagesCounts() {
    return HttpClient.get(
      '/api/user/getMessagesCounts',
      dataConverter: (json) => json,
    );
  }

  /// 接约状态修改
  ///- state 接约状态 0不接约 1接约中 2约会进行中
  static Future<ApiResponse> updateState(int state) {
    return HttpClient.post(
      '/api/user/updateState',
      data: {
        'state': state,
      },
    );
  }
}

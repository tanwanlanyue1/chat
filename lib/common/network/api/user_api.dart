import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:guanjia/common/network/api/model/user/contract_model.dart';
import 'package:guanjia/common/network/httpclient/http_client.dart';
import 'package:guanjia/common/network/api/api.dart';

import 'model/user/message_unread_model.dart';

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

  /// 修改用户信息（new）增量修改
  /// avatar：头像
  /// nickname：昵称
  /// signature：个性签名
  /// gender：性别 0：保密 1：男 2：女
  /// birth：生日yyyy-MM-dd
  /// age：年龄
  /// position：位置
  /// email：邮箱
  /// phone：手机号
  /// occupation：职业
  /// style：风格
  /// likeSex：喜好性别 0：其它 1：男 2：女
  /// likeAgeMin：最小年龄
  /// likeAgeMax：最大年龄
  /// likeOccupation：喜好职业 1在职人员 2学生
  /// likeStyle：喜好风格
  /// images：个人图片 "1, 2, 4" 逗号隔开
  static Future<ApiResponse> updateInfoPartial({
    String? avatar,
    String? nickname,
    String? signature,
    int? gender,
    String? birth,
    int? age,
    String? position,
    String? email,
    String? phone,
    int? occupation,
    String? style,
    int? likeSex,
    int? likeAgeMin,
    int? likeAgeMax,
    int? likeOccupation,
    String? likeStyle,
    String? images,
  }) {
    return HttpClient.post(
      '/api/user/updateInfo',
      data: {
        "avatar": avatar,
        "nickname": nickname,
        "signature": signature,
        "gender": gender,
        "birth": birth,
        "age": age,
        "position": position,
        "email": email,
        "phone": phone,
        "occupation": occupation,
        "style": style,
        "likeSex": likeSex,
        "likeAgeMin": likeAgeMin,
        "likeAgeMax": likeAgeMax,
        "likeOccupation": likeOccupation,
        "likeStyle": likeStyle,
        "images": images,
      },
    );
  }

  /// 修改用户信息（new）全量修改
  /// type: 修改类型(1:昵称 2:头像 3:个性签名)
  /// content：修改内容
  static Future<ApiResponse> updateInfoFull({
    required Map<String, dynamic>? data,
  }) {
    return HttpClient.post(
      '/api/user/updateInfo',
      data: data,
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

  /// 获取绑定信息
  static Future<ApiResponse<BindingRes>> getBindingInfo() {
    return HttpClient.get(
      '/api/user/bindInfo',
      dataConverter: (json) {
        return BindingRes.fromJson(json);
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
  static Future<ApiResponse<List<MessageModel>>> getMessageList({
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
          return json.map((e) => MessageModel.fromJson(e)).toList();
        }
        return [];
      },
    );
  }

  /// 获取未读消息数量和最后一条消息内容
  /// - lastId 最后一条系统公告消息ID
  static Future<ApiResponse<MessageUnreadModel>> getMessageUnread({
    int? lastId,
  }) {
    return HttpClient.get(
      '/api/user/getMessageCount',
      params: {
        "lastId": lastId,
      },
      dataConverter: (json) => MessageUnreadModel.fromJson(json),
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

  /// 修改服务费
  /// serviceCharge：服务费
  static Future<ApiResponse> updateUserCharge({
    required double serviceCharge,
  }) {
    return HttpClient.post(
      '/api/user/updateUserCharge',
      data: {
        "type": 1,
        "serviceCharge": serviceCharge,
      },
      dataConverter: (json) => json,
    );
  }

  /// 绑定手机号或邮箱
  /// type：1.绑定手机号 2.绑定邮箱
  /// phone：手机号
  /// email：邮箱
  /// verifyCode：验证码
  /// idToken：firebase 短信验证码idToken
  static Future<ApiResponse> userBind({
    required int type,
    String? phone,
    String? email,
    String? verifyCode,
    String? idToken,
  }) {
    return HttpClient.post(
      '/api/user/bind',
      data: {
        "type": type,
        "phone": phone,
        "email": email,
        "verifyCode": verifyCode,
        "idToken": idToken,
      },
      dataConverter: (json) => json,
    );
  }

  /// 修改支付密码
  /// 第一次设置支付密码-不传递手机号与邮箱
  /// type: 验证类型 1手机号 2邮箱
  /// phone: 用户手机号
  /// email: 用户邮箱
  /// verifyCode：验证码
  /// idToken：SMS验证码idToken
  /// password：用户密码
  /// confirmPassword：确认密码
  static Future<ApiResponse> updatePayPwd({
    int? type,
    String? phone,
    String? email,
    String? verifyCode,
    String? idToken,
    required String password,
    required String confirmPassword,
  }) {
    return HttpClient.post(
      '/api/user/updatePayPwd',
      data: {
        "type": type,
        "phone": phone,
        "email": email,
        "verifyCode": verifyCode,
        "idToken": idToken,
        "password": password,
        "confirmPassword": confirmPassword,
      },
      dataConverter: (json) => json,
    );
  }

  /// 用户进阶
  /// type: 用户类型 0普通用户 1佳丽 2经纪人
  static Future<ApiResponse> userAdvanced({
    int? type,
  }) {
    return HttpClient.post(
      '/api/user/userAdvanced',
      data: {
        "type": type,
      },
      dataConverter: (json) => json,
    );
  }

  /// 用户进阶查询
  static Future<ApiResponse<UserAdvanced?>> getUserAdvanced() {
    return HttpClient.get(
      '/api/user/getUserAdvanced',
      dataConverter: (data) {
        if (data is Map) {
          return UserAdvanced.fromJson(data);
        }
        return null;
      },
    );
  }

  /// 根据账号ID查找用户
  static Future<ApiResponse<UserModel?>> queryUserByChatNo(int chatNo) {
    return HttpClient.get(
      '/api/user/queryUserByChatNo',
      params: {'chatNo': chatNo},
      dataConverter: (json) {
        if (json != null) {
          return UserModel.fromJson(json);
        }
        return null;
      },
    );
  }

  /// 获取团队接约中成员列表
  static Future<ApiResponse<List<TeamUser>>> getOnlineTeamUserList({
    int page = 1,
    int size = 10,
  }) {
    return HttpClient.get(
      '/api/user/listOnlineMember',
      params: {
        "page": page,
        "size": size,
      },
      dataConverter: (json) {
        if (json is List) {
          return json.map((e) => TeamUser.fromJson(e)).toList();
        }
        return [];
      },
    );
  }

  /// 契约单 - 获取经纪人团队列表 TeamUser
  static Future<ApiResponse<ApiPageData<TeamUser>>> getTeamUserList({
    int page = 1,
    int size = 10,
  }) {
    return HttpClient.get(
      '/api/user/getTeamUserList',
      params: {
        "page": page,
        "size": size,
      },
      dataConverter: (data) =>
          ApiPageData.fromJson(data, TeamUser.fromJson, dataFieldName: "list"),
      // dataConverter: (json) {
      //   if(json != null && json['list'] is List){
      //     return {
      //       "total": json['total'] ?? 0,
      //       "list": json['list'].map((e) => TeamUser.fromJson(e)).toList(),
      //     };
      //   }
      //   return {};
      // }
    );
  }

  /// 谁看过我
  static Future<ApiResponse<List<VisitList>>> getVisitList({
    int page = 1,
    int size = 10,
  }) {
    return HttpClient.get(
      '/api/user/getVisitList',
      params: {
        "page": page,
        "size": size,
      },
      dataConverter: (json) {
        if (json is List) {
          return json.map((e) => VisitList.fromJson(e)).toList();
        }
        return [];
      },
    );
  }

  /// 交友大厅-推荐列表
  /// 	location: 坐标 经纬度用英文逗号隔开
  /// 	distance:距离 单位km
  /// 	gender: 性别 1：男 2：女
  /// 	minAge: 最小年龄
  /// 	maxAge: 最大年龄
  /// 	style: 风格
  static Future<ApiResponse<List<RecommendModel>>> recommendList({
    String? location,
    int? distance,
    int? gender,
    int? minAge,
    int? maxAge,
    String? style,
    int page = 1,
    int size = 10,
  }) {
    return HttpClient.get(
      '/api/user/recommendList',
      params: {
        "location": location,
        "distance": distance,
        "gender": gender,
        "minAge": minAge,
        "maxAge": maxAge,
        "style": style,
        "page": page,
        "size": size,
      },
      dataConverter: (json) {
        if (json is List) {
          return json.map((e) => RecommendModel.fromJson(e)).toList();
        }
        return [];
      },
    );
  }

  /// 契约单-获取当前经纪人已关注未签约的佳丽列表
  /// page: 页码（默认1）,示例值(1)
  /// size: 每页数量（默认10）,示例值(10)
  static Future<ApiResponse<List<UserModel>>> getUnsignedBeautyList({
    required int page,
    required int size,
  }) {
    return HttpClient.get(
      '/api/user/listNoContractUser',
      params: {
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

  /// 契约单-获取契约单列表
  /// page: 页码（默认1）,示例值(1)
  /// size: 每页数量（默认10）,示例值(10)
  static Future<ApiResponse<List<ContractModel>>> listContract({
    required int page,
    required int size,
  }) {
    return HttpClient.get(
      '/api/user/listContract',
      params: {
        "page": page,
        "size": size,
      },
      dataConverter: (json) {
        if (json is List) {
          return json.map((e) => ContractModel.fromJson(e)).toList();
        }
        return [];
      },
    );
  }

  /// 契约单-生成
  /// - partyAId 	甲方id
  /// - partyAName 	甲方名
  /// - partyBId	乙方id
  /// - partyBName 	乙方名
  /// - content 契约单内容
  /// - brokerageService 	服务费甲方分成比例%
  /// - brokerageChatting 陪聊甲方分成比例%
  static Future<ApiResponse<void>> addContract({
    required int partyAId,
    required String partyAName,
    required int partyBId,
    required String partyBName,
    required String content,
    required num brokerageService,
    required num brokerageChatting,
  }) {
    return HttpClient.post(
      '/api/user/addContract',
      data: {
        "partyAId": partyAId,
        "partyAName": partyAName,
        "partyBId": partyBId,
        "partyBName": partyBName,
        "content": content,
        "brokerageService": brokerageService,
        "brokerageChatting": brokerageChatting,
      },
    );
  }

  /// 契约单-佳丽接受或拒绝契约单、经纪人解约契约单
  /// - type 	类型 1同意签约 2拒绝签约 3解除签约
  /// - contractId 	契约单ID
  static Future<ApiResponse<void>> updateContract({
    required int type,
    required int contractId,
  }) {
    return HttpClient.post(
      '/api/user/updateContract',
      data: {
        "type": type,
        "contractId": contractId,
      },
    );
  }

  /// 获取契约单模板
  static Future<ApiResponse<ContractModel>> getContractTemplate() {
    return HttpClient.get(
      '/api/user/getContractTemplate',
      dataConverter: (json) => ContractModel.fromJson(json),
    );
  }

  /// 获取契约单详情
  static Future<ApiResponse<ContractModel>> getContract(int id) {
    return HttpClient.get(
      '/api/user/getContract',
      params: {'id': id},
      dataConverter: (json) => ContractModel.fromJson(json),
    );
  }

  /// 交友大厅-附近用户列表
  /// 	location: 坐标 经纬度用英文逗号隔开
  /// 	distance:距离 单位km
  /// 	gender: 性别 1：男 2：女
  /// 	minAge: 最小年龄
  /// 	maxAge: 最大年龄
  /// 	style: 风格
  static Future<ApiResponse<List<RecommendModel>>> nearbyUserList({
    String? location,
    int? distance,
    int? gender,
    int? minAge,
    int? maxAge,
    String? style,
    int page = 1,
    int size = 10,
  }) {
    return HttpClient.get(
      '/api/user/nearbyUserList',
      params: {
        "location": location,
        "distance": distance,
        "gender": gender,
        "minAge": minAge,
        "maxAge": maxAge,
        "style": style,
        "page": page,
        "size": size,
      },
      dataConverter: (json) {
        if (json is List) {
          return json.map((e) => RecommendModel.fromJson(e)).toList();
        }
        return [];
      },
    );
  }

  /// 用户位置更新
  /// longitude:经度
  /// latitude:	纬度
  static Future<ApiResponse> updateAccountPosition({
    String? longitude,
    String? latitude,
  }) {
    return HttpClient.post(
      '/api/user/updateAccountPosition',
      data: {
        "longitude": longitude,
        "latitude": latitude,
      },
      dataConverter: (json) => json,
    );
  }

  /// 获取钱包日志记录
  ///- logType: 记录类型 -1查询全部 1 充值 2.后台下发 3.后台扣减 4 订单保证金或服务费 5 通话实时扣费 6通话订单收益 7转账 8红包 9开通会员 12陪聊分成 13约会分成
  ///- page: 页码（默认1）,示例值(1)
  ///- size: 每页数量（默认10）,示例值(10)
  ///- startDate 开始时间 yyyy-mm-dd
  ///- endDate yyyy-mm-dd
  static Future<ApiResponse<PurseLogListModel>> getPurseLogList({
    required List<int> logType,
    int page = 1,
    int size = 10,
    String? startDate,
    String? endDate,
  }) {
    return HttpClient.get(
      '/api/user/getPurseLogList',
      params: {
        "logType": logType,
        "page": page,
        "size": size,
        if(startDate != null && endDate != null) "startDate": startDate,
        if(startDate != null && endDate != null) "endDate": endDate,
      },
      dataConverter: (json) => PurseLogListModel.fromJson(json),
    );
  }

  /// 注销账号
  /// type：注销理由
  /// verifyCode：验证码
  /// googleToken：谷歌token
  static Future<ApiResponse> cancelAccount({
    String? phone,
    String? email,
    int? type,
    String? verifyCode,
    String? idToken,
  }) {
    return HttpClient.post(
      '/api/user/cancelAccount',
      data: {
        "phone": phone,
        "email": email,
        "type": type,
        "verifyCode": verifyCode,
        "idToken": idToken,
      },
      dataConverter: (json) => json,
    );
  }
}

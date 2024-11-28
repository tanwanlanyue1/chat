import 'dart:convert';

import 'package:guanjia/common/network/httpclient/http_client.dart';
import 'package:guanjia/common/network/api/api.dart';

///广场API
class PlazaApi{
  const PlazaApi._();

  /// 获取广场列表
  ///- location：坐标 经纬度用英文逗号隔开（地图传递才有效）
  ///- distance 	距离 单位km gender 性别 1：男 2：女 minAge最小年龄 style 风格
  ///- type 类型： 1 帖子 2私房照
  ///- sort 排序方式 0发布时间倒叙 1点赞数倒叙 默认0
  static Future<ApiResponse<List<PlazaListModel>>> getCommunityList({
    String? location,
    int? distance,
    int? gender,
    int? minAge,
    int? maxAge,
    String? style,
    int currentPage = 1,
    int? pageSize = 10,
    int type = 1,
    int sort = 0,
}) {
    return HttpClient.get(
      '/api/community/list',
      params: {
        "location": location,
        "distance": distance,
        "gender": gender,
        "minAge": minAge,
        "maxAge": maxAge,
        "style": style,
        'page': currentPage,
        'size': pageSize,
        'type': type,
        if(type == 2)'sort': sort,
      },
      dataConverter: (data) {
        if(data is List) {
          return data.map((e) => PlazaListModel.fromJson(e)).toList();
        }
        return [];
      },
    );
  }

  /// 点赞或者取消点赞（点赞成功返回0，取消成功返回1）
  /// id:数据id
  static Future<ApiResponse> getCommentLike({
    required int id,
  }) {
    return HttpClient.get(
      '/api/community/like',
      params: {
        "postId":id,
      },
      dataConverter: (data) => data,
    );
  }

  /// 帖子收藏或者取消收藏（收藏成功返回0，取消成功返回1）
  /// id:	帖子id
  static Future<ApiResponse> getCommentCollect({
    required int id,
  }) {
    return HttpClient.get(
      '/api/community/collect',
      params: {
        "id":id,
      },
      dataConverter: (data) => data,
    );
  }

  /// 获取广场评论列表
  /// id:广场id
  /// id:类型（默认0最新，1最早）
  static Future<ApiResponse<List<CommentListModel>>> getCommentList({
    required int id,
    int type = 0,
  }) {
    return HttpClient.get(
      '/api/community/commentList',
      params: {
        "id":id,
        "type":type,
      },
      dataConverter: (data) {
        if(data is List) {
          return data.map((e) => CommentListModel.fromJson(e)).toList();
        }
        return [];
      },
    );
  }

  /// 评论-广场
  /// pid:根评论id
  /// replyId:回复的评论id
  /// postId:帖子id
  /// content:内容
  static Future<ApiResponse> postComment({
    int? pid,
    int? replyId,
    int? postId,
    String? content,
  }) {
    return HttpClient.post(
      '/api/community/comment',
      data: {
        "pid":pid,
        "replyId":replyId,
        "postId":postId,
        "content":content,
      },
      dataConverter: (data) => data,
    );
  }

  /// 获取自己的帖子列表
  /// uid:用户id
  static Future<ApiResponse<List<PlazaListModel>>> getMyPostList({
    required int uid,
    int? page,
    int? size,
  }) {
    return HttpClient.get(
      '/api/community/getMyPostList',
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

  /// 发布帖子、私房照
  /// - type 类型： 1 帖子 2私房照
  /// - images 图片数组
  /// - video 视频，只能传一个
  /// - videoCover 视频封面
  /// - price 私房照解锁价格
  static Future<ApiResponse> addCommunity({
    int type = 1,
    required String content,
    List<String>? images,
    String? video,
    String? videoCover,
    double? price,
}) {
    return HttpClient.post(
      '/api/community/add',
      data: {
        // "title":title,
        "type":type,
        "content":content,
        if(images != null) "images":jsonEncode(images),
        if(video != null ) "video":video,
        if(videoCover != null ) "videoCover":videoCover,
        if(price != null ) "price":price,
      },
      dataConverter: (data) => data,
    );
  }

  /// 获取关注帖子列表
  static Future<ApiResponse<List<PlazaListModel>>> followList({
    int? page,
    int? size,
  }) {
    return HttpClient.get(
      '/api/community/followList',
      params: {
        "page":page,
        "size":size,
      },
      dataConverter: (data) {
        if (data is List) {
          return data.map((e) => PlazaListModel.fromJson(e)).toList();
        }
        return [];
      },
    );
  }

  /// 删除帖子
  static Future<ApiResponse> deleteCommunity({
    required int id,
  }) {
    return HttpClient.get(
      '/api/community/delete',
      params: {
        "id":id,
      },
      dataConverter: (data) => data,
    );
  }

  /// 获取指定位置附近的帖子发布用户列表
  static Future<ApiResponse<List<NearbyPostUserModel>>> getNearbyPostUserList({
    String? location,
  }) {
    return HttpClient.get(
      '/api/community/getNearbyPostUserList',
      params: {
        "location": location,
      },
      dataConverter: (data) {
        if (data is List) {
          return data.map((e) => NearbyPostUserModel.fromJson(e)).toList();
        }
        return [];
      },
    );
  }
}
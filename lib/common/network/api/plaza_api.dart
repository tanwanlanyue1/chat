import 'package:guanjia/common/network/httpclient/http_client.dart';
import 'package:guanjia/common/network/api/api.dart';

///广场API
class PlazaApi{
  const PlazaApi._();

  /// 获取广场列表
  /// type:推荐类型 0最新，1热门
  /// zoneId：专区id
  /// topicId：话题id
  static Future<ApiResponse<List<PlazaListModel>>> getCommunityList({
    int? type = 0,
    int? zoneId,
    int? topicId,
    int currentPage = 1,
    int? pageSize = 10,
}) {
    return HttpClient.get(
      '/api/community/list',
      params: {
        "type": type,
        "zoneId": zoneId,
        "topicId": topicId,
        'page': currentPage,
        'size': pageSize,
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
  /// type:点赞类型（1动态2评论）
  static Future<ApiResponse> getCommentLike({
    required int id,
    required int type,
  }) {
    return HttpClient.get(
      '/api/community/like',
      params: {
        "id":id,
        "type":type,
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
  /// id:类型（默认0热门，1最新，2最早）
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

  /// 发布帖子
  static Future<ApiResponse> addCommunity({
    required String content,
    required String images,
    String? video
}) {
    return HttpClient.post(
      '/api/community/add',
      data: {
        // "title":title,
        "content":content,
        "images":images,
        "video":video,
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
}
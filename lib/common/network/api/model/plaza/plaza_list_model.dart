import 'dart:ffi';

import '../open/app_config_model.dart';
import 'comment_list_model.dart';

class PlazaListModel {
  PlazaListModel({
    //	动态id
    this.postId,
    //	标题
    this.title,
    //内容
    this.content,
    //图片json数组
    this.images,
    //	预留：视频，只能传一个
    this.video,
    this.viewNum,
    //	评论数
    this.commentNum,
    //点赞数量
    this.likeNum,
    this.collectNum,
    //置顶：0否1是
    this.top,
    this.good,
    //	是否点赞：true是false否
    this.isLike,
    this.isCollect,
    //创建时间
    this.createTime,
    //用户id
    this.uid,
    //	头像
    this.avatar,
    //	昵称
    this.nickname,
    //用户性别 0：保密 1：男 2：女
    this.gender,
    //年龄
    this.age,
    //用户类型 0普通用户 1佳丽 2经纪人
    this.type,
    //vip图标
    this.nameplate,
    //风格列表
    this.styleList,
    // 职业 1在职人员 2学生
    this.occupation,
    //广场-帖子列表（根评论）
    this.commentList,
    //私房照价格
    this.price,
    //是否是视频
    this.isVideo,
    // 是否解锁
    this.isUnlock,
    //视频封面
    this.videoCover,

  });

  PlazaListModel.fromJson(dynamic json) {
    postId = json['postId'];
    title = json['title'];
    content = json['content'];
    images = json['images'];
    video = json['video'];
    viewNum = json['viewNum'];
    commentNum = json['commentNum'];
    likeNum = json['likeNum'];
    collectNum = json['collectNum'];
    top = json['top'];
    good = json['good'];
    isLike = json['isLike'];
    isCollect = json['isCollect'];
    createTime = json['createTime'];
    uid = json['uid'];
    avatar = json['avatar'];
    nickname = json['nickname'];
    gender = json['gender'];
    age = json['age'];
    type = json['type'];
    nameplate = json['nameplate'];
    occupation = json['occupation'];
    price = json['price'];
    videoCover = json['videoCover'];
    isVideo = json['isVideo'];
    isUnlock = json['isUnlock'];
    if (json['styleList'] != null) {
      styleList = [];
      json['styleList'].forEach((v) {
        styleList?.add(LabelModel.fromJson(v));
      });
    }
    if (json['commentList'] != null) {
      commentList = [];
      json['commentList'].forEach((v) {
        commentList?.add(CommentListModel.fromJson(v));
      });
    }
  }
  int? postId;
  String? title;
  String? content;
  dynamic images;
  String? video;
  int? viewNum;
  int? commentNum;
  int? likeNum;
  int? collectNum;
  int? top;
  int? good;
  bool? isLike;
  bool? isCollect;
  int? createTime;
  int? uid;
  String? avatar;
  String? nickname;
  int? gender;
  int? age;
  int? type;
  int? occupation;
  double? price;
  bool? isVideo;
  bool? isUnlock;
  String? videoCover;
  String? nameplate;
  List<LabelModel>? styleList;
  List<CommentListModel>? commentList;
  PlazaListModel copyWith({  int? postId,
    String? title,
    String? content,
    dynamic images,
    String? video,
    int? viewNum,
    int? commentNum,
    int? likeNum,
    int? collectNum,
    int? top,
    int? good,
    bool? isLike,
    bool? isCollect,
    int? createTime,
    int? uid,
    String? avatar,
    String? nickname,
    int? gender,
    int? age,
    int? type,
    int? occupation,
    double? price,
    bool? isVideo,
    bool? isUnlock,
    String? videoCover,
    String? nameplate,
    List<LabelModel>? styleList,
    List<CommentListModel>? commentList,
  }) => PlazaListModel(  postId: postId ?? this.postId,
    title: title ?? this.title,
    content: content ?? this.content,
    images: images ?? this.images,
    video: video ?? this.video,
    viewNum: viewNum ?? this.viewNum,
    commentNum: commentNum ?? this.commentNum,
    likeNum: likeNum ?? this.likeNum,
    collectNum: collectNum ?? this.collectNum,
    top: top ?? this.top,
    good: good ?? this.good,
    isLike: isLike ?? this.isLike,
    isCollect: isCollect ?? this.isCollect,
    createTime: createTime ?? this.createTime,
    uid: uid ?? this.uid,
    avatar: avatar ?? this.avatar,
    nickname: nickname ?? this.nickname,
    gender: gender ?? this.gender,
    age: age ?? this.age,
    type: type ?? this.type,
    occupation: occupation ?? this.occupation,
    price: price ?? this.price,
    videoCover: videoCover ?? this.videoCover,
    isVideo: isVideo ?? this.isVideo,
    isUnlock: isUnlock ?? this.isUnlock,
    nameplate: nameplate ?? this.nameplate,
    styleList: styleList ?? this.styleList,
    commentList: commentList ?? this.commentList,
  );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['postId'] = postId;
    map['title'] = title;
    map['content'] = content;
    map['images'] = images;
    map['video'] = video;
    map['viewNum'] = viewNum;
    map['commentNum'] = commentNum;
    map['likeNum'] = likeNum;
    map['collectNum'] = collectNum;
    map['top'] = top;
    map['good'] = good;
    map['isLike'] = isLike;
    map['isCollect'] = isCollect;
    map['createTime'] = createTime;
    map['uid'] = uid;
    map['avatar'] = avatar;
    map['nickname'] = nickname;
    map['gender'] = gender;
    map['age'] = age;
    map['type'] = type;
    map['occupation'] = occupation;
    map['price'] = price;
    map['videoCover'] = videoCover;
    map['isVideo'] = isVideo;
    map['isUnlock'] = isUnlock;
    map['nameplate'] = nameplate;
    if (map['styleList'] != null) {
      map['styleList'] = styleList?.map((v) => v.toJson()).toList();
    }
    if (commentList != null) {
      map['commentList'] = commentList?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}
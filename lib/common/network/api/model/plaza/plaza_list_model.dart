import 'comment_list_model.dart';

class PlazaListModel {
  PlazaListModel({
    this.postId,
    this.title,
    this.content,
    this.images,
    this.video,
    this.viewNum,
    this.commentNum,
    this.likeNum,
    this.collectNum,
    this.top,
    this.good,
    this.isLike,
    this.isCollect,
    this.createTime,
    this.uid,
    this.avatar,
    this.nickname,
    this.gender,
    this.age,
    this.type,
    this.commentList,});

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
  String? createTime;
  int? uid;
  String? avatar;
  String? nickname;
  int? gender;
  int? age;
  int? type;
  List<CommentListModel>? commentList;

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
    if (commentList != null) {
      map['commentList'] = commentList?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}
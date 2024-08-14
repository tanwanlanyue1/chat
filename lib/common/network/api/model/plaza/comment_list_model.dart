
///评论列表
class CommentListModel {
  CommentListModel({
    //评论id
    int? id,
    //根评论id
    int? pid,
    //回复的评论id
    int? replyId,
    //	帖子id
    int? postId,
    //	年龄
    int? age,
    //用户性别 0：保密 1：男 2：女
    int? gender,
    //用户uid
    int? uid,
    //头像
    String? avatar,
    //	昵称
    String? nickname,
    //星座
    String? star,
    //修行等级
    int? cavLevel,
    //内容
    String? content,
    //点赞数量
    int? likeNum,
    //总回复数
    int? commentNum,
    //是否点赞 true：已点赞 false：未点赞
    bool? isLike,
    //	创建时间
    String? createTime,
    //	广场-子评论
    List<CommentListModel>? subComment,}){
    _id = id;
    _pid = pid;
    _replyId = replyId;
    _postId = postId;
    _age = age;
    _gender = gender;
    _uid = uid;
    _content = content;
    _cavLevel = cavLevel;
    _nickname = nickname;
    _avatar = avatar;
    _star = star;
    _likeNum = likeNum;
    _commentNum = commentNum;
    _isLike = isLike;
    _createTime = createTime;
    _subComment = subComment;
}

  CommentListModel.fromJson(dynamic json) {
    _id = json['id'];
    _pid = json['pid'];
    _replyId = json['replyId'];
    _postId = json['postId'];
    _age = json['age'];
    _gender = json['gender'];
    _uid = json['uid'];
    _content = json['content'];
    _cavLevel = json['cavLevel'];
    _nickname = json['nickname'];
    _avatar = json['avatar'];
    _star = json['star'];
    _likeNum = json['likeNum'];
    _commentNum = json['commentNum'];
    _isLike = json['isLike'];
    _createTime = json['createTime'];
    if (json['subComment'] != null) {
      _subComment = [];
      json['subComment'].forEach((v) {
        _subComment?.add(CommentListModel.fromJson(v));
      });
    }
  }
  int? _id;
  int? _pid;
  int? _replyId;
  int? _postId;
  int? _age;
  int? _gender;
  int? _uid;
  String? _content;
  int? _cavLevel;
  String? _avatar;
  String? _nickname;
  String? _star;
  int? _likeNum;
  int? _commentNum;
  bool? _isLike;
  String? _createTime;
  List<CommentListModel>? _subComment;
CommentListModel copyWith({  int? id,
  int? pid,
  int? replyId,
  int? postId,
  int? age,
  int? gender,
  int? uid,
  String? content,
  int? cavLevel,
  String? avatar,
  String? nickname,
  String? star,
  int? likeNum,
  int? commentNum,
  bool? isLike,
  String? createTime,
  List<CommentListModel>? subComment,
}) => CommentListModel(  id: id ?? _id,
  pid: pid ?? _pid,
  replyId: replyId ?? _replyId,
  postId: postId ?? _postId,
  age: age ?? _age,
  gender: gender ?? _gender,
  uid: uid ?? _uid,
  content: content ?? _content,
  cavLevel: cavLevel ?? _cavLevel,
  avatar: avatar ?? _avatar,
  nickname: nickname ?? _nickname,
  star: star ?? _star,
  likeNum: likeNum ?? _likeNum,
  commentNum: commentNum ?? _commentNum,
  isLike: isLike ?? _isLike,
  createTime: createTime ?? _createTime,
  subComment: subComment ?? _subComment,
);
  int? get id => _id;
  int? get pid => _pid;
  int? get replyId => _replyId;
  int? get postId => _postId;
  int? get age => _age;
  int? get gender => _gender;
  int? get uid => _uid;
  String? get content => _content;
  int? get cavLevel => _cavLevel;
  String? get avatar => _avatar;
  String? get nickname => _nickname;
  String? get star => _star;
  int? get likeNum => _likeNum;
  int? get commentNum => _commentNum;
  bool? get isLike => _isLike;
  String? get createTime => _createTime;
  List<CommentListModel>? get subComment => _subComment;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['pid'] = _pid;
    map['replyId'] = _replyId;
    map['postId'] = _postId;
    map['age'] = _age;
    map['gender'] = _gender;
    map['uid'] = _uid;
    map['content'] = _content;
    map['cavLevel'] = _cavLevel;
    map['avatar'] = _avatar;
    map['nickname'] = _nickname;
    map['star'] = _star;
    map['likeNum'] = _likeNum;
    map['commentNum'] = _commentNum;
    map['isLike'] = _isLike;
    map['createTime'] = _createTime;
    if (_subComment != null) {
      map['subComment'] = _subComment?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

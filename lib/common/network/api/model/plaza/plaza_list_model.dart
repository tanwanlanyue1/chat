
///广场列表model
class PlazaListModel {
  PlazaListModel({
    ///广场id
    int? postId,
    ///专区id
    int? zoneId,
    ///专区名称
    String? zoneName = '',
    ///话题id
    int? topicId,
    ///话题名称
    String? topicName,
    ///话题热度
    int? topicHot,
    ///标题
    String? title,
    ///内容
    String? content,
    ///	图片json数组
    dynamic images,
    ///视频/后续可能会加
    String? video,
    ///热度 查看数量
    int? viewNum,
    ///评论数
    int? commentNum = 0,
    ///	点赞数量
    int? likeNum = 0,
    ///收藏数
    int? collectNum = 0,
    ///置顶：0否1是
    int? top,
    ///优质：0否1是
    int? good,
    ///是否点赞：true是false否
    bool? isLike,
    ///创建时间
    String? createTime = "",
    ///用户id
    int? uid,
    ///头像
    String? avatar,
    ///昵称
    String? nickname,
    ///用户性别 0：保密 1：男 2：女
    int? gender,
    //	修行等级
    int? cavLevel,
    ///生肖
    String? zodiac = '',
    ///星座
    String? star = '',
    ///是否收藏
    bool? isCollect = false,
    ///广场详情-id
    int? id,
    //历史记录
    ///浏览时间
    String? browsingTime = "",
    ///时间戳
    int? browsingTimeStamp = 0,
  }){
    _postId = postId;
    _zoneId = zoneId;
    _zoneName = zoneName;
    _topicId = topicId;
    _topicName = topicName;
    _topicHot = topicHot;
    _title = title;
    _content = content;
    _images = images;
    _video = video;
    _viewNum = viewNum;
    _commentNum = commentNum;
    _likeNum = likeNum;
    _collectNum = collectNum;
    _top = top;
    _good = good;
    _isLike = isLike;
    _createTime = createTime;
    _uid = uid;
    _avatar = avatar;
    _nickname = nickname;
    _gender = gender;
    _cavLevel = cavLevel;
    _zodiac = zodiac;
    _star = star;
    _isCollect = isCollect;
    _browsingTime = browsingTime;
    _browsingTimeStamp = browsingTimeStamp;
    _id = id;
}

  PlazaListModel.fromJson(dynamic json) {
    _postId = json['postId'];
    _zoneId = json['zoneId'];
    _zoneName = json['zoneName'];
    _topicId = json['topicId'];
    _topicName = json['topicName'];
    _topicHot = json['topicHot'];
    _title = json['title'];
    _content = json['content'];
    _images = json['images'];
    _video = json['video'];
    _viewNum = json['viewNum'];
    _commentNum = json['commentNum'];
    _likeNum = json['likeNum'];
    _collectNum = json['collectNum'];
    _top = json['top'];
    _good = json['good'];
    _isLike = json['isLike'];
    _createTime = json['createTime'];
    _uid = json['uid'];
    _avatar = json['avatar'];
    _nickname = json['nickname'];
    _gender = json['gender'];
    _cavLevel = json['cavLevel'];
    _zodiac = json['zodiac'];
    _star = json['star'];
    _isCollect = json['isCollect'];
    _id = json['id'];
    _browsingTime = json["browsingTime"] ?? "";
    _browsingTimeStamp = json["browsingTimeStamp"] ?? 0;
  }
  int? _postId;
  int? _zoneId;
  String? _zoneName;
  int? _topicId;
  String? _topicName;
  int? _topicHot;
  String? _title;
  String? _content;
  dynamic _images;
  String? _video;
  int? _viewNum;
  int? _commentNum;
  int? _likeNum;
  int? _collectNum;
  int? _top;
  int? _good;
  bool? _isLike;
  String? _createTime;
  int? _uid;
  String? _avatar;
  String? _nickname;
  int? _gender;
  int? _cavLevel;
  String? _zodiac;
  String? _star;
  bool? _isCollect;
  String? _browsingTime;
  int? _browsingTimeStamp;
  int? _id;
PlazaListModel copyWith({  int? postId,
  int? zoneId,
  String? zoneName,
  int? topicId,
  String? topicName,
  int? topicHot,
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
  String? createTime,
  int? uid,
  String? avatar,
  String? nickname,
  int? gender,
  int? cavLevel,
  String? zodiac,
  String? star,
  bool? isCollect,
  String? browsingTime,
  int? browsingTimeStamp,
  int? id,
}) => PlazaListModel(  postId: postId ?? _postId,
  zoneId: zoneId ?? _zoneId,
  zoneName: zoneName ?? _zoneName,
  topicId: topicId ?? _topicId,
  topicName: topicName ?? _topicName,
  topicHot: topicHot ?? _topicHot,
  title: title ?? _title,
  content: content ?? _content,
  images: images ?? _images,
  video: video ?? _video,
  viewNum: viewNum ?? _viewNum,
  commentNum: commentNum ?? _commentNum,
  likeNum: likeNum ?? _likeNum,
  collectNum: collectNum ?? _collectNum,
  top: top ?? _top,
  good: good ?? _good,
  isLike: isLike ?? _isLike,
  createTime: createTime ?? _createTime,
  uid: uid ?? _uid,
  avatar: avatar ?? _avatar,
  nickname: nickname ?? _nickname,
  gender: gender ?? _gender,
  cavLevel: cavLevel ?? _cavLevel,
  zodiac: zodiac ?? _zodiac,
  star: star ?? _star,
  isCollect: isCollect ?? _isCollect,
  browsingTime: browsingTime ?? _browsingTime,
  browsingTimeStamp: browsingTimeStamp ?? _browsingTimeStamp,
  id: id ?? _id,
);
  int? get postId => _postId;
  int? get zoneId => _zoneId;
  String? get zoneName => _zoneName;
  int? get topicId => _topicId;
  String? get topicName => _topicName;
  int? get topicHot => _topicHot;
  String? get title => _title;
  String? get content => _content;
  dynamic get images => _images;
  String? get video => _video;
  int? get viewNum => _viewNum;
  int? get commentNum => _commentNum;
  int? get likeNum => _likeNum;
  int? get collectNum => _collectNum;
  int? get top => _top;
  int? get good => _good;
  bool? get isLike => _isLike;
  String? get createTime => _createTime;
  int? get uid => _uid;
  String? get avatar => _avatar;
  String? get nickname => _nickname;
  int? get gender => _gender;
  int? get cavLevel => _cavLevel;
  String? get zodiac => _zodiac;
  String? get star => _star;
  bool? get isCollect => _isCollect;
  String? get browsingTime => _browsingTime;
  int? get browsingTimeStamp => _browsingTimeStamp;
  int? get id => _id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['postId'] = _postId;
    map['zoneId'] = _zoneId;
    map['zoneName'] = _zoneName;
    map['topicId'] = _topicId;
    map['topicName'] = _topicName;
    map['topicHot'] = _topicHot;
    map['title'] = _title;
    map['content'] = _content;
    map['images'] = _images;
    map['video'] = _video;
    map['viewNum'] = _viewNum;
    map['commentNum'] = _commentNum;
    map['likeNum'] = _likeNum;
    map['collectNum'] = _collectNum;
    map['top'] = _top;
    map['good'] = _good;
    map['isLike'] = _isLike;
    map['createTime'] = _createTime;
    map['uid'] = _uid;
    map['avatar'] = _avatar;
    map['nickname'] = _nickname;
    map['gender'] = _gender;
    map['cavLevel'] = _cavLevel;
    map['zodiac'] = _zodiac;
    map['star'] = _star;
    map['isCollect'] = _isCollect;
    map['browsingTime'] = _browsingTime;
    map['browsingTimeStamp'] = _browsingTimeStamp;
    map['id'] = _id;
    return map;
  }

}
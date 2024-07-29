
///开屏广告
class AdvertisingStartupModel {
  AdvertisingStartupModel({
    this.id,
    //	类型（1：启动页，2：轮播，3：弹窗）
    this.type,
    //轮播、弹窗位置（1：首页，2：）根据业务定义
    this.position,
    //自动关闭时间（秒）：启动页和弹窗有倒计时需要自动关闭
    this.closeSeconds,
    //	广告标题
    this.title,
    //广告图片
    this.image,
    //	广告视频（优先）
    this.video,
    //跳转类型：0无，1：H5跳转，2:内页跳转
    this.gotoType,
    //跳转url
    this.gotoUrl,
    //跳转参数Json（返给前端是Json格式）：内页需要
    this.gotoParam,
    //生效时间
    this.startTime,
    //失效时间
    this.endTime,});

  AdvertisingStartupModel.fromJson(dynamic json) {
    id = json['id'];
    type = json['type'];
    position = json['position'];
    closeSeconds = json['closeSeconds'];
    title = json['title'];
    image = json['image'];
    video = json['video'];
    gotoType = json['gotoType'];
    gotoUrl = json['gotoUrl'];
    gotoParam = json['gotoParam'];
    startTime = json['startTime'];
    endTime = json['endTime'];
  }
  int? id;
  int? type;
  int? position;
  int? closeSeconds;
  String? title;
  String? image;
  String? video;
  int? gotoType;
  String? gotoUrl;
  String? gotoParam;
  String? startTime;
  String? endTime;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['type'] = type;
    map['position'] = position;
    map['closeSeconds'] = closeSeconds;
    map['title'] = title;
    map['image'] = image;
    map['video'] = video;
    map['gotoType'] = gotoType;
    map['gotoUrl'] = gotoUrl;
    map['gotoParam'] = gotoParam;
    map['startTime'] = startTime;
    map['endTime'] = endTime;
    return map;
  }

}

///列表广告
class TBAdvertisingListModel {
  int advertType = 0; // 比赛列表广告位置0不区分 1关注 2全部 3进行中 4赛程 5赛果
  String advertId = ""; // 广告id
  String advertTitle = ""; // 广告标题或者描述
  String startTime = ""; // 生效时间
  String endTime = ""; // 失效时间
  int jumpType = 0; // 跳转类型0:站内跳转，1:站外跳转
  int sort = 0; // 排序（按大到小排序）
  int state = 0; //是否启用（0:启用，1关闭）
  int location = 0; //广告投放位置0:比赛列表，1:资讯列表，2：帖子列表，3:全部，4：资讯帖子列表，5：资讯比赛列表，6：帖子比赛列表
  String iconUrl1 = ""; // 图片URL1
  String iconUrl2 = ""; // 图片URL2
  String iconUrl3 = ""; // 图片URL3
  String jumpUrl = ""; // 跳转URL、站内跳转 （大模块，小模块）
  int hitsNumber = 0; //点击数
  String advertiser = ""; // 广告商名称
  String locationCode = ""; // 站内跳转编码
  String instation = ""; // 站内跳转位置
  bool outside = false; //是否站外打开
  bool activity = false; //是否是活动链接
  String type = ""; //7 我的-banner

  TBAdvertisingListModel({
    required this.advertType,
    required this.advertId,
    required this.advertTitle,
    required this.hitsNumber,
    required this.startTime,
    required this.endTime,
    required this.jumpType,
    required this.sort,
    required this.state,
    required this.location,
    required this.iconUrl1,
    required this.iconUrl2,
    required this.iconUrl3,
    required this.jumpUrl,
    required this.advertiser,
    required this.locationCode,
    required this.instation,
    required this.outside,
    required this.activity,
    required this.type,
  });

  TBAdvertisingListModel.fromJson(Map<String, dynamic> json)
      : advertType = json["advertType"] ?? 0,
        advertId = '${json["id"] ?? json["advertId"] ?? ""}',
        advertTitle = json["advertTitle"] ?? "",
        startTime = json["startTime"] ?? "",
        endTime = json["endTime"] ?? "",
        jumpType = json["jumpType"] ?? 0,
        sort = json["sort"] ?? 0,
        state = json["state"] ?? 0,
        hitsNumber = json["hitsNumber"] ?? 0,
        location = json["location"] ?? 0,
        iconUrl1 = json["iconUrl1"] ?? "",
        iconUrl2 = json["iconUrl2"] ?? "",
        iconUrl3 = json["iconUrl3"] ?? "",
        jumpUrl = json["jumpUrl"] ?? "",
        advertiser = json["advertiser"] ?? "",
        locationCode = json["locationCode"] ?? "",
        instation = json["instation"] ?? "",
        outside = json["outside"] ?? false,
        activity = json["activity"] ?? false,
        type = json["type"] ?? "";
}

///内页广告
class TBAdvertisingInnerModel {
  int advertType = 0; // 广告类型（0:图片，1:视频）
  String advertId = ""; // 广告id
  String advertTitle = ""; // 广告标题或者描述
  String startTime = ""; // 生效时间
  String endTime = ""; // 失效时间
  int jumpType = 0; // 跳转类型0:站内跳转，1:站外跳转
  int sort = 0; // 排序（按大到小排序）
  int state = 0; //是否启用（0:启用，1关闭）
  String locationType = ""; // 广告投放位置（1：比赛内页，2：比赛列表，3：资讯内页，4：帖子内页）
  String iconUrl = ""; // 图片URL
  String jumpUrl = ""; // 跳转URL、站内跳转 （大模块，小模块）
  int hitsNumber = 0; //点击数
  String advertiser = ""; // 广告商名称
  String locationCode = ""; // 站内跳转编码
  String instation = ""; // 站内跳转位置
  int matchLocation = 0; //比赛聊天室位置（1：顶部banner 2：侧边悬浮）
  bool outside = false; //是否站外打开
  bool activity = false; //是否是活动链接

  TBAdvertisingInnerModel({
    required this.advertType,
    required this.advertId,
    required this.advertTitle,
    required this.hitsNumber,
    required this.startTime,
    required this.endTime,
    required this.jumpType,
    required this.sort,
    required this.state,
    required this.locationType,
    required this.iconUrl,
    required this.jumpUrl,
    required this.advertiser,
    required this.locationCode,
    required this.instation,
    required this.matchLocation,
    required this.outside,
    required this.activity,
  });

  TBAdvertisingInnerModel.fromJson(Map<String, dynamic> json)
      : advertType = json["advertType"] ?? 0,
        advertId = '${json["id"] ?? json["advertId"] ?? ""}',
        advertTitle = json["advertTitle"] ?? "",
        startTime = json["startTime"] ?? "",
        endTime = json["endTime"] ?? "",
        jumpType = json["jumpType"] ?? 0,
        sort = json["sort"] ?? 0,
        state = json["state"] ?? 0,
        hitsNumber = json["hitsNumber"] ?? 0,
        locationType = json["locationType"] ?? "",
        iconUrl = json["iconUrl"] ?? "",
        jumpUrl = json["jumpUrl"] ?? "",
        advertiser = json["advertiser"] ?? "",
        locationCode = json["locationCode"] ?? "",
        instation = json["instation"] ?? "",
        matchLocation = json["matchLocation"] ?? 0,
        outside = json["outside"] ?? false,
        activity = json["activity"] ?? false;
}

///WebSocket 消息类型
enum TBWebSocketAction {

  ///初始化，服务端回包有足球篮球在线人数
  initialize(1),

  ///聊天室信息
  chatMessage(2),

  ///心跳
  heartbeat(4),

  ///足球-进入房间
  footballJoinRoom(5),

  ///足球-离开房间
  footballLeaveRoom(6),

  ///上报用户登录(App)
  authorized(7),

  ///上报用户退出登录(App)
  unauthorized(8),

  ///足球-数据更新
  footballData(9),

  /*
  {
  "code": 0,
  "action": 10,
  "data": [
    {
      "away1": 16,
      "away2": 23,
      "away3": 13,
      "awayScore": 52,
      "hasStats": 0,
      "home1": 18,
      "home2": 23,
      "home3": 9,
      "homeScore": 50,
      "matchId": 578383,
      "matchState": 3,
      "overtimeCount": 0,
      "remainTime": "03:42"
    }
  ]
}
   */
  ///篮球-数据更新
  basketballData(10),

  ///足球-重要事件
  footballImportantEvent(11),

  ///足球-危险进攻
  footballDangerousAttack(12),

  ///上报用户登录(Web)
  authorizedWeb(13),

  ///上报用户退出登录(Web)
  unauthorizedWeb(14),

  ///比赛-足球赔率指数，和footballRang的数据一样，而且footballRang数据更多
  basketballDishData(15),

  ///比赛-足球，和footballDaXiao的数据一样，而且footballDaXiao数据更多
  matchSixteen(16),
  ///比赛-篮球
  matchSeventeen(17),

  /*
  {
  "code": 0,
  "action": 18,
  "data": [
    {
      "id": 827613,
      "matchId": 578383,
      "companyId": 11,
      "firstDish": 153.5,
      "firstDishBig": 0.83,
      "firstDishSmall": 0.83,
      "forthDish": 153.5,
      "forthDishBig": 0.83,
      "forthDishSmall": 0.83,
      "runDish": 155.5,
      "runDishBig": 0.83,
      "runDishSmall": 0.83
    }
  ]
}
   */
  ///比赛-篮球
  matchEighteen(18),

  ///足球-技术统计
  footballTechnicalStatistics(19),

  ///足球-角球
  footballCornerKick(20),

  ///篮球-分差曲线
  basketballScoreSpread(21),

  ///篮球-技术统计
  basketballTechnicalStatistics(22),

  ///篮球-文字直播
  basketballTextLiving(23),

  ///篮球-进入房间
  basketballJoinRoom(24),

  ///篮球-离开房间
  basketballLeaveRoom(25),

  ///足球-观看人数更新
  footballOnline(26),

  ///篮球-观看人数更新
  basketballOnline(27),

  ///28 ai大数据
  bigdata(28),

  ///进入聊天室成功
  chatSuccess(30),

  ///支持率监听
  approvalRating(31),
  
  ///聊天室礼物信息
  chatGift(32),

  ///聊天室-温度计点击
  chatThermometer(33),

  ///聊天室-温度计初次查询
  chatThermometerInquire(34),

  ///用户模块相关信息推送 data：1.账户信息(昵称,头像,个人简介) 2.专家 3:实名认证 4:注销 5:金银币充值成功 6:会员开通成功 7:消息(系统公告，推荐，评论/@我的，赞) 8.禁言 (改action=29) 9.解禁 (改action=29) 10.取消点赞 11.购买粉丝群和提升粉丝群人数
  user(35),

  ///账号被踢下线
  kickOffline(36),

  ///ai轮播事件
  aiNotice(52),

  ///61 比赛视频直播链接禁用
  matchLive(61),

  /*
  {
  "code": 0,
  "action": 65,
  "data": [
    {
      "id": 2977686,
      "matchId": 2405759,
      "companyId": 3,
      "firstDish": 0.75,
      "firstDishHome": 0.85,
      "firstDishAway": 1.03,
      "forthDish": 0.75,
      "forthDishHome": 0.88,
      "forthDishAway": 1.01,
      "isMaintain": false,
      "isRun": true,
      "changeTime": "2024-04-19 16:45:33",
      "isClose": false,
      "oddType": 2
    }
  ]
}
   */
  ///足球-让球
  footballRang(65),

  /*
  {
  "code": 0,
  "action": 66,
  "data": [
    {
      "id": 3705908,
      "matchId": 2535218,
      "companyId": 3,
      "firstDish": 3.5,
      "firstDishBig": 0.83,
      "firstDishSmall": 0.97,
      "forthDish": 2.5,
      "forthDishBig": 0.82,
      "forthDishSmall": 0.98,
      "changeTime": "2024-04-19 16:45:46",
      "isClose": false,
      "oddType": 3
    }
  ]
}
   */
  ///足球-大小球
  footballDaXiao(66),

  /*
  {
  "code": 0,
  "action": 67,
  "data": [
    {
      "id": 850515,
      "matchId": 569175,
      "companyId": 3,
      "firstDish": 16.5,
      "firstDishHome": 0.8,
      "firstDishAway": 1.02,
      "forthDish": 14.5,
      "forthDishHome": 0.89,
      "forthDishAway": 0.87,
      "runDish": 30.5,
      "runDishHome": 0.88,
      "runDishAway": 0.88
    }
  ]
}
   */
  ///篮球-让分
  basketballRang(67),

  /*
  {
  "code": 0,
  "action": 68,
  "data": [
    {
      "id": 855570,
      "matchId": 569175,
      "companyId": 6,
      "firstDish": 175.5,
      "firstDishBig": 0.9,
      "firstDishSmall": 0.9,
      "forthDish": 178.0,
      "forthDishBig": 0.85,
      "forthDishSmall": 0.81,
      "runDish": 154.0,
      "runDishBig": 0.87,
      "runDishSmall": 0.79
    }
  ]
}
   */
  ///篮球-大小分
  basketballDaXiao(68),

  ///聊天室梗
  chatTerrier(74);

  final int value;
  const TBWebSocketAction(this.value);

  static TBWebSocketAction? tryParse(int value) {
    for(var item in TBWebSocketAction.values){
      if(item.value == value){
        return item;
      }
    }
    return null;
  }
}

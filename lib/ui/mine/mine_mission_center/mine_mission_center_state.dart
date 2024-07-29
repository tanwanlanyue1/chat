class MineMissionCenterState {
  List<MineEarnPointsItem> earnPointsItems = [
    MineEarnPointsItem(
      icon: "assets/images/mine/mine_gold32.png",
      title: "充值境修币",
      points: "+100",
    ),
    MineEarnPointsItem(
      icon: "assets/images/mine/mine_calendar.png",
      title: "每日签到",
      points: "+80",
      isFinish: true,
    ),
    MineEarnPointsItem(
      icon: "assets/images/mine/mine_chat.png",
      title: "聊天发言（0/5）",
      points: "+10",
    ),
    MineEarnPointsItem(
      icon: "assets/images/mine/mine_comment.png",
      title: "评论回帖（0/2）",
      points: "+1065",
    ),
    MineEarnPointsItem(
      icon: "assets/images/mine/mine_information.png",
      title: "阅读资讯（15分钟）",
      points: "+10",
    ),
  ];
}

class MineEarnPointsItem {
  String icon;
  String title;
  String points;
  bool isFinish;

  MineEarnPointsItem({
    required this.icon,
    required this.title,
    required this.points,
    this.isFinish = false,
  });
}

class PlazaState {
  List tabBarList = [
    {"name":"推荐"},
    {"name":"附近"},
    {"name":"社区"},
  ];
  //内容反馈
  List feedback = [
    {
      "icon":"assets/images/plaza/report.png",
      "name":"举报",
    },
    {
      "icon":"assets/images/plaza/lose_interest_in.png",
      "name":"不感兴趣",
    },
    {
      "icon":"assets/images/plaza/dislike.png",
      "name":"不喜欢作者",
    },
  ];
  //举报类型
  List reportTypeList = [
    "违反法、时政敏感",
    "未经许可的广告行为",
    "色情淫秽、血腥暴恐",
    "低俗谩骂、攻击引战",
    "造谣造假",
    "其他违反版规的恶意行为",
  ];
}

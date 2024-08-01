class IdentityProgressionState {

  //0审核中，1成功，2失败
  int audit = 0;
  //0:佳丽 1:客户，2:经纪人
  int current = 0;
  //权益
  List interests = [];
  //佳丽权益
  List jiaInterests = [
    {
      "title":"陪聊收益",
      "remake":"用户向您发起语音/视频聊天，可嫌取收益",
      "image":"assets/images/mine/chatting_service.png",
    },
    {
      "title":"约会收益",
      "remake":"用户与用户参与约会，赚取服务费收益",
      "image":"assets/images/mine/earnings.png",
    },
    {
      "title":"经纪团队",
      "remake":"加入专业的经纪团队，肤取更多约会机会",
      "image":"assets/images/mine/broker.png",
    },
  ];
  //经纪人权益
  List brokerInterests = [
    {
      "title":"指派分配",
      "remake":"用户下单，可指派分配至旗下的佳丽",
      "image":"assets/images/mine/allocation.png",
    },
    {
      "title":"团队收益",
      "remake":"参与旗下所有佳丽的约会收益分成",
      "image":"assets/images/mine/team.png",
    },
  ];
  //客户权益
  List clientInterests = [
    {
      "title":"约会邀约",
      "remake":"选择心仪的佳丽/经纪，并发起约会邀约",
      "image":"assets/images/mine/appointment.png",
    },
    {
      "title":"聊天交友",
      "remake":"寻找心动对象，愉快的聊天约会吧",
      "image":"assets/images/mine/making_friends.png",
    },
  ];
}

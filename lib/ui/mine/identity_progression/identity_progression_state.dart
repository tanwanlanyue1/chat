import 'package:guanjia/generated/l10n.dart';

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
      "title": S.current.chatRevenue,
      "remake": S.current.initiatingCoice,
      "image":"assets/images/mine/chatting_service.png",
    },
    {
      "title": S.current.datingIncome,
      "remake": S.current.goOnDate,
      "image":"assets/images/mine/earnings.png",
    },
    {
      "title": S.current.brokerageTeam,
      "remake": S.current.majorBrokerageTeam,
      "image":"assets/images/mine/broker.png",
    },
  ];
  //经纪人权益
  List brokerInterests = [
    {
      "title": S.current.assignment,
      "remake": S.current.userOrder,
      "image":"assets/images/mine/allocation.png",
    },
    {
      "title": S.current.teamRevenue,
      "remake": S.current.participationSharing,
      "image":"assets/images/mine/team.png",
    },
  ];
  //客户权益
  List clientInterests = [
    {
      "title": S.current.dateOffer,
      "remake": S.current.preference,
      "image":"assets/images/mine/appointment.png",
    },
    {
      "title": S.current.chatFriends,
      "remake": S.current.cardiacObject,
      "image":"assets/images/mine/making_friends.png",
    },
  ];
}

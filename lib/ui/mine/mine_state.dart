import 'package:get/get.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/generated/l10n.dart';

import '../../common/network/api/api.dart';

class MineState {

  // 客户-常用功能
  List<MineItemSource> commonFeature = [
    MineItemSource(
      type: MineItemType.accountData,
      title: S.current.personalInformation,
      icon: "assets/images/mine/personal_info.png",
    ),
    MineItemSource(
      type: MineItemType.evaluate,
      title: S.current.myWallet,
      icon: "assets/images/mine/wallet.png",
    ),
    MineItemSource(
      type: MineItemType.evaluate,
      title: S.current.myVIP,
      icon: "assets/images/mine/VIP.png",
    ),
    MineItemSource(
      type: MineItemType.evaluate,
      title: S.current.myAssessment,
      icon: "assets/images/mine/evaluate.png",
    ),
    MineItemSource(
      type: MineItemType.feedback,
      title: S.current.feedback,
      icon: "assets/images/mine/feedback.png",
    ),
    MineItemSource(
      type: MineItemType.setting,
      title: S.current.mySettings,
      icon: "assets/images/mine/setting.png",
    ),
    MineItemSource(
      type: MineItemType.activation,
      title: S.current.activationProgression,
      icon: "assets/images/mine/activate.png",
    ),
    //mineMessage
    MineItemSource(
      type: MineItemType.message,
      title: S.current.myMessage,
      icon: "assets/images/mine/message.png",
    ),
  ];
  // 佳丽-常用功能
  List<MineItemSource> jiaCommonFeature = [
    MineItemSource(
      type: MineItemType.evaluate,
      title: S.current.personalInformation,
      icon: "assets/images/mine/personal_info.png",
    ),
    MineItemSource(
      type: MineItemType.evaluate,
      title: S.current.myWallet,
      icon: "assets/images/mine/wallet.png",
    ),
    MineItemSource(
      type: MineItemType.evaluate,
      title: S.current.myVIP,
      icon: "assets/images/mine/VIP.png",
    ),
    MineItemSource(
      type: MineItemType.evaluate,
      title: S.current.myCustomer,
      icon: "assets/images/mine/mine_client.png",
    ),
    MineItemSource(
      type: MineItemType.feedback,
      title: S.current.feedback,
      icon: "assets/images/mine/feedback.png",
    ),
    MineItemSource(
      type: MineItemType.activation,
      title: S.current.cancelAdvanceToBroker,
      icon: "assets/images/mine/cancel_a_contract.png",
    ),
    MineItemSource(
      type: MineItemType.jiaEvaluate,
      title: S.current.appraiseMe,
      icon: "assets/images/mine/evaluate.png",
    ),
    MineItemSource(
      type: MineItemType.haveSeen,
      title: S.current.whoSeenMe,
      icon: "assets/images/mine/examine.png",
    ),
    MineItemSource(
      type: MineItemType.setting,
      title: S.current.mySettings,
      icon: "assets/images/mine/setting.png",
    ),
    MineItemSource(
      type: MineItemType.serviceCharge,
      title: S.current.modificationServiceCharge,
      icon: "assets/images/mine/modification_service.png",
    ),
    MineItemSource(
      type: MineItemType.contractDetail,
      title: S.current.contractDetail,
      icon: "assets/images/mine/look_contract.png",
    ),
    MineItemSource(
      type: MineItemType.contractSign,
      title: S.current.contractSign,
      icon: "assets/images/mine/look_contract.png",
    ),
    MineItemSource(
      type: MineItemType.generateContract,
      title: S.current.generateContract,
      icon: "assets/images/mine/look_contract.png",
    ),
    MineItemSource(
      type: MineItemType.contractList,
      title: S.current.contractList,
      icon: "assets/images/mine/look_contract.png",
    ),
  ];

  //经纪人-常用功能
  List<MineItemSource> brokerCommonFeature = [
    MineItemSource(
      type: MineItemType.evaluate,
      title: S.current.personalInformation,
      icon: "assets/images/mine/personal_info.png",
    ),
    MineItemSource(
      type: MineItemType.evaluate,
      title: S.current.myWallet,
      icon: "assets/images/mine/wallet.png",
    ),
    MineItemSource(
      type: MineItemType.evaluate,
      title: S.current.myVIP,
      icon: "assets/images/mine/VIP.png",
    ),
    MineItemSource(
      type: MineItemType.teamEvaluation,
      title: S.current.teamEvaluation,
      icon: "assets/images/mine/evaluate.png",
    ),
    MineItemSource(
      type: MineItemType.feedback,
      title: S.current.feedback,
      icon: "assets/images/mine/feedback.png",
    ),
    MineItemSource(
      type: MineItemType.myTeam,
      title: S.current.myTeam,
      icon: "assets/images/mine/my_team.png",
    ),
    MineItemSource(
      type: MineItemType.activation,
      title: S.current.activationProgression,
      icon: "assets/images/mine/cancel_a_contract.png",
    ),
    MineItemSource(
      type: MineItemType.setting,
      title: S.current.mySettings,
      icon: "assets/images/mine/setting.png",
    ),
    MineItemSource(
      type: MineItemType.generateContract,
      title: S.current.generateContract,
      icon: "assets/images/mine/look_contract.png",
    ),
  ];
  //0:客户，1:佳丽
  final current = 0.obs;
}

enum MineItemType {
  accountData, // 个人信息
  evaluate, // 我的评价
  message, // 消息
  feedback, // 问题反馈
  setting, // 设置
  jiaEvaluate, // 佳丽-评价我的
  haveSeen, // 佳丽-谁看过我
  help, // 客服与帮助
  attentionOrFans, // 关注或粉丝
  activation, //激活
  contractDetail, //查看契约单-签约
  contractSign, //查看契约单-解约
  generateContract, //生成契约单
  contractList, //契约单列表
  serviceCharge, //服务费
  teamEvaluation, //经纪人-团队评价
  myTeam, //经纪人-我的团队
}

class MineItemSource {
  MineItemSource({
    required this.type,
    this.title,
    this.icon,
    this.number,
  });

  MineItemType type;
  String? title;
  String? icon;
  int? number;
}

import 'package:get/get.dart';
import 'package:guanjia/common/service/service.dart';

import '../../common/network/api/api.dart';

class MineState {

  // 常用功能
  List<MineItemSource> commonFeature = [
    MineItemSource(
      type: MineItemType.myQuestionsAndAnswers,
      title: "个人信息",
      icon: "assets/images/mine/personal_info.png",
    ),
    MineItemSource(
      type: MineItemType.collection,
      title: "我的钱包",
      icon: "assets/images/mine/wallet.png",
    ),
    MineItemSource(
      type: MineItemType.browsingHistory,
      title: "我的VIP",
      icon: "assets/images/mine/VIP.png",
    ),
    MineItemSource(
      type: MineItemType.evaluate,
      title: "我的评价",
      icon: "assets/images/mine/evaluate.png",
    ),
    MineItemSource(
      type: MineItemType.feedback,
      title: "意见反馈",
      icon: "assets/images/mine/feedback.png",
    ),
    MineItemSource(
      type: MineItemType.setting,
      title: "我的设置",
      icon: "assets/images/mine/setting.png",
    ),
    MineItemSource(
      type: MineItemType.help,
      title: "激活/进阶",
      icon: "assets/images/mine/activate.png",
    ),
    // MineItemSource(
    //   type: MineItemType.message,
    //   title: "我的客户",
    //   icon: "assets/images/mine/information.png",
    //   number: 0,
    // ),
    MineItemSource(
      type: MineItemType.setting,
      title: "我的关注",
      icon: "assets/images/mine/attention.png",
    ),
    MineItemSource(
      type: MineItemType.setting,
      title: "我的消息",
      icon: "assets/images/mine/message.png",
    ),
  ];

}

enum MineItemType {
  homework, // 禅房功课
  disabuse, // 解惑
  invitation, // 邀请有奖
  ranking, // 修行排行
  myCreation, // 我的创作
  collection, // 收藏
  browsingHistory, // 浏览记录
  evaluate, // 我的评价
  myQuestionsAndAnswers, // 我的问答
  message, // 消息
  myArchive, // 我的档案
  myAttention, // 我的关注
  feedback, // 问题反馈
  setting, // 设置
  help, // 客服与帮助
  attentionOrFans, // 关注或粉丝
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

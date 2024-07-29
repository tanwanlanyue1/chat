import 'package:get/get.dart';
import 'package:guanjia/common/service/service.dart';

import '../../common/network/api/api.dart';

class MineState {
  // 修行之路
  List<MineItemSource> get discipline{
    final config = SS.appConfig.configRx();
    return [
      MineItemSource(
        type: MineItemType.homework,
        title: "禅房功课",
        icon: "assets/images/mine/buddhist.png",
      ),
      MineItemSource(
        type: MineItemType.disabuse,
        title: "解疑",
        icon: "assets/images/mine/disabuse.png",
      ),
      MineItemSource(
        type: MineItemType.ranking,
        title: "修行排行",
        icon: "assets/images/mine/practice.png",
      ),
      if(config != null && (config.jumpLink?.isNotEmpty ?? false)) MineItemSource(
        type: MineItemType.invitation,
        title: "渡人修己",
        icon: "assets/images/mine/invite.png",
      ),
    ];
  }


  // 常用功能
  List<MineItemSource> commonFeature = [
    // MineItemSource(
    //   type: MineItemType.myCreation,
    //   title: "我的创作",
    //   icon: "assets/images/mine/creation.png",
    // ),
    MineItemSource(
      type: MineItemType.myQuestionsAndAnswers,
      title: "我的问答",
      icon: "assets/images/mine/answer.png",
    ),
    MineItemSource(
      type: MineItemType.collection,
      title: "我的收藏",
      icon: "assets/images/mine/enshrine.png",
    ),
    MineItemSource(
      type: MineItemType.browsingHistory,
      title: "浏览记录",
      icon: "assets/images/mine/browse.png",
    ),
    MineItemSource(
      type: MineItemType.message,
      title: "消息",
      icon: "assets/images/mine/information.png",
      number: 0,
    ),
    // MineItemSource(
    //   type: MineItemType.myArchive,
    //   title: "我的档案",
    //   icon: "assets/images/mine/record.png",
    // ),
    MineItemSource(
      type: MineItemType.attentionOrFans,
      title: "粉丝与关注",
      icon: "assets/images/mine/follow.png",
    ),
    MineItemSource(
      type: MineItemType.feedback,
      title: "问题反馈",
      icon: "assets/images/mine/feedback.png",
    ),
    MineItemSource(
      type: MineItemType.setting,
      title: "设置",
      icon: "assets/images/mine/setting.png",
    ),
    MineItemSource(
      type: MineItemType.help,
      title: "客服与帮助",
      icon: "assets/images/mine/customer_service.png",
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

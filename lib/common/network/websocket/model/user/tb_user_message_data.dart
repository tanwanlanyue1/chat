import 'package:collection/collection.dart';

///用户消息推送数据
enum TBUserMessageData{

  ///35 -> 1 账户信息(昵称,头像,个人简介)
  userProfile(1),

  ///35 -> 2 专家审核通过
  expert(2),

  ///35 -> 3 实名认证
  realNameAuthentication(3),

  ///35 -> 4 注销
  accountCancellation(4),

  ///35 -> 5 金银币充值成功
  rechargeTradeSuccess(5),

  ///35 -> 6 会员开通成功
  vipTradeSuccess(6),

  ///35 -> 7 站内消息(系统公告，推荐，评论/@我的，赞)
  inAppMessage(7),

  ///35 -> 10 取消点赞
  unlike(10),

  ///35 -> 11 粉丝群购买或提升人数支付成功
  fansGroupTradeSuccess(11);

  final int value;
  const TBUserMessageData(this.value);

  static TBUserMessageData? tryParse(int value){
    return TBUserMessageData.values.firstWhereOrNull((element) => element.value == value);
  }
}

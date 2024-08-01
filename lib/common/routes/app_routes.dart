part of 'app_pages.dart';

/// 路由路径，当需要加入登录校验时，路径前加入 auth 字段
/// 例如：static const mineRecordPage = '$auth/mineRecordPage';
abstract class AppRoutes {
  AppRoutes._();

  ///登录校验
  static const auth = "/auth";

  ///主页
  static const home = '/home';

  static const welcome = '/welcome';

  ///发布动态
  static const releaseDynamicPage = '/releaseDynamicPage';

  ///我的档案
  static const mineRecordPage = '$auth/mineRecordPage';

  ///档案详情
  static const recordDetailsPage = '/recordDetailsPage';

  ///分类广场/话题广场
  static const classificationSquarePage = '/classificationSquarePage';

  ///广场-用户中心
  static const userCenterPage = '$auth/userCenterPage';

  ///广场详情页
  static const plazaDetailPage = '/plazaDetailPage';

  ///广场-历史浏览
  static const plazaHistoryPage = '$auth/plazaHistoryPage';

  ///我的设置
  static const mineSettingPage = '/mineSettingPage';

  ///账户资料
  static const accountDataPage = '$auth/accountDataPage';

  ///更改信息页
  static const updateInfoPage = '/updateInfoPage';

  ///设置-账号安全
  static const accountSafetyPage = '$auth/accountSafetyPage';

  ///设置-绑定手机号码
  static const bindingPage = '/BindingPage';

  ///我的-评价
  static const mineEvaluatePage = '/mineEvaluatePage';

  ///佳丽-评价我的
  static const jiaEvaluatePage = '/jiaEvaluatePage';

  ///设置-修改登录密码
  static const updatePasswordPage = '/updatePasswordPage';

  ///设置-支付密码
  static const paymentPasswordPage = '/paymentPasswordPage';

  ///设置-账户黑名单
  static const accountBlacklistPage = '/accountBlacklistPage';

  ///设置-关于我们
  static const aboutPage = '/aboutPage';

  ///设置-权限设置
  static const permissions = '/permissions';

  /// 消息-设置
  static const messageSettingPage = '/messageSettingPage';

  /// WebView页面
  static const webPage = '/webPage';

  /// 我的-关注
  static const mineAttentionPage = '$auth/mineAttentionPage';

  /// 我的-关注或粉丝
  static const attentionOrFansPage = '$auth/attentionOrFansPage';

  /// 我的-意见反馈
  static const mineFeedbackPage = '/mineFeedbackPage';

  /// 我的-帮助与客服
  static const mineHelpPage = '$auth/mineHelpPage';

  /// 我的-消息
  static const mineMessage = '$auth/mineMessage';

  /// 消息-会话
  static const messageSessionPage = '/messageSessionPage';

  /// 消息-通知
  static const messageNotice = '/messageNotice';

  /// 我的-粉丝
  static const mineFans = '/mineFans';

  /// 我的-评论
  static const mineComment = '/mineComment';

  /// 我的-赞
  static const minePraise = '$auth/minePraise';

  /// 我的-内购
  static const minePurchase = '$auth/minePurchase';

  /// 我的-境修币明细
  static const mineGoldDetail = '$auth/mineGoldDetail';

  /// 我的-任务中心
  static const mineMissionCenter = '$auth/mineMissionCenter';

  /// 我的-收藏
  static const mineCollectPage = '$auth/mineCollectPage';

  /// 我的-任务中心-积分
  static const mineRewardPoints = '$auth/mineRewardPoints';

  /// 我的-任务中心-积分-积分明细
  static const mineRewardPointsDetail = '$auth/mineRewardPointsDetail';

  /// 登录
  static const loginPage = '/loginPage';

  /// 注册
  static const loginRegisterPage = '/loginRegisterPage';

  /// 忘记密码
  static const loginForgotPage = '/loginForgotPage';

  /// 登录-绑定手机
  static const loginPhoneBindingPage = '/loginPhoneBinding';

  /// 登录-问题
  static const loginQuestionPage = '/loginQuestionPage';

  /// 心愿阁-禅房
  static const zenRoomPage = '/zenRoomPage';

  /// 心愿阁-思亲河
  static const homesickRiverPage = '/homesickRiverPage';

  /// 心愿阁-思亲河
  static const homesickMine = '$auth/homesickMine';

  /// 心愿阁-许愿天灯
  static const votiveSkyLanternPage = '$auth/votiveSkyLanternPage';

  /// 心愿阁-供灯祈福
  static const lightsPrayPage = '/lightsPrayPage';

  /// 心愿阁-供灯祈福-请灯
  static const lightsPrayInvitationPage = '/lightsPrayInvitationPage';

  /// 心愿阁-请符法坛
  static const charmPage = '/charmPage';

  /// 心愿阁-请符法坛-灵符壁纸
  static const charmBackgroundPage = '/charmBackgroundPage';

  /// 心愿阁-请符法坛-我的
  static const myCharmPage = '$auth/myCharmPage';

  /// 禅房 - 恭请佛像
  static const qingFoPage = '$auth/qingFoPage';

  /// 禅房 - 木鱼设置
  static const woodenFishSettingPage = '$auth/woodenFishSettingPage';

  /// 禅房 - 念珠背景设置
  static const rosaryBeadsBackgroundSettingPage =
      '$auth/rosaryBeadsBackgroundSettingPage';

  /// 禅房 - 经书大全
  static const buddhistSutrasListPage = '$auth/buddhistSutrasListPage';

  /// 禅房 - 经书列表
  static const allSutrasPage = '$auth/allSutrasPage';

  /// 禅房(我的) - 修行详情
  static const practiceDetailPage = '$auth/practiceDetailPage';

  /// 修行详情 - 上香顶礼详情
  static const offerIncenseDetailPage = '$auth/offerIncenseDetailPage';

  /// 修行详情 - 供品顶礼详情
  static const tributeDetailPage = '$auth/tributeDetailPage';

  /// 修行详情 - 木鱼诵经详情
  static const woodenFishDetailPage = '$auth/woodenFishDetailPage';

  /// 修行详情 - 念珠详情
  static const rosaryBeadsDetailPage = '$auth/rosaryBeadsDetailPage';

  /// 修行排行榜
  static const meritListPage = '$auth/meritListPage';

  /// 功德
  static const mineMeritVirtuePage = '$auth/auth/mineMeritVirtuePage';

  /// 修行之路
  static const minePracticePage = '$auth/minePracticePage';

  /// 诵经播放器-全屏视图
  static const chantSutrasPlayerPage = '$auth/chantSutrasPlayerPage';

  ///开屏广告
  static const launchAd = '/launchAd';

  ///生成契约单
  static const contractGeneratePage = '/ContractGeneratePage';

  ///契约单详情
  static const contractDetailPage = '/ContractDetailPage';

  ///契约单列表
  static const contractListPage = '/ContractListPage';
}

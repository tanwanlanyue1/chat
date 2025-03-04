part of 'app_pages.dart';

/// 路由路径，当需要加入登录校验时，路径前加入 auth 字段
/// 例如：static const mineRecordPage = '$auth/mineRecordPage';
abstract class AppRoutes {
  AppRoutes._();

  ///登录校验
  static const auth = "/auth";

  ///主页
  static const home = '$auth/home';

  static const welcome = '/welcome';

  ///发布动态
  static const releaseDynamicPage = '$auth/releaseDynamicPage';

  ///发布私房照
  static const releaseMediaPage = '$auth/ReleaseMediaPage';

  ///分类广场/话题广场
  static const classificationSquarePage = '$auth/classificationSquarePage';

  ///广场-用户中心
  static const userCenterPage = '$auth/userCenterPage';

  ///广场-速配
  static const speedDatingPage = '$auth/speedDatingPage';

  ///全部评论
  static const allCommentsPage = '$auth/allCommentsPage';

  ///我的设置
  static const mineSettingPage = '$auth/mineSettingPage';

  ///个人信息
  static const accountDataPage = '$auth/accountDataPage';

  ///选择地区
  static const chooseAreaPage = '$auth/chooseAreaPage';

  ///更改信息页
  static const updateInfoPage = '$auth/updateInfoPage';

  ///设置-账号安全
  static const accountSafetyPage = '$auth/accountSafetyPage';

  ///设置-绑定手机号码
  static const bindingPage = '$auth/BindingPage';

  ///我的-评价
  static const mineEvaluatePage = '$auth/mineEvaluatePage';

  ///佳丽-评价我的
  static const jiaEvaluatePage = '$auth/jiaEvaluatePage';

  ///设置-修改登录密码
  static const updatePasswordPage = '/updatePasswordPage';

  ///设置-支付密码
  static const paymentPasswordPage = '$auth/paymentPasswordPage';

  ///设置-身份进阶
  static const identityProgressionPage = '$auth/identityProgressionPage';

  ///我的-谁看过我
  static const haveSeenPage = '$auth/haveSeenPage';

  ///我的-修改服务费
  static const mineServiceChargePage = '$auth/mineServiceChargePage';

  ///我的-经纪人-团队评价
  static const mineTeamEvaluatePage = '$auth/mineTeamEvaluatePage';

  ///我的-经纪人-我的团队
  static const mineMyTeamPage = '$auth/mineMyTeamPage';

  ///设置-关于我们
  static const aboutPage = '$auth/aboutPage';

  ///设置-权限设置
  static const permissions = '$auth/permissions';

  /// 消息-设置
  static const messageSettingPage = '$auth/messageSettingPage';

  /// WebView页面
  static const webPage = '/webPage';

  /// 我的-意见反馈
  static const mineFeedbackPage = '/mineFeedbackPage';

  /// 佳丽-我的客户
  static const mineClient = '$auth/mineClient';

  /// 我的-消息
  static const mineMessage = '$auth/mineMessage';

  /// 消息-会话
  static const messageSessionPage = '$auth/messageSessionPage';

  /// 消息-通知
  static const messageNotice = '$auth/messageNotice';

  /// 我的-内购
  static const minePurchase = '$auth/minePurchase';

  /// 我的-境修币明细
  static const mineGoldDetail = '$auth/mineGoldDetail';

  /// 登录
  static const loginPage = '/loginPage';

  /// 注册
  static const loginRegisterPage = '/loginRegisterPage';

  /// 忘记密码
  static const loginForgotPage = '/loginForgotPage';

  /// 登录-绑定手机
  static const loginPhoneBindingPage = '$auth/loginPhoneBinding';

  /// 登录-问题
  static const loginQuestionPage = '$auth/loginQuestionPage';

  ///开屏广告
  static const launchAd = '/launchAd';

  ///生成契约单
  static const contractGeneratePage = '$auth/ContractGeneratePage';

  ///契约单详情
  static const contractDetailPage = '$auth/ContractDetailPage';

  ///契约单列表
  static const contractListPage = '$auth/ContractListPage';

  ///发现-发布邀约
  static const releaseInvitation = '$auth/releaseInvitation';

  /// 个人头像
  static const avatarPage = '$auth/avatarPage';

  /// 我的Vip
  static const myVipPage = '$auth/myVipPage';

  /// 选择位置
  static const choosePlacePage = '$auth/ChoosePlacePage';

  /// 大厅-选择位置
  static const mapPage = '$auth/MapPage';

  /// 显示位置消息
  static const displayLocationPage = '$auth/displayLocationPage';

  /// 钱包
  static const walletPage = '$auth/walletPage';

  /// 充值订单详情
  static const rechargeOrderPage = '$auth/RechargeOrderPage';

  /// 充值，提现订单列表
  static const walletOrderListPage = '$auth/WalletOrderListPage';

  /// 充值
  static const walletRechargePage = '$auth/WalletRechargePage';

  /// 订单
  static const orderPage = '$auth/orderPage';

  /// 订单 - 详情
  static const orderDetailPage = '$auth/orderDetailPage';

  /// 订单 - 评价
  static const orderEvaluationPage = '$auth/orderEvaluationPage';

  /// 订单 - 支付订单
  static const orderPaymentPage = '$auth/orderPaymentPage';

  /// 订单 - 支付订单结果
  static const orderPaymentResultPage = '$auth/orderPaymentResultPage';


  ///1V1聊天消息列表页
  static const messageListPage = '$auth/MessageListPage';

  ///发红包
  static const redPacketPage = '$auth/RedPacketPage';

  ///转账
  static const transferMoneyPage = '$auth/TransferMoneyPage';

  ///私人照详情
  static const privatePhotoDetail = '$auth/privatePhotoDetailPage';
}

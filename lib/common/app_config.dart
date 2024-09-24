
import 'package:guanjia/common/network/config/server_config.dart';
import 'package:guanjia/generated/l10n.dart';

/// 应用全局配置
class AppConfig{
  const AppConfig._();

  ///开发环境接口地址
  static const urlDevServer = 'http://newchat.happysport-666.cn/app';
  // static const urlDevServer = 'http://192.168.2.79:20000';
  // 外网ip http://112.94.4.229:20000

  ///正式环境接口地址
  static const urlProdServer = 'https://jxapi.amiyosz.com';

  static String get urlServer => ServerConfig.instance.getDefaultServer().api.toString();

  ///隐私政策
  static String get urlPrivacyPolicy => '$urlServer/static/gj_privacy.html';

  ///用户服务协议
  static String get urlUserService => '$urlServer/static/gj_service.html';

  ///用户充值服务协议
  static const urlRechargeService = 'http://jxapp.amiyosz.com/protocol/jx_recharge.html';

  ///客服与帮助
  static const urlHelp = 'http://jxapp.amiyosz.com/protocol/jx_help.html';

  ///APP下载页
  static String get urlAppDownload => '$urlServer/static/gj_app_download.html';

  ///账号注销
  static String get urlAccountCancellation => '$urlServer/static/gj_account_cancellation.html';

  ///iOS通用链接
  static const iosUniversalLink = 'https://jxapi.amiyosz.com/app/';


  ///ZEGO即时通讯
  static const zegoAppId = 1161912283;
  static const zegoAppSign = 'bb69e72800b6de21038b9e1a9044e229ee48d79b89c7ef2961e5175c6ccc934d';
  static const zegoChatResourceId = 'guanjia_chat';
  static const zegoCallResourceId = 'guanjia_call';

  //后台管理 https://www.google.com/recaptcha/admin/site/708806082?hl=zh-cn
  static const recaptchaApiKey = '6LfChT8qAAAAACW9sgMYpQNJLF9Mx-jL8iRofe-N';

  ///ICP备案号
  static String icp = S.current.guangdongICP;
  static const urlIcp = 'https://beian.miit.gov.cn';

  ///平台系统用户ID
  static const sysUserId = '99999';

  ///红包最大金额
  static const redPacketMaxAmount = 200.0;

  ///红包描述文字个数
  static const redPacketDescLimit = 10;

  ///转账最大金额
  static const transferMaxAmount = 99999999.0;

  ///金额小数位精度
  static const decimalDigits = 2;

}
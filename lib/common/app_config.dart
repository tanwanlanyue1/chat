
import 'package:guanjia/generated/l10n.dart';

/// 应用全局配置
class AppConfig{
  const AppConfig._();

  ///开发环境接口地址
  // static const urlDevServer = 'https://jingxiu-api.happysport-666.cn';
  static const urlDevServer = 'http://192.168.2.17:20000';

  ///正式环境接口地址
  static const urlProdServer = 'https://jxapi.amiyosz.com';

  ///隐私政策
  static const urlPrivacyPolicy = 'http://jxapp.amiyosz.com/protocol/jx_privacy.html';

  ///用户服务协议
  static const urlUserService = 'http://jxapp.amiyosz.com/protocol/jx_service.html';

  ///用户充值服务协议
  static const urlRechargeService = 'http://jxapp.amiyosz.com/protocol/jx_recharge.html';

  ///客服与帮助
  static const urlHelp = 'http://jxapp.amiyosz.com/protocol/jx_help.html';

  ///禅房念珠
  static const urlRosaryBeads = 'http://jxapp.amiyosz.com/protocol/jx_rosary_beads.html';

  ///APP下载页
  static const urlAppDownload = 'http://jxapp.amiyosz.com/protocol/jx_app_download.html';

  ///账号注销
  static const urlAccountCancellation = 'http://jxapp.amiyosz.com/protocol/jx_account_cancellation.html';

  ///iOS通用链接
  static const iosUniversalLink = 'https://jxapi.amiyosz.com/app/';


  ///ZEGO即时通讯
  static const zegoAppId = 1161912283;
  static const zegoAppSign = 'bb69e72800b6de21038b9e1a9044e229ee48d79b89c7ef2961e5175c6ccc934d';

  ///ICP备案号
  static String icp = S.current.guangdongICP;
  static const urlIcp = 'https://beian.miit.gov.cn';

  ///红包最大金额
  static const redPacketMaxAmount = 200.0;

  ///红包描述文字个数
  static const redPacketDescLimit = 10;

  ///转账最大金额
  static const transferMaxAmount = 99999999.0;

  ///金额小数位精度
  static const decimalDigits = 2;

}
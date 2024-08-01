
import 'package:guanjia/generated/l10n.dart';

/// 应用全局配置
class AppConfig{
  const AppConfig._();

  ///开发环境接口地址
  static const urlDevServer = 'https://jingxiu-api.happysport-666.cn';

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

  ///微信APPID
  static const wechatAppId = 'wx11c2ff36e713482b';

  ///iOS通用链接
  static const iosUniversalLink = 'https://jxapi.amiyosz.com/app/';

  ///阿里云一键登录android sk
  static const aliyunAndroidSk =
      'EaM823L7VdGtWlQOjILwywhMsqGhn2oezdGwX0TyJI/HjPNs++hi8om/W0thjcFeF+Y8bXdKpfhBgr4B6d1G6ljAKCXZk/PCAMQwKtMPV6pRG8iFTkDjXc9bPZ7V1YZMG6LAxq3VkvB0O5UpJpi/tBFbNf8qiTCCGc1hmU6DkHsgGPq2VHb5gir6DgYi0IVPAT50xooXs1aza5LaHEFr7I3ZwFZfyThMeT0TFjd+DwiPT3/YVVx7GVd/44raPQQNsmOxHzYfdahyNauX92Anrn7MzHYdU2u073SXVW1LArLgOlIix+gEvg==';

  ///阿里云一键登录ios sk
  static const aliyunIOSSk = 'qojyNaTLClSCQA4hVGVDpXrB+2DZWmG0LCchGpfwuHuXC3a59YIN+E+LcdyKYmshp9UNZqSysQf8yert3hGmfBX8l+OPvPdeZQSzURJJLwKZSe3eosc5CG/PUdV30kZmZEkxjuRK9Ph5sUBx12n0JLLBGmoDQXpdBOd/q2eScDfe9Ylu39QJgw+sts7c2fV0d+7pUWpj93g96qZ3BWrk7x15ZTnQVG5/EasDUPoBocQTWf5eRsvf1FH0K/Syt/rRwyi3B8oJyzQ=';

  ///支付小程序username
  static const miniProgramUsername = 'gh_6a8ecfe871b0';

  ///个推Key
  static const geTuiAppId = 'ik4JEL2FzA6x8FmIVoCsv3';
  static const geTuiAppKey = 'k7sB2Jj5nC6tmuCSuu5388';
  static const geTuiAppSecret = 'CTr3H3SVL26JjUGgJXURo';
  // static const geTuiMasterSecret = '9tu39eC5w97f8SmRtEOaD1';

  ///ICP备案号
  static String icp = S.current.guangdongICP;
  static const urlIcp = 'https://beian.miit.gov.cn';

}
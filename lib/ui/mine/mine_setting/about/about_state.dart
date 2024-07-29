import 'package:get/get.dart';
import 'package:guanjia/common/app_config.dart';

class AboutState {

  final version = "".obs;

  final appName = "".obs;

  ///协议列表
  List agreementList = [
    {
      "title":"隐私服务",
      "url": AppConfig.urlPrivacyPolicy,
    },
    {
      "title":"服务协议",
      "url": AppConfig.urlUserService,
    },
    {
      "title":"充值服务协议",
      "url": AppConfig.urlRechargeService,
    },
    {
      "title":"检测新版本",
      "url": '',
    },
  ];
}

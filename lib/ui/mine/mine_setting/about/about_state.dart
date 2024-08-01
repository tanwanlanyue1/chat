import 'package:get/get.dart';
import 'package:guanjia/common/app_config.dart';
import 'package:guanjia/generated/l10n.dart';

class AboutState {

  final version = "".obs;

  final appName = "".obs;

  ///协议列表
  List agreementList = [
    {
      "title": S.current.privacyService,
      "url": AppConfig.urlPrivacyPolicy,
    },
    {
      "title": S.current.serviceAgreement,
      "url": AppConfig.urlUserService,
    },
    {
      "title":S.current.rechargeService,
      "url": AppConfig.urlRechargeService,
    },
    {
      "title": S.current.detectNewVersions,
      "url": '',
    },
  ];
}

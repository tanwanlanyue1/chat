import 'package:get/get.dart';
import 'package:guanjia/common/app_config.dart';
import 'package:guanjia/common/network/api/api.dart';

///App全局配置服务
class AppConfigService extends GetxService {
  final configRx = Rxn<AppConfigModel>();

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  ///使用的货币单位
  String get currencyUnit{
    return '\$';
  }

  ///红包最大金额
  num get redPacketMaxAmount{
    return configRx()?.redPacketMaxAmount ?? AppConfig.redPacketMaxAmount;
  }

  ///转账最大金额
  num get transferMaxAmount{
    return configRx()?.transferMaxAmount ?? AppConfig.transferMaxAmount;
  }

  Future<void> fetchData() async {
    final response = await OpenApi.getAppConfig();
    if (response.isSuccess) {
      configRx.value = response.data;
    }

    final labelRes = await OpenApi.getStyleList();
    if (labelRes.isSuccess) {
      configRx.update((val) {
        val?.labels = labelRes.data;
      });
    }

    final messageRes = await UserApi.getMessagesCounts();
    if (messageRes.isSuccess) {
      for(var i = 0; i < messageRes.data.length; i++){
        if(messageRes.data[i]['type'] == 0){
          configRx()?.systemMessage = true;
        }
        if(messageRes.data[i]['type'] == 6){
          configRx()?.lookMessage = true;
        }
      }
    }
  }
}

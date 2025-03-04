import 'package:get/get.dart';
import 'package:guanjia/common/app_config.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/network/api/model/user/vip_model.dart';
import 'package:guanjia/common/network/httpclient/api_response.dart';
import 'package:guanjia/common/utils/local_storage.dart';
import 'package:guanjia/widgets/loading.dart';

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

  ///vip套餐
  VipModel? get vipInfo{
    if(configRx.value?.vipInfo == null){
      Loading.show();
      getVip().then((value) => {
          if (value.isSuccess) {
              configRx.update((val) {
            val?.vipInfo = value.data;
          })
        },
      }).whenComplete(() => Loading.dismiss());
    }
    return configRx.value?.vipInfo;
  }

  ///红包最大金额
  num get redPacketMaxAmount{
    return configRx()?.redPacketMaxAmount ?? AppConfig.redPacketMaxAmount;
  }
  ///红包描述文字个数
  int get redPacketDescLimit{
    return configRx()?.redPacketDescLimit ?? AppConfig.redPacketDescLimit;
  }

  ///转账最大金额
  num get transferMaxAmount{
    return configRx()?.transferMaxAmount ?? AppConfig.transferMaxAmount;
  }

  ///金额小数位精度
  int get decimalDigits{
    return configRx()?.decimalDigits ?? AppConfig.decimalDigits;
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

    final vipRes = await getVip();
    if (vipRes.isSuccess) {
      configRx.update((val) {
        val?.vipInfo = vipRes.data;
      });
    }
  }

  Future<ApiResponse<VipModel>> getVip(){
    return VipApi.getVipIndex();
  }

}

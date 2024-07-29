import 'package:get/get.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/service/service.dart';

///App全局配置服务
class AppConfigService extends GetxService {
  final configRx = Rxn<AppConfigModel>();

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await OpenApi.getAppConfig();
    if(response.isSuccess){
      configRx.value = response.data;
    }
  }
}

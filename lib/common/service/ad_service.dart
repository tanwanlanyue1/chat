import 'package:get/get.dart';
import 'package:guanjia/common/network/api/model/open/advert_model.dart';
import 'package:guanjia/common/network/api/open_api.dart';

///广告服务
class ADService extends GetxService {

  ///banner广告图Map<position,List<AdvertisingStartupModel>>
  final bannerMapRx = <int?, List<AdvertisingStartupModel>>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  void fetchData() async {
    final response = await OpenApi.startupAdvertList(type: 2);
    if (response.isSuccess) {
      final map = <int?, List<AdvertisingStartupModel>>{};
      response.data?.forEach((element) {
        map
            .putIfAbsent(element.position, () => <AdvertisingStartupModel>[])
            .add(element);
      });
      if(map.isNotEmpty){
        bannerMapRx..clear()..addAll(map);
      }
    }
  }
}

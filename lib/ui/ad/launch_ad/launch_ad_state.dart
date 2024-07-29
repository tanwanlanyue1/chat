import 'package:get/get.dart';
import 'package:guanjia/ui/ad/ad_manager.dart';

class LaunchAdState {
  final ad = ADManager.instance.getLaunchAd();
  final adFile = ADManager.instance.getLaunchAdFile();
  final secondsRx = 5.obs;
}

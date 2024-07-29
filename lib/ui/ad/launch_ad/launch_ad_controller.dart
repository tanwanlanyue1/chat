import 'dart:async';
import 'dart:math';

import 'package:get/get.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/ui/ad/ad_manager.dart';

import 'launch_ad_state.dart';

class LaunchAdController extends GetxController {
  final state = LaunchAdState();
  Timer? timer;

  @override
  void onReady() {
    super.onReady();
    final iconUrl = state.ad?.image ?? '';
    if(iconUrl.isEmpty){
      Get.offNamed(AppRoutes.home);
    }else{
      _startCountdown();
    }
  }

  void _startCountdown() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timer.isActive) {
        state.secondsRx.value = max(0, state.secondsRx() - 1);
        if (state.secondsRx() == 0) {
          jumpHomePage();
        }
      }
    });
  }

  void _stopCountdown() {
    timer?.cancel();
    timer = null;
  }



  void jumpHomePage(){
    _stopCountdown();
    Get.offAndToNamed(AppRoutes.home);
  }

  @override
  void dispose() {
    _stopCountdown();
    super.dispose();
  }

}

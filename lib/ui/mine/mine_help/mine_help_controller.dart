import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/utils/image_gallery_utils.dart';

import 'mine_help_state.dart';

class MineHelpController extends GetxController {
  final MineHelpState state = MineHelpState();
  final GlobalKey repaintKey = GlobalKey();


  set setCurrent(int i){
    state.currentIndex = i;
    update();
  }

  @override
  void onInit() {
    
    state.filtrateData = state.helpList;
    super.onInit();
  }

  disposeData(String type){
    if(type == "0"){
      state.filtrateData = state.helpList;
    }else{
      state.filtrateData = state.helpList.where((data) => data['type'] == type).toList();
    }
    update();
  }

  void saveQRCode() async {
    ImageGalleryUtils.saveWidgetImage(context: Get.context!, repaintKey: repaintKey);
  }

}

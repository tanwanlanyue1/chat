import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/wish_pavilion/homesick_river/votive_sky_lantern/votive_sky_lantern_controller.dart';
import 'package:guanjia/ui/wish_pavilion/homesick_river/widget/homesick_bottom_sheet.dart';
import 'package:guanjia/widgets/ad_dialog.dart';
import 'package:guanjia/widgets/loading.dart';

import 'homesick_river_state.dart';
import 'missing_river_lamp/missing_river_lamp_page.dart';

class HomesickRiverController extends GetxController  with WidgetsBindingObserver{
  final HomesickRiverState state = HomesickRiverState();
  Timer? _timer;
  Timer? _skyTimer;

  double sizeWidget(int index){
    return (90 - 10 * index).rpx;
  }
  double selfBottom(int index){
    if(index == 2){
      return 10.rpx;
    }else if(index==3){
      return 8.rpx;
    }else if(index == 4){
      return 7.rpx;
    }else{
      return 12.rpx;
    }
  }
  //82
  double selfSize(int index){
    if(index == 1){
      return 72.rpx;
    }else if(index==2){
      return 62.rpx;
    }else if(index==3){
      return 52.rpx;
    }else if(index == 4){
      return 42.rpx;
    }else{
      return 82.rpx;
    }
  }

  void onTapNext(int type) {
    switch (type) {
      case 0:
        _timer?.cancel();
        Get.toNamed(AppRoutes.votiveSkyLanternPage)?.then((value) {
          disposeData();
        });
        break;
      case 1:
        SS.login.requiredAuthorized(() async {
          MissingRiverLampPage.show();
        });
        break;
      case 2:
        _timer?.cancel();
        Get.toNamed(AppRoutes.homesickMine)?.then((value) {
          disposeData();
        });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState states) {
    if (states == AppLifecycleState.inactive) {
      _timer?.cancel();
      _skyTimer?.cancel();
    }
    if (states == AppLifecycleState.resumed) {
      disposeData();
      for(var i = 0; i < (state.allSkyData.length > 4 ? 4 : state.allSkyData.length); i++){
        state.skyData.add(state.allSkyData[i]);
      }
      disposeSkyData();
    }
  }

  //查询我的河灯
  Future<void> getRecord({int? type,}) async {
    final response = await HomesickRiverApi.getRecordList(
      type: type,
      isAll: 0,
      size: 1,
    );
    if(response.isSuccess){
      if(type == 3){
        state.riverData.addAll(response.data ?? []);
        state.allData.addAll(response.data ?? []);
      }else{
        state.skyData.addAll(response.data ?? []);
        state.allSkyData.addAll(response.data ?? []);
        state.fourSky = splitArrayIntoChunks(state.allSkyData);
      }
    }
  }
  ///获取河灯记录
  /// type：灯类型 3:河灯
  ///isAll 1：查所有的
  Future<void> getRecordList({int isAll = 1,int? type,int size = 10}) async {
    final response = await HomesickRiverApi.getRecordList(
      type: 3,
      isAll: 1,
      size: 100,
    );
    if(response.isSuccess){
      if((response.data?.length ?? 0) > 5){
        for(var i = 0; i < 5;i++){
          state.riverData.add(response.data![i]);
        }
      }else{
        state.riverData.value = response.data ?? [];
      }
      state.allData = response.data ?? [];
      disposeData();
    }else{
      response.showErrorMessage();
    }
  }

  ///获取天灯记录
  Future<void> getSkyList() async {
    final response = await HomesickRiverApi.getRecordList(
      type: 4,
      isAll: 1,
      size: 100,
    );
    if(response.isSuccess){
      if((response.data?.length ?? 0) > 4){
        for(var i = 0; i < 4;i++){
          state.skyData.add(response.data![i]);
        }
      }else{
        state.skyData.value = response.data ?? [];
      }
      state.allSkyData = response.data ?? [];
      state.fourSky = splitArrayIntoChunks(state.allSkyData);
      disposeSkyData();
    }else{
      response.showErrorMessage();
    }
  }

  //处理河灯
  void disposeData(){
    _timer = Timer(const Duration(seconds: 4), () {
      if(state.currentIndex < state.allData.length-1){
        state.currentIndex++;
      }else{
        state.currentIndex = 0;
      }
      state.riverData.add(state.allData[state.currentIndex]);
      disposeData();
    });
  }

  //处理天灯
  void disposeSkyData(){
    _skyTimer = Timer(const Duration(seconds: 4), () {
      if(state.fourIndex < (state.fourSky.length-1)){
        state.fourIndex++;
        state.skyData.addAll(state.fourSky[state.fourIndex]);
      }else{
        state.fourIndex = 0;
      }
      disposeSkyData();
    });
  }
  //分割数组长度为4
  List<List<RecordLightModel?>> splitArrayIntoChunks(List<RecordLightModel?> array) {
    List<List<RecordLightModel?>> chunks = [];
    for (int i = 0; i < array.length; i += 4) {
      int end = (i + 4 < array.length) ? i + 4 : array.length;
      List<RecordLightModel?> chunk = array.sublist(i, end);
      while (chunk.length < 4) {
        chunk.add(array[0]);
      }
      chunks.add(chunk);
    }
    return chunks;
  }
  ///获取记录详情
  Future<void> getRecordById({required RecordLightModel item}) async {
    Loading.show();
    final response = await HomesickRiverApi.getRecordById(
      id: item.recordId!,
    );
    if(response.isSuccess){
      Loading.dismiss();
      var data = response.data ?? RecordDetailsModel.fromJson({});
      HomesickBottomSheet.show(
        item: data,
        sky: data.gift?.type == 3,
      );
    }else{
      response.showErrorMessage();
      Loading.dismiss();
    }
  }

  @override
  void onInit() {
    WidgetsBinding.instance.addObserver(this);
    getRecordList();
    getSkyList();
    startupCarousel();
    super.onInit();
  }

  ///用户祝福
  Future<bool?> recordBlessing({required int id}) async {
    bool login = false;
    SS.login.requiredAuthorized(() async {
      login = true;
    });
   if(login){
     final response = await HomesickRiverApi.recordBlessing(
       recordId: id,
     );
     if(response.isSuccess){
       update(['homeShow']);
       return true;
     }else{
       response.showErrorMessage();
     }
   }
  }

  ///再次许愿
  void wishAgain(RecordDetailsModel item) async {
    final votiveSkyLantern = Get.put(VotiveSkyLanternController());
    votiveSkyLantern.getConfig(item.gift!,details: item);
  }

  /// 获取广告弹窗
  void startupCarousel() async {
    final response = await OpenApi.startupAdvertList(
        type: 3,
        position: 9,
        size: 1
    );
    if (response.isSuccess) {
      if(response.data?.isNotEmpty ?? false){
        AppAdDialog.show(response.data![0],"9");
      }
    }
  }
  @override
  void onClose() {
    
    _timer?.cancel();
    _skyTimer?.cancel();
    super.onClose();
  }
}

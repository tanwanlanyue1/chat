import 'dart:core';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/event/event_bus.dart';
import 'package:guanjia/common/event/event_constant.dart';
import 'package:guanjia/common/utils/common_utils.dart';
import 'package:guanjia/widgets/loading.dart';

import '../../../../common/network/api/api.dart';
import '../widget/release_success.dart';
import 'release_invitation_state.dart';

class ReleaseInvitationController extends GetxController {
  final ReleaseInvitationState state = ReleaseInvitationState();
  TextEditingController contentController = TextEditingController();
  TextEditingController serviceController = TextEditingController();

  //设置标签
  void setLabel(int index){
    if(state.labelList.length < 3){
      if(state.labelList.contains(index)){
        state.labelList.remove(index);
      }else{
        state.labelList.add(index);
      }
    }else{
      if(state.labelList.contains(index)){
        state.labelList.remove(index);
      }
    }
  }

  //附加标签
  void additionLabel() async {
    final response = await OpenApi.getStyleList(
        type: 3,
    );
    if (response.isSuccess) {
      state.label.value = response.data ?? [];
      update();
    }else{
      response.showErrorMessage();
    }
  }

  //获取七天
  void getNextSevenDays() {
    List<String> list = [];
    DateTime today = DateTime.now();
    state.hour = today.hour;
    state.startHour = today.hour;
    state.endHour = today.hour+1;
    for (int i = 0; i < 7; i++) {
      DateTime nextDay = today.add(Duration(days: i));
      list.add(CommonUtils.dateString('$nextDay',lineFeed: true));
    }
    state.timeList = list;
  }

  //时间
  DateTime timeDate({required int time,required int hour}){
    return DateTime.now().add(Duration(days: time)).copyWith(hour: hour);
  }

  @override
  void onInit() {
    // TODO: implement onInit
    additionLabel();
    getNextSevenDays();
    super.onInit();
  }

  //发布
  void onTapRelease() async {
    int comparison = timeDate(time: state.endTime, hour: state.endHour).compareTo( timeDate(time: state.startTime, hour: state.startHour+1));
    if(contentController.text.isEmpty){
      Loading.showToast("约会内容不能为空");
    }else if(comparison < 0){
      Loading.showToast("结束日期最少需要大于开始时间2小时");
    }else{
      Loading.show();
      String tag = "";
      for(var i = 0; i < state.labelList.length; i++){
        tag += "${state.label[state.labelList[i]].id},";
      }
      final response = await DiscoverApi.appointmentAdd(
          type: state.typeList[state.typeIndex.value]['type'],
          content: contentController.text,
          coordinate: '113.17,23.8',
          location: '广州',
          startTimeStamp: (DateTime.now().add(Duration(days: state.startTime)).copyWith(hour: state.startHour)).millisecondsSinceEpoch,
          endTimeStamp: (DateTime.now().add(Duration(days: state.endTime)).copyWith(hour: state.endHour)).millisecondsSinceEpoch,
          tag: tag,
          serviceCharge: serviceController.text.isNotEmpty ? double.parse(serviceController.text):0
      );
      Loading.dismiss();
      if (response.isSuccess) {
        EventBus().emit(kEventReleaseSuccess);
        ReleaseSuccess.show();
      }else{
        response.showErrorMessage();
      }
    }
  }

}

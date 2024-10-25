import 'dart:core';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/event/event_bus.dart';
import 'package:guanjia/common/event/event_constant.dart';
import 'package:guanjia/common/network/api/model/open/google_places_model.dart';
import 'package:guanjia/common/utils/common_utils.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/map/choose_place/choose_place_page.dart';
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

  //约会地点
  void datingSite() async{
    PlaceModel? data = await ChoosePlacePage.go(title:'选择地点');
    if(data!= null){
      state.coordinate = '${data.geometry?.location?.lng},${data.geometry?.location?.lat}';
      state.location.value = data.name;
      update(['dateFrom']);
    }
  }

  //获取七天
  void getNextSevenDays() {
    List<Map> list = [];
    DateTime today = DateTime.now();
    state.hour = today.hour;
    state.startHour = today.hour;
    state.endHour = today.hour+2;
    for (int i = 0; i < 7; i++) {
      DateTime nextDay = today.add(Duration(days: i));
      List<String> fruits = CommonUtils.dateString('$nextDay',lineFeed: true).split(',');
      list.add({
        "day":fruits[0],
        "time":fruits[1],
      });
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
    getSurplus();
    super.onInit();
  }

  ///获取发布约会剩余次数
  void getSurplus() async {
    final response = await DiscoverApi.getSurplus();
    if (response.isSuccess) {
      state.surplus.value = response.data;
    } else {
      response.showErrorMessage();
    }
  }

  //发布
  void onTapRelease() async {
    int comparison = timeDate(time: state.endTime, hour: state.endHour).compareTo( timeDate(time: state.startTime, hour: state.startHour+1));
    if(contentController.text.isEmpty){
      Loading.showToast(S.current.appointmentNoEmpty);
    }else if(comparison < 0){
      Loading.showToast(S.current.theMustLonger);
    }else if(!state.serve.value && serviceController.text.isEmpty){
      Loading.showToast(S.current.pleaseServiceAmount);
    }else{
      Loading.show();
      String tag = "";
      for(var i = 0; i < state.labelList.length; i++){
        tag += "${state.label[state.labelList[i]].id},";
      }
      final response = await DiscoverApi.appointmentAdd(
          type: state.typeList[state.typeIndex.value]['type'],
          content: contentController.text,
          coordinate: state.coordinate,
          location: state.location.value,
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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/widgets/loading.dart';

import 'bottom_sheet_chat_state.dart';

class BottomSheetChatController extends GetxController {
  final BottomSheetChatState state = BottomSheetChatState();
  final TextEditingController chatController = TextEditingController();
  FocusNode focusNode = FocusNode();

  //重新回答
  setChartList(int index){
    state.chartList['problemList'][index]['recover'].add('我是重新回答的结果，我是重新回答的结果我是重新回答的结果');
    update();
  }

  //发送消息-重新请求接口并刷新
  //message：用户重新发起的问题
  sendMessage(){
    if(chatController.text.isEmpty){
      return Loading.showToast("请输入问题");
    }
    Map<String,Object> item = {
      "time": DateTime.now(),
      "problem": chatController.text,
      "recover": ['我是系统返回的数据，我是系统返回的数据我是系统返回的数据我是系统返回的数据我是系统返回的数据'],
    };
    state.chartList['problemList'].add(item);
    focusNode.unfocus();
    update();
  }
}

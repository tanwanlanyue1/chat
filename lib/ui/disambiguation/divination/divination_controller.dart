import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/ui/home/bottom_sheet_chat/bottom_sheet_chat_page.dart';
import 'package:guanjia/widgets/ad_dialog.dart';
import 'package:guanjia/widgets/loading.dart';
import 'dart:math';
import 'divination_state.dart';
import 'widgets/tarot_show.dart';

class DivinationController extends GetxController with GetSingleTickerProviderStateMixin{
  final DivinationState state = DivinationState();

  //困惑输入框控制器
  final TextEditingController bewildermentController = TextEditingController();
  final random = Random();

  //初始化塔罗牌
  initDragging(){
    state.rewashing.value = false;
    state.isDragging = List.generate(8, (index) => false);
    state.droppedData = [
      {
        "title":"过去",
      },
      {
        "title":"现在",
      },
      {
        "title":"未来",
      },
    ];
  }

  //初始化周易
  initYao(){
    state.yaoData = [];
    state.trigram.value = "第一爻";
    bewildermentController.text = '';
    state.hexagram.value = [
      {'name':"第一爻",'value':'',"type": ''},
      {'name':"第二爻",'value':'',"type": ''},
      {'name':"第三爻",'value':'',"type": ''},
      {'name':"第四爻",'value':'',"type": ''},
      {'name':"第五爻",'value':'',"type": ''},
      {'name':"第六爻",'value':'',"type": ''},
    ];
  }

  ///随机生成卦象
  ///0：正面，1背面
  setYao(){
    if(state.yaoData.length > 5){
      initYao();
    }
    final random1 = random.nextInt(100);
    final random2 = random.nextInt(100);
    final random3 = random.nextInt(100);
    final hexagram = List.of(state.hexagram());
    state.yaoData.add([random1 % 2,random2 % 2,random3 % 2]);
    state.symbols.value = !state.symbols.value;
    List data = state.yaoData.last;
    int count = data.where((number) => number == 0).length;
    for (var element in state.divination) {
      if(element['data'] == count){
        hexagram[state.yaoData.length-1]['value'] = element['name'];
        hexagram[state.yaoData.length-1]['type'] = element['type'];
        state.trigram.value = ((state.yaoData.length < 6) ? hexagram[state.yaoData.length]['name'] : '第一爻')!;
      }
    }
    state.hexagram.value = hexagram;
  }

  //一键摇卦
  allYao(){
    int count = state.yaoData.length == 6 ? 0 : state.yaoData.length;
    for(var i = 0; i < 6-count; i++){
      setYao();
    }
  }

  //结果
  void switchType(){
    if(state.tabBarIndex.value == 0){
      sixYao();
    }else{
      saveTarot();
    }
  }

  //（1占卜 2塔罗牌 3取名 4星座-运势 5星座-星盘 6星座-配对 7运势 8解梦）
  //type 0：周易占卜，1：取名 2：星座运势 3：运势 4：解梦 5:占卜塔罗牌
  int types(int type){
    switch (type) {
      case 1:
        return 0;
      case 2:
        return 5;
      case 3:
        return 1;
      case 4:
        return 2;
      case 5:
        return 2;
      case 6:
        return 2;
      case 7:
        return 3;
      case 8:
        return 4;
      default:
        return 0;
    }
  }

  @override
  void onInit() {
    getDoubtList();
    getGold();
    startupCarousel();
    startupAdvertList();
    super.onInit();
  }

  ///周易-占卜
  ///yao: 卦象（少阴 0，老阴 2，少阳 1， 老阳 3）,示例值(331011)
  Future<void> sixYao() async {
    SS.login.requiredAuthorized(() async {
      if(state.yaoData.length != 6){
        Loading.showToast('请先卜六卦！');
      }else{
        String yao = '';
        String yao1 = '';
        for (var element in state.hexagram) {
          yao += element['type']!;
          if(element['name'] == '第六爻'){
            yao1 += element['type']!;
          }else{
            yao1 += '${element['type']!},';
          }
        }
        Loading.show();
        final response = await DisambiguationApi.sixYao(
          yao: yao,
          question: bewildermentController.text,
        );
        Loading.dismiss();
        if(response.isSuccess){
          SS.login.fetchLevelMoneyInfo();
          Map item = {
            "quiz":{
              "yao": yao1,
              "name": bewildermentController.text,
            },
            "answer": response.data,
          };
          initYao();
          BottomSheetChatPage.show(
            type: 1,
            item: item,
          );
          if(state.costGold == 0){
            getGold();
          }
        }else{
          response.showErrorMessage();
        }
      }
    });
  }

  ///塔罗牌-获取三张随机牌
  Future<void> getTarot() async {
    SS.login.requiredAuthorized(() async {
      Loading.show();
      final response = await DisambiguationApi.getTarot();
      Loading.dismiss();
      if(response.isSuccess){
        state.randomTarot = response.data ?? [];
        Get.bottomSheet(
            isScrollControlled: true,
            TarotShow(
              callBack: (){
                state.rewashing.value = true;
              },
            )
        );
      }else{
        response.showErrorMessage();
      }
    });
  }

  ///解惑-塔罗牌
  /// tarot-	塔罗牌url 格式：多个用英文逗号隔开
  Future<void> saveTarot() async {
    SS.login.requiredAuthorized(() async {
      if(!state.rewashing.value){
        Loading.showToast('请先抽取塔罗牌！');
      }else{
        String tarot = '';
        for(var i = 0; i < state.randomTarot.length;i++){
          if(i != 2){
            tarot += '${state.randomTarot[i]['name']},';
          }else{
            tarot += '${state.randomTarot[i]['name']}';
          }
        }
        Loading.show();
        final response = await DisambiguationApi.saveTarot(
          tarot: tarot,
          url: state.randomTarot[0]['url'],
          question: bewildermentController.text,
        );
        Loading.dismiss();
        if(response.isSuccess){
          if(state.costGold == 0){
            getGold();
          }
          SS.login.fetchLevelMoneyInfo();
          Map item = {
            "quiz":{
              "tarot": state.randomTarot,
              "name": bewildermentController.text,
            },
            "answer": response.data,
          };
          bewildermentController.text = '';
          BottomSheetChatPage.show(
            type: 2,
            item: item,
          );
        }else{
          response.showErrorMessage();
        }
      }
    });
  }

  ///查询大家的疑惑
  Future<void> getDoubtList() async {
    final response = await DisambiguationApi.getDoubtList(
      type: state.tabBarIndex.value +1
    );
    if(response.isSuccess){
      state.allBewilderment = response.data ?? [];
      update();
    }
  }

  ///玩法所需境修币
  Future<void> getGold() async {
    final response = await DisambiguationApi.getGold(
        type: state.tabBarIndex.value +1
    );
    if(response.isSuccess){
      state.costGold = response.data?.cost ?? 0;
      update();
    }
  }

  ///查询大家的疑惑-详情
  ///	玩法类型（1占卜 2塔罗牌 3取名 4星座-运势 5星座-星盘 6星座-配对 7运势 8解梦）
  Future<void> getLogDetail({required int id}) async {
    SS.login.requiredAuthorized(() async {
      final response = await DisambiguationApi.getLogDetail(
          id: id
      );
      if(response.isSuccess){
        Map item = {
          "parameter":response.data?.parameter,
          "answer": response.data?.result,
        };
        BottomSheetChatPage.show(
          type: response.data!.type!,
          item: item,
        );
      }else{
        response.showErrorMessage();
      }
    });
  }

  /// 获取广告轮播 carousel
  void startupCarousel() async {
    final response = await OpenApi.startupAdvertList(
        type: 4,
        position: 1
    );
    if (response.isSuccess) {
      state.carousel = response.data ?? [];
      update();
    }
  }

  /// 获取广告弹窗
  void startupAdvertList() async {
    final response = await OpenApi.startupAdvertList(
        type: 3,
        position: 1,
        size: 1
    );
    if (response.isSuccess) {
      if(response.data?.isNotEmpty ?? false){
        AppAdDialog.show(response.data![0],'1');
      }
    }
  }
  @override
  void onClose() {
    
    bewildermentController.dispose();
    super.onClose();
  }
}

import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';

import '../../../common/network/api/api.dart';

class DivinationState {
  RxInt tabBarIndex = 0.obs; //0:周易/1:塔罗牌
  final trigram = "第一爻".obs;//第几爻
  final symbols = true.obs;//乌龟
  final rewashing = false.obs;//是否选择完毕
  int costGold = 0;//消费境修币

  //塔罗牌是否拖拽
  List<bool> isDragging = List.generate(8, (index) => false);
  //爻卦象 0：正面，1背面
  List yaoData = [];
  //广播
  List<AdvertisingStartupModel> carousel = [];

  //接受选择的塔罗牌
  List droppedData = [
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
  //随机三张塔罗牌
  List randomTarot = [];

  //大家的困惑
  List allBewilderment = [];

  ///爻
  final hexagram = [
    {'name':"第一爻",'value':'',"type": ''},
    {'name':"第二爻",'value':'',"type": ''},
    {'name':"第三爻",'value':'',"type": ''},
    {'name':"第四爻",'value':'',"type": ''},
    {'name':"第五爻",'value':'',"type": ''},
    {'name':"第六爻",'value':'',"type": ''},
  ].obs;

  ///卦相
  ///少阴1 00，少阳 11 0 老阴 111，老阳 000
  ///data 0的数量
  List divination = [
    {'name':"一少阳","type": '1',"data": 1},
    {'name':"--少阴","type": '0',"data": 2},
    {'name':"-O老阳","type": '3',"data": 3},
    {'name':"--X老阴","type": '2',"data": 0}
  ];
}

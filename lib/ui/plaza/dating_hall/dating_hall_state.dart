import 'package:get/get.dart';
import 'package:guanjia/ui/plaza/fortune_square/fortune_square_state.dart';

class RectifyTheWorkplaceState {
  //话题类型
  // List<TopicModel> topicType = [
  //   TopicModel(
  //     name: "职场工具",
  //     icon: "",
  //   ),
  //   TopicModel(
  //     name: "职场百科",
  //     icon: "",
  //   ),
  //   TopicModel(
  //     name: "职场礼仪",
  //     icon: "",
  //   ),
  //   TopicModel(
  //     name: "摸鱼技巧",
  //     icon: "",
  //   ),
  // ];
  //热门话题
  List hotTopic = [
    {"name":"面试通关指南"},
    {"name":"一起上岸吧"},
    {"name":"大学生职场100问"},
    {"name":"打工人的日常"},
    {"name":"求职困惑"},
    {"name":"是否可以把薪资降一点"},
    {"name":"30岁是道坎"},
    {"name":"入职踩过的大坑"},
  ];
  //话题分类
  List topicClassify = [
    "最新","推荐","玩转职场","职业技能","摸鱼技巧","求职面试","为人处事","保障","职场百科"
  ];
  final classifyIndex = 0.obs; //分类下标
  //瀑布流数据
  List fallsList = [
    {
      "icon":"https://img1.baidu.com/it/u=3213028832,2848109658&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=750",
      "width":"500",
      "height":"750",
      "title":"对异性吸引力最强对星座女",
      "header":"https://img0.baidu.com/it/u=2983778692,229617415&fm=253&app=120&size=w931&n=0&f=JPEG&fmt=auto?sec=1712854800&t=15dc850cdca490a182bd67bfe3a1b557",
      "userName":"张三-李四",
      "read":"1252",
    },
    {
      "icon":"https://img2.baidu.com/it/u=1503513339,2481114924&fm=253&fmt=auto&app=138&f=JPEG?w=750&h=500",
      "width":"750",
      "height":"500",
      "title":"对异性吸引力最强对星座女",
      "header":"https://img0.baidu.com/it/u=2983778692,229617415&fm=253&app=120&size=w931&n=0&f=JPEG&fmt=auto?sec=1712854800&t=15dc850cdca490a182bd67bfe3a1b557",
      "userName":"张三-李四",
      "read":"1252",
    },
    {
      "icon":"https://img2.baidu.com/it/u=2814423264,141840134&fm=253&fmt=auto&app=138&f=JPEG?w=667&h=500",
      "width":"667",
      "height":"500",
      "title":"对异性吸引力最强对星座女",
      "header":"https://img0.baidu.com/it/u=2983778692,229617415&fm=253&app=120&size=w931&n=0&f=JPEG&fmt=auto?sec=1712854800&t=15dc850cdca490a182bd67bfe3a1b557",
      "userName":"张三-李四",
      "read":"1252",
    },
    {
      "icon":"https://img1.baidu.com/it/u=3213028832,2848109658&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=750",
      "width":"500",
      "height":"750",
      "title":"对异性吸引力最强对星座女",
      "header":"https://img0.baidu.com/it/u=2983778692,229617415&fm=253&app=120&size=w931&n=0&f=JPEG&fmt=auto?sec=1712854800&t=15dc850cdca490a182bd67bfe3a1b557",
      "userName":"张三-李四",
      "read":"1252",
    },
    {
      "icon":"https://img1.baidu.com/it/u=3213028832,2848109658&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=750",
      "width":"500",
      "height":"750",
      "title":"对异性吸引力最强对星座女",
      "header":"https://img0.baidu.com/it/u=2983778692,229617415&fm=253&app=120&size=w931&n=0&f=JPEG&fmt=auto?sec=1712854800&t=15dc850cdca490a182bd67bfe3a1b557",
      "userName":"张三-李四",
      "read":"1252",
    },
    {
      "icon":"https://img2.baidu.com/it/u=1503513339,2481114924&fm=253&fmt=auto&app=138&f=JPEG?w=750&h=500",
      "width":"750",
      "height":"500",
      "title":"对异性吸引力最强对星座女",
      "header":"https://img0.baidu.com/it/u=2983778692,229617415&fm=253&app=120&size=w931&n=0&f=JPEG&fmt=auto?sec=1712854800&t=15dc850cdca490a182bd67bfe3a1b557",
      "userName":"张三-李四",
      "read":"1252",
    },
    {
      "icon":"https://img2.baidu.com/it/u=2814423264,141840134&fm=253&fmt=auto&app=138&f=JPEG?w=667&h=500",
      "width":"667",
      "height":"500",
      "title":"对异性吸引力最强对星座女",
      "header":"https://img0.baidu.com/it/u=2983778692,229617415&fm=253&app=120&size=w931&n=0&f=JPEG&fmt=auto?sec=1712854800&t=15dc850cdca490a182bd67bfe3a1b557",
      "userName":"张三-李四",
      "read":"1252",
    },
    {
      "icon":"https://img1.baidu.com/it/u=3213028832,2848109658&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=750",
      "width":"500",
      "height":"750",
      "title":"对异性吸引力最强对星座女",
      "header":"https://img0.baidu.com/it/u=2983778692,229617415&fm=253&app=120&size=w931&n=0&f=JPEG&fmt=auto?sec=1712854800&t=15dc850cdca490a182bd67bfe3a1b557",
      "userName":"张三-李四",
      "read":"1252",
    },
  ];
}


import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/disambiguation/star_sign/star_sign_state.dart';
import 'package:guanjia/widgets/app_image.dart';

import '../../../common/network/api/model/talk_model.dart';

///星座-星盘
class AnswerStarAstrolabe extends StatelessWidget {
  Map item;
  AnswerStarAstrolabe({super.key,required this.item});

  //全部星座
  List<Starts> starSignList = [
    Starts(
        icon: "assets/images/disambiguation/aries.png",
        constellation: "aries",
        name: "白羊座",
        time: "03.21-04.19"
    ),
    Starts(
        icon: "assets/images/disambiguation/taurus.png",
        constellation: "taurus",
        name: "金牛座",
        time: "03.21-04.19"
    ),
    Starts(
        icon: "assets/images/disambiguation/gemini.png",
        constellation: "gemini",
        name: "双子座",
        time: "05.21-06.21"
    ),
    Starts(
        icon: "assets/images/disambiguation/cancer.png",
        constellation: "cancer",
        name: "巨蟹座",
        time: "06.22-07.22"
    ),
    Starts(
        icon: "assets/images/disambiguation/lion.png",
        constellation: "leo",
        name: "狮子座",
        time: "07.23-08.22"
    ),
    Starts(
        icon: "assets/images/disambiguation/virgo.png",
        constellation: "virgo",
        name: "处女座",
        time: "08.23-09.22"
    ),
    Starts(
        icon: "assets/images/disambiguation/libra.png",
        constellation: "libra",
        name: "天秤座",
        time: "09.23-10.23"
    ),
    Starts(
        icon: "assets/images/disambiguation/scorpio.png",
        constellation: "scorpio",
        name: "天蝎座",
        time: "10.24-11.22"
    ),
    Starts(
        icon: "assets/images/disambiguation/shooter.png",
        constellation: "sagittarius",
        name: "射手座",
        time: "11.23-12.21"
    ),
    Starts(
        icon: "assets/images/disambiguation/capricorn.png",
        constellation: "capricorn",
        name: "摩羯座",
        time: "12.22-01.19"
    ),
    Starts(
        icon: "assets/images/disambiguation/aquarius.png",
        constellation: "aquarius",
        name: "水瓶座",
        time: "01.20-02.18"
    ),
    Starts(
        icon: "assets/images/disambiguation/pisces.png",
        constellation: "pisces",
        name: "双鱼座",
        time: "02.19-03.20"
    ),
  ];


  //星座icon
  String starIcon(String str){
    for (var element in starSignList) {
      if(element.name == str){
        return element.icon!;
      }
    }
    return '';
  }

  //截取1./2.
  String subString(String str){
    String str1 = str.substring(0,str.indexOf(" 2."));
    String str2 = str.substring(str.indexOf(" 2."),str.length);
    String ss = '$str1\n$str2';
    return ss;
  }

  @override
  Widget build(BuildContext context) {
    return item['parameter'] == null?
    astrolabe():
    history();
  }

  //星座-星盘
  Widget astrolabe(){
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8.rpx))
      ),
      margin: EdgeInsets.only(left: 22.rpx,right: 22.rpx),
      padding: EdgeInsets.all(12.rpx),
      child: Column(
        children: [
          Text("星盘解读",style: AppTextStyle.fs16b.copyWith(color: AppColor.gray5),),
          //星盘
          GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10.rpx,
                crossAxisSpacing: 18.rpx,
                mainAxisExtent: 123.rpx,
              ),
              itemCount: item['answer'].length,
              padding: EdgeInsets.only(top: 12.rpx,bottom: 20.rpx),
              itemBuilder: (_, i) {
                AstrolabeModel data = item['answer'][i];
                return Container(
                  width: 90.rpx,
                  height: 123.rpx,
                  decoration: BoxDecoration(
                    image: AppDecorations.backgroundImage(
                      "assets/images/home/star_astrolabe.png",
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 10.rpx,bottom: 5.rpx),
                        child: AppImage.asset(
                          starIcon(data.zodiacSign ?? ''),
                          width: 53.rpx,height: 44.rpx,),
                        // child: AppImage.asset('assets/images/disambiguation/aries.png',width: 53.rpx,height: 44.rpx,),
                      ),
                      Visibility(
                        visible: data.houseName != null,
                        replacement: SizedBox(height: 24.rpx,),
                        child: Container(
                          width: 40.rpx,
                          height: 14.rpx,
                          margin: EdgeInsets.only(bottom: 10.rpx),
                          decoration: BoxDecoration(
                              color: AppColor.brown26,
                              borderRadius: BorderRadius.all(Radius.circular(8.rpx))
                          ),
                          child: Center(
                            child: Text("${data.houseName}",style: AppTextStyle.fs10m.copyWith(color: Colors.white,height: 1),),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("${data.planetName}",style: AppTextStyle.fs11m.copyWith(color: AppColor.brown26),),
                          Container(
                            width: 2.rpx,
                            height: 2.rpx,
                            margin: EdgeInsets.symmetric(horizontal: 2.rpx),
                            decoration: BoxDecoration(
                                color:  AppColor.brown26,
                                borderRadius: BorderRadius.all(Radius.circular(8.rpx))
                            ),
                          ),
                          Text("${data.zodiacSign}",style: AppTextStyle.fs12b.copyWith(color: AppColor.brown26),),
                        ],
                      ),
                      Text("${data.planetPosition}",style: AppTextStyle.fs10m.copyWith(color: AppColor.brown26),),
                    ],
                  ),
                );
              }
          ),
          //行星
          Column(
            children: List.generate(item['answer'].length, (index) {
              AstrolabeModel data = item['answer'][index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //标题
                  Row(
                    children: [
                      Text("${data.planetName}",style: AppTextStyle.fs16b.copyWith(color: AppColor.gray5),),
                      Container(
                        width: 2.rpx,
                        height: 2.rpx,
                        margin: EdgeInsets.symmetric(horizontal: 2.rpx),
                        decoration: BoxDecoration(
                            color:  AppColor.brown26,
                            borderRadius: BorderRadius.all(Radius.circular(8.rpx))
                        ),
                      ),
                      Text("${data.zodiacSign}",style: AppTextStyle.fs16b.copyWith(color: AppColor.gray5),),
                    ],
                  ),
                  //简介
                  data.personalityTraits!.contains("个性特质") ?
                  Container(
                    margin: EdgeInsets.only(bottom: 8.rpx,top: 8.rpx),
                    padding: EdgeInsets.symmetric(horizontal: 12.rpx,vertical: 4.rpx),
                    decoration: BoxDecoration(
                        color: AppColor.brown8,
                        borderRadius: BorderRadius.all(Radius.circular(8.rpx))
                    ),
                    child: Text("${data.personalityTraits?.substring(0,data.personalityTraits?.indexOf("个性特质"))}",style: AppTextStyle.fs12m.copyWith(color: AppColor.red1,height: 1),),
                  ):
                  Container(),
                  //特质
                  data.personalityTraits!.contains("个性特质") ?
                  Padding(
                    padding: EdgeInsets.only(bottom: 8.rpx),
                    child: Text("${data.personalityTraits?.substring(data.personalityTraits!.indexOf("个性特质")+4,data.personalityTraits!.indexOf("用两句话来形容你吧"))}",style: AppTextStyle.fs14b.copyWith(color: AppColor.gray5),),
                  ):
                  Container(),
                  //详情
                  data.personalityTraits!.contains("用两句话来形容你吧") ?
                  Text(
                    subString(data.personalityTraits?.substring(data.personalityTraits!.indexOf("用两句话来形容你吧")+10,data.personalityTraits?.length) ?? ''),
                    style: AppTextStyle.fs14m.copyWith(color: AppColor.gray5),):
                  Text("${data.personalityTraits}",style: AppTextStyle.fs14m.copyWith(color: AppColor.gray5),),
                  SizedBox(height: 12.rpx,),
                ],
              );
            }),
          ),
          //行宫
          Column(
            children: List.generate(item['answer'].length, (index) {
              AstrolabeModel data = item['answer'][index];
              return Visibility(
                visible: data.houseName != null,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text("${data.houseName}",style: AppTextStyle.fs16b.copyWith(color: AppColor.gray5),),
                        Container(
                          width: 2.rpx,
                          height: 2.rpx,
                          margin: EdgeInsets.symmetric(horizontal: 2.rpx),
                          decoration: BoxDecoration(
                              color:  AppColor.brown26,
                              borderRadius: BorderRadius.all(Radius.circular(8.rpx))
                          ),
                        ),
                        Text("${data.zodiacSign}",style: AppTextStyle.fs16b.copyWith(color: AppColor.gray5),),
                      ],
                    ),
                    Text("${data.houseTraits}",style: AppTextStyle.fs14m.copyWith(color: AppColor.gray30),),
                    SizedBox(height: 12.rpx,),
                  ],
                ),
              );
            }),
          )
        ],
      ),
    );
  }

  //历史
  Widget history(){
    List historyData = jsonDecode(item['answer']);
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8.rpx))
      ),
      margin: EdgeInsets.only(left: 22.rpx,right: 22.rpx),
      padding: EdgeInsets.all(12.rpx),
      child: Column(
        children: [
          Text("星盘解读",style: AppTextStyle.fs16b.copyWith(color: AppColor.gray5),),
          //星盘
          GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10.rpx,
                crossAxisSpacing: 18.rpx,
                mainAxisExtent: 123.rpx,
              ),
              itemCount: historyData.length,
              padding: EdgeInsets.only(top: 12.rpx,bottom: 20.rpx),
              itemBuilder: (_, i) {
                AstrolabeModel data = AstrolabeModel.fromJson(historyData[i]);
                return Container(
                  width: 90.rpx,
                  height: 123.rpx,
                  decoration: BoxDecoration(
                    image: AppDecorations.backgroundImage(
                      "assets/images/home/star_astrolabe.png",
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 10.rpx,bottom: 5.rpx),
                        child: AppImage.asset(
                          starIcon(data.zodiacSign ?? ''),
                          width: 53.rpx,height: 44.rpx,),
                        // child: AppImage.asset('assets/images/disambiguation/aries.png',width: 53.rpx,height: 44.rpx,),
                      ),
                      Visibility(
                        visible: data.houseName != null,
                        replacement: SizedBox(height: 24.rpx,),
                        child: Container(
                          width: 40.rpx,
                          height: 14.rpx,
                          margin: EdgeInsets.only(bottom: 10.rpx),
                          decoration: BoxDecoration(
                              color: AppColor.brown26,
                              borderRadius: BorderRadius.all(Radius.circular(8.rpx))
                          ),
                          child: Center(
                            child: Text("${data.houseName}",style: AppTextStyle.fs10m.copyWith(color: Colors.white,height: 1),),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("${data.planetName}",style: AppTextStyle.fs11m.copyWith(color: AppColor.brown26),),
                          Container(
                            width: 2.rpx,
                            height: 2.rpx,
                            margin: EdgeInsets.symmetric(horizontal: 2.rpx),
                            decoration: BoxDecoration(
                                color:  AppColor.brown26,
                                borderRadius: BorderRadius.all(Radius.circular(8.rpx))
                            ),
                          ),
                          Text("${data.zodiacSign}",style: AppTextStyle.fs12b.copyWith(color: AppColor.brown26),),
                        ],
                      ),
                      Text("${data.planetPosition}",style: AppTextStyle.fs10m.copyWith(color: AppColor.brown26),),
                    ],
                  ),
                );
              }
          ),
          //行星
          Column(
            children: List.generate(historyData.length, (index) {
              AstrolabeModel data = AstrolabeModel.fromJson(historyData[index]);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //标题
                  Row(
                    children: [
                      Text("${data.planetName}",style: AppTextStyle.fs16b.copyWith(color: AppColor.gray5),),
                      Container(
                        width: 2.rpx,
                        height: 2.rpx,
                        margin: EdgeInsets.symmetric(horizontal: 2.rpx),
                        decoration: BoxDecoration(
                            color:  AppColor.brown26,
                            borderRadius: BorderRadius.all(Radius.circular(8.rpx))
                        ),
                      ),
                      Text("${data.zodiacSign}",style: AppTextStyle.fs16b.copyWith(color: AppColor.gray5),),
                    ],
                  ),
                  //简介
                  data.personalityTraits!.contains("个性特质") ?
                  Container(
                    margin: EdgeInsets.only(bottom: 8.rpx,top: 8.rpx),
                    padding: EdgeInsets.symmetric(horizontal: 12.rpx,vertical: 4.rpx),
                    decoration: BoxDecoration(
                        color: AppColor.brown8,
                        borderRadius: BorderRadius.all(Radius.circular(8.rpx))
                    ),
                    child: Text("${data.personalityTraits?.substring(0,data.personalityTraits?.indexOf("个性特质"))}",style: AppTextStyle.fs12m.copyWith(color: AppColor.red1,height: 1),),
                  ):
                  Container(),
                  //特质
                  data.personalityTraits!.contains("个性特质") ?
                  Padding(
                    padding: EdgeInsets.only(bottom: 8.rpx),
                    child: Text("${data.personalityTraits?.substring(data.personalityTraits!.indexOf("个性特质")+4,data.personalityTraits!.indexOf("用两句话来形容你吧"))}",style: AppTextStyle.fs14b.copyWith(color: AppColor.gray5),),
                  ):
                  Container(),
                  //详情
                  data.personalityTraits!.contains("用两句话来形容你吧") ?
                  Text(
                    subString(data.personalityTraits?.substring(data.personalityTraits!.indexOf("用两句话来形容你吧")+10,data.personalityTraits?.length) ?? ''),
                    style: AppTextStyle.fs14m.copyWith(color: AppColor.gray5),):
                  Text("${data.personalityTraits}",style: AppTextStyle.fs14m.copyWith(color: AppColor.gray5),),
                  SizedBox(height: 12.rpx,),
                ],
              );
            }),
          ),
          //行宫
          Column(
            children: List.generate(historyData.length, (index) {
              AstrolabeModel data = AstrolabeModel.fromJson(historyData[index]);
              return Visibility(
                visible: data.houseName != null,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text("${data.houseName}",style: AppTextStyle.fs16b.copyWith(color: AppColor.gray5),),
                        Container(
                          width: 2.rpx,
                          height: 2.rpx,
                          margin: EdgeInsets.symmetric(horizontal: 2.rpx),
                          decoration: BoxDecoration(
                              color:  AppColor.brown26,
                              borderRadius: BorderRadius.all(Radius.circular(8.rpx))
                          ),
                        ),
                        Text("${data.zodiacSign}",style: AppTextStyle.fs16b.copyWith(color: AppColor.gray5),),
                      ],
                    ),
                    Text("${data.houseTraits}",style: AppTextStyle.fs14m.copyWith(color: AppColor.gray30),),
                    SizedBox(height: 12.rpx,),
                  ],
                ),
              );
            }),
          )
        ],
      ),
    );
  }
}

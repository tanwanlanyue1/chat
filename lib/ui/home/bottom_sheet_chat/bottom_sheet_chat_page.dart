import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/ui/home/widget/answer_dream.dart';
import 'package:guanjia/ui/home/widget/answer_fortune.dart';
import 'package:guanjia/ui/home/widget/answer_star_astrolabe.dart';
import 'package:guanjia/ui/home/widget/answer_star_pair.dart';
import 'package:guanjia/ui/home/widget/answer_star_sign.dart';
import 'package:guanjia/ui/home/widget/answer_take_name.dart';
import 'package:guanjia/ui/home/widget/answer_tarot.dart';
import 'package:guanjia/ui/home/widget/answer_yao.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/input_widget.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import '../widget/astrolabe_type.dart';
import '../widget/dream_type.dart';
import '../widget/fortune_type.dart';
import '../widget/pair_type.dart';
import '../widget/problem_star_type.dart';
import '../widget/take_name_type.dart';
import '../widget/tarot_type.dart';
import '../widget/yao_type.dart';
import 'bottom_sheet_chat_controller.dart';


///底部弹出聊天页
class BottomSheetChatPage extends StatelessWidget {
  int type;
  Map? item;
  BottomSheetChatPage({super.key, required this.type,this.item});
  static void show({required int type,dynamic item}) {
    Get.bottomSheet(
      isScrollControlled: true,
      BottomSheetChatPage(type: type,item: item,),
    );
  }

  final controller = Get.put(BottomSheetChatController());
  final state = Get
      .find<BottomSheetChatController>()
      .state;
//标题
  String name(){
    switch (type) {
      case 1:
        if(item?['parameter'] != null){
          var parameter = jsonDecode(item?['parameter']);
          return parameter['question'].length != 0 ? parameter['question'] : '周易占卜';
        }else{
          return item?['quiz']['name'].length != 0 ? (item?['quiz']['name']) : '周易占卜';
        }
      case 2:
        if(item?['parameter'] != null){
          var parameter = jsonDecode(item?['parameter']);
          return parameter['question'].length != 0 ? parameter['question'] : '塔罗牌占卜';
        }else{
          return item?['quiz']['name'].length != 0 ? (item?['quiz']['name']) : '塔罗牌占卜';
        }
      case 3:
        return '取名';
      case 4:
        return '星座-运势';
      case 5:
        return '星座-星盘';
      case 6:
        return '星座-配对';
      case 7:
        return '运势';
      case 8:
        return '解梦';
      default:
        return '';
    }
  }
  @override
  Widget build(BuildContext context) {
    return GetBuilder<BottomSheetChatController>(
      builder: (controller) {
        return GestureDetector(
          onTap: (){
            controller.focusNode.unfocus();
          },
          child: Container(
            height: Get.height - MediaQuery
                .of(Get.context!)
                .padding
                .top,
            decoration: BoxDecoration(
              color: const Color(0xffF6F8FE),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.rpx),
                topRight: Radius.circular(20.rpx),
              ),
            ),
            child: Column(
              children: [
                topTitle(),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.only(top: 20.rpx,bottom: 20.rpx),
                    children: [
                      sendMessage(),
                      systemRecovery(),
                    ],
                  ),
                ),
                // buildBottom(),
              ],
            ),
          ),
        );
      },
    );
  }

  ///标题
  Widget topTitle() {
    return Container(
      height: 65.rpx,
      padding: EdgeInsets.only(left: 12.rpx, right: 12.rpx),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.rpx),
          topRight: Radius.circular(20.rpx),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Get.back();
            },
            child: const Icon(Icons.close, color: Color(0xff8D310F),),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(right: 24.rpx),
              child: Text(name(), style: AppTextStyle.fs18b.copyWith(color: AppColor.gray5),overflow: TextOverflow.ellipsis,),
            ),
          ),
          // AppImage.asset(
          //   "assets/images/home/chat_list.png",
          //   width: 24.rpx,
          //   height: 24.rpx,
          // ),
        ],
      ),
    );
  }

  ///发送消息
  Widget sendMessage() {
    return (item?['quiz'] != null || item?['head'] == true) ?
      Stack(
      children: [
         Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            questSelect(type,item!,)
          ],
        ),
        Positioned(
          right: 16.rpx,
          top: 10.rpx,
          child: AppImage.asset("assets/images/home/bubble_right.png",width: 6.rpx,height: 10.rpx,),
        )
      ],
    ):
      Container();
  }

  ///系统回复
  Widget systemRecovery() {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(top: 20.rpx),
          child: Row(
            children: [
              Expanded(
                child: selectWidget(type, item!,),
              )
            ],
          ),
        ),
        Positioned(
          left: 16.rpx,
          top: 30.rpx,
          child: AppImage.asset("assets/images/home/bubble_left.png",width: 6.rpx,height: 10.rpx,),
        )
      ],
    );
  }

  //1占卜 2塔罗牌 3取名 4星座-运势 5星座-星盘 6星座-配对 7运势 8解梦）
  Widget questSelect(int type,Map item){
    switch (type) {
      case 1:
        return YaoType(item: item);
      case 2:
        return TarotType(item: item);
      case 3:
        return TakeNameType(item: item);
      case 4:
        return ProblemStarType(item: item);
      case 5:
        return AstrolabeType(item: item);
      case 6:
        return PairType(item: item);
      case 7:
        return FortuneType(item: item);
      case 8:
        return DreamType(item: item);
      default:
        return Container();
    }
  }

  //1占卜 2塔罗牌 3取名 4星座-运势 5星座-星盘 6星座-配对 7运势 8解梦）
  Widget selectWidget(int type,Map item){
    switch (type) {
      case 1:
        return AnswerSixYao(item: item);
      case 2:
        return AnswerTarot(item: item);
      case 3:
        return AnswerTakeName(item: item);
      case 4:
        return AnswerStarSign(item: item);
      case 5:
        return AnswerStarAstrolabe(item: item);
      case 6:
        return AnswerStarPair(item: item);
      case 7:
        return AnswerFortune(item: item);
      case 8:
        return AnswerDream(item: item);
      default:
        return Container();
    }
  }

  ///底部聊天
  Widget buildBottom(){
    return Container(
      height: 40.rpx,
      margin: EdgeInsets.only(left: 12.rpx,right: 12.rpx,bottom: Get.mediaQuery.padding.bottom+10.rpx),
      padding: EdgeInsets.symmetric(horizontal: 12.rpx),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 40.rpx,
              child: InputWidget(
                  hintText: '想跟我聊什么',
                  fillColor: const Color(0xffFFFFFF),
                  focusNode: controller.focusNode,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.rpx),
                      bottomLeft: Radius.circular(8.rpx),
                    ),
                  ),
                  onChanged: (val) {
                    controller.chatController.text = val;
                  }
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              controller.sendMessage();
            },
            child: Container(
                padding: EdgeInsets.only(left: 4.rpx,right: 8.rpx),
                width: 100.rpx,
                height: 40.rpx,
                decoration: BoxDecoration(
                  color: Colors.white,
                  image: AppDecorations.backgroundImage("assets/images/disambiguation/rectangle.png"),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(8.rpx),
                    topRight: Radius.circular(8.rpx),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 4.rpx),
                      decoration: BoxDecoration(
                          image: AppDecorations.backgroundImage(
                              'assets/images/disambiguation/gold.png'
                          )
                      ),
                      width: 28.rpx,
                      height: 28.rpx,
                      alignment: Alignment.center,
                      child: Text("3",style: TextStyle(fontSize: 20.rpx,color: Colors.white)),
                    ),
                    Text(' 境修币',style: AppTextStyle.fs14m.copyWith(color: Colors.white,height: 1.8),),
                  ],
                )
            ),
          ),
        ],
      ),
    );
  }
}
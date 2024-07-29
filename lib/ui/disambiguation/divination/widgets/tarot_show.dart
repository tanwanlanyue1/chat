import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/ui/disambiguation/divination/divination_controller.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

///塔罗牌展示
class TarotShow extends StatefulWidget {
  final void Function()? callBack;
  TarotShow({super.key,this.callBack});

  @override
  State<TarotShow> createState() => _TarotShowState();
}

class _TarotShowState extends State<TarotShow>  with TickerProviderStateMixin{
  final state = Get.find<DivinationController>().state;
  late List<AnimationController> _controllers;
  late List<Animation<Offset>> _animations;
  final int itemCount = 8;
  int _animationCount = 0; // 动画执行次数计数器
  bool rewashing = false;
  int selectCount = 0;//选择数

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      itemCount,
          (_) => AnimationController(
        vsync: this,
        duration: const Duration(seconds: 1), // 动画持续时间
      ),
    );

    _animations = List.generate(itemCount, (index) {
      final rowIndex = index ~/ 4;
      final columnIndex = index % 4;
      const centerRowIndex = 0.5;
      const centerColumnIndex = 1.5;

      // 计算到中心点的偏移
      final dx = (centerColumnIndex - columnIndex) * 82.rpx;
      final dy = (centerRowIndex - rowIndex) * 126.rpx;

      // 使用Tween来定义开始和结束状态
      return Tween<Offset>(
        begin: Offset.zero,
        end: Offset(dx, dy),
      ).animate(
        CurvedAnimation(
          parent: _controllers[index],
          curve: Curves.easeInOut,
        ),
      );
    });

    _startAnimation();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _startAnimation() {
    if (_animationCount >= 3) {
      _animationCount = 0;
      return;
    }
    _animationCount++;
    try{
      for (var controller in _controllers) {
        controller
          ..reset()
          ..forward().whenCompleteOrCancel((){
            controller.reverse();
          });
      }
    }catch (e){
      print("e===$e");
    }
    Future.delayed(const Duration(milliseconds: 2000), () {
      if(_animationCount < 2){
        _startAnimation();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DivinationController>(
        id: 'droppedView',
        builder: (controller) {
          return Container(
            height: Get.height*0.9,
            padding: EdgeInsets.symmetric(horizontal: 12.rpx),
            decoration: BoxDecoration(
              image: AppDecorations.backgroundImage(
                'assets/images/disambiguation/tarot_background.png',
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.rpx),
                topRight: Radius.circular(20.rpx),
              ),
            ),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 20.rpx, bottom: 22.rpx),
                  child: Center(
                    child: Text(
                      "抽取塔罗牌",
                      style: TextStyle(
                          fontSize: 20.rpx, color: AppColor.gold,fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                          margin: EdgeInsets.only(left: selectCount == 3 ? 42.rpx : 0),
                          child: Text("抽取3张塔罗牌", style: TextStyle(
                              color: Colors.white, fontSize: 16.rpx),)
                      ),
                    ),
                    Visibility(
                      visible: selectCount == 3,
                      child: GestureDetector(
                        onTap: () {
                          widget.callBack?.call();
                          Get.back();
                        },
                        child: Text("下一步", style: TextStyle(
                            color:  AppColor.gold, fontSize: 14.rpx),),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 11.rpx, bottom: 20.rpx),
                  child: AppImage.asset(
                    "assets/images/disambiguation/down_white.png",
                    width: 13.rpx,
                    height: 9.rpx,
                  ),
                ),
                GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      mainAxisSpacing: 12.rpx,
                      crossAxisSpacing: 10.rpx,
                      mainAxisExtent: 126.rpx,
                    ),
                    itemCount: state.isDragging.length,
                    itemBuilder: (_, i) {
                      return GestureDetector(
                        onTap: (){
                          if(_controllers[0].status == AnimationStatus.dismissed){
                            state.isDragging[i] = true;
                            state.droppedData[selectCount]['value'] = '';
                            selectCount++;
                            controller.update(['droppedView']);
                          }
                        },
                        child: Draggable<String>(
                            data: 'assets/images/disambiguation/tarot_card.png',
                            feedback: Container(
                              width: 82.rpx,
                              height: 126.rpx,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                      'assets/images/disambiguation/tarot_card.png'),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            child: state.isDragging[i]
                                ? Container()
                                : AnimatedBuilder(
                              animation: _animations[i],
                              builder: (context, child) {
                                return Transform.translate(
                                  offset: _animations[i].value,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage('assets/images/disambiguation/tarot_card.png'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )
                        ),
                      );
                    }),
                Container(
                  margin: EdgeInsets.only(top: 20.rpx),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(state.droppedData.length, (index) =>
                        Column(
                          children: [
                            DragTarget<String>(
                              onWillAcceptWithDetails: (data) {
                                if(state.droppedData[index]['value'] != null){
                                  return false;
                                }else{
                                  return true;
                                }
                              },
                              builder: (_, candidateData, rejectedData) {
                                return state.droppedData[index]['value'] != null ?
                                Container(
                                  width: 82.rpx,
                                  height: 130.rpx,
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/disambiguation/tarot_card.png'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ) :
                                Container(
                                  width: 82.rpx,
                                  height: 130.rpx,
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/disambiguation/card_border.png'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text("${index+1}", style: TextStyle(
                                      color: const Color(0xffEEC88A),
                                      fontSize: 24.rpx)),
                                );
                              },
                            ),
                            SizedBox(height: 6.rpx,),
                            Text("${state.droppedData[index]['title']}",style: TextStyle(color: const Color(0xffEEC88A),fontSize: 14.rpx),),
                          ],
                        )),
                  ),
                ),
              ],
            ),
          );
        });
  }
}

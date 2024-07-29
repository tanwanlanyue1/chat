import 'package:flutter/material.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/app_image.dart';

//乌龟上下摇动
//callBack 摇卦
//allBack 一键摇卦
//trigram:第几爻
class ShakingContainer extends StatefulWidget {
  final List? yaoData;
  final bool? symbols;
  final String? trigram;
  final void Function()? callBack;
  final void Function()? allBack;
  const ShakingContainer({super.key, this.callBack,this.yaoData,this.trigram,this.symbols,this.allBack});

  @override
  _ShakingContainerState createState() => _ShakingContainerState();
}

class _ShakingContainerState extends State<ShakingContainer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;
  int _shakeCount = 0; // 计数器
  bool end = false;//是否结束
  bool symbols = true;//乌龟

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    _animation = Tween(begin: 0.0, end: 40.0.rpx).animate(_controller);
  }

  //设置爻
 String setHexagram(int index){
   List data = (widget.yaoData?.isNotEmpty ?? false) ? widget.yaoData?.last : [0,0,0];
   if(data[index] == 0){
     return "assets/images/disambiguation/copper_cash.png";
   }else{
     return "assets/images/disambiguation/reverse_side.png";
   }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  //开始摇卦
  void _startShaking() {
    if(_shakeCount < 2){
      _controller.forward().then((_) {
        _controller.reverse().then((_) {
          _shakeCount++;
          if (_shakeCount < 3) {
            _startShaking();
          }
        });
      });
    }else{
      _controller.stop();
      end = false;
      Future.delayed(const Duration(milliseconds: 400),(){
        symbols = false;
        widget.callBack?.call();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Visibility(
          visible: symbols,
          replacement: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(3, (index) => AppImage.asset(
              setHexagram(index),
              width: 80.rpx,
              height: 68.rpx,
            )),
          ),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.translate(
                  offset: Offset(0, _animation.value),
                  child: AppImage.asset(
                    "assets/images/home/tortoise.png",
                    width: 120.rpx,
                    height: 68.rpx,
                  )
              );
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 40.rpx),
          child: Row(
            children: [
              Expanded(
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      symbols = true;
                      if(symbols){
                        if(!end){
                          _shakeCount = 0;
                          end = true;
                          _startShaking();
                        }
                      }
                      setState(() {});
                    },
                    child: Container(
                      width: 140.rpx,
                      height: 36.rpx,
                      decoration: BoxDecoration(
                        image: AppDecorations.backgroundImage(
                            'assets/images/disambiguation/symbols.png'
                        ),
                      ),
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(left: 70.rpx),
                      child: Text(widget.trigram ?? '第一爻', style: TextStyle(
                          fontSize: 18.rpx,
                          color: const Color(0xffEEC88A),
                          fontWeight: FontWeight.bold),),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 12.rpx),
                child: GestureDetector(
                  onTap: () {
                    symbols = false;
                    widget.allBack?.call();
                  },
                  child: Text(widget.yaoData?.length != 6 ? "一键摇卦":"重新摇卦", style: TextStyle(fontSize: 14.rpx,
                      color: AppColor.gray30),),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
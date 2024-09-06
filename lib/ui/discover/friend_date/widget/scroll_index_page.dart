import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/app_image.dart';

//横向滚动，自动选择中间的
class ScrollIndexPage extends StatefulWidget {
  int currentSelectIndex;
  final Function? callBack;
  ScrollIndexPage({super.key,required this.currentSelectIndex,this.callBack});

  @override
  _ScrollIndexPageState createState() => _ScrollIndexPageState();
}

class _ScrollIndexPageState extends State<ScrollIndexPage> {
  int _currentSelectIndex = 0;
  bool first = true;

  //滑动控制器
  final ScrollController _scrollController = ScrollController();

  final List<int> data = List.generate(30, (index) => index-3);
  late double maxExtent = _scrollController.position.maxScrollExtent;
  late double threshold = maxExtent - 50.0;
  Color textColor = AppColor.black20;
  double fontSize = 14;
  final double _itemWidth = 299.rpx / 7;

  @override
  void initState() {
    super.initState();
    _currentSelectIndex = widget.currentSelectIndex;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _selectItem(0);
    });
  }

  //选中项
  void _selectItem(int index){
    if(_scrollController.hasClients){
      double offset = _scrollController.offset;
      double scrollIndex = offset / _itemWidth;
      if ((scrollIndex.round() + 3) == index) {
        fontSize = 18;
      }else{
        fontSize = 14;
      }
      if(first){
        first = false;
        _scrollController.animateTo(
          _currentSelectIndex * _itemWidth,
          duration: const Duration(milliseconds: 200),
          curve: Curves.linear,
        );
      }
    }
    setState(() {});
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildSingleChildScrollView(),
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(right: 22.rpx,top: 12.rpx),
          child: AppImage.asset('assets/images/discover/uparrow.png',width: 12.rpx,height: 12.rpx,),
        ),
      ],
    );
  }

  Widget buildSingleChildScrollView() {
    return NotificationListener<ScrollEndNotification>(
      onNotification: (ScrollNotification scrollNotification) {
        ScrollMetrics metrics = scrollNotification.metrics;
        double pixels = metrics.pixels;
        double scrollIndex = pixels / _itemWidth;
        double scrollOffset = pixels % _itemWidth;
        //当前选中
        _currentSelectIndex = scrollIndex.round();
        if(scrollOffset != 0.0){
          if(_currentSelectIndex * _itemWidth < _scrollController.position.maxScrollExtent){
            Future.delayed(Duration.zero, () {
              _scrollController.animateTo(
                _currentSelectIndex * _itemWidth,
                duration: const Duration(milliseconds: 200),
                curve: Curves.linear,
              );
            });
            widget.callBack?.call(_currentSelectIndex);
          }else{
            widget.callBack?.call(_currentSelectIndex);
          }
        }else{
          widget.callBack?.call(_currentSelectIndex);
        }
        setState(() {});
        return true;
      },
      child: Container(
        width: 300.rpx,
        foregroundDecoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.8),
              Color(0x3aFFFFFF),
              Color(0xFFFFFFFF).withOpacity(0),
              Color(0x3aFFFFFF),
              Colors.white.withOpacity(0.8),
            ],
            stops: [0, 0.3, 0.5, 0.7, 1],
          ),
        ),
        child: SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          child: Row(
            children: buildChildren(),
          ),
        ),
      ),
    );
  }

  buildChildren() {
    List<Widget> list = [];
    for (int i = 0; i < data.length; i++) {
      list.add(buildItemWidget(i));
    }
    return list;
  }

  Widget buildItemWidget(int index) {
    _selectItem(index);
    return SizedBox(
      width: _itemWidth,
      child: Visibility(
        visible: data[index] >= 0 && data[index] < 24,
        replacement: Container(width: 2.rpx,),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(right: 8.rpx),
              child: Text(
                "${data[index]}",
                style: TextStyle(
                  color: textColor,
                  fontSize: fontSize.rpx,
                ),
              ),
            ),
            AppImage.asset('assets/images/discover/wave.png',width: 12.rpx,height: 10.rpx,),
          ],
        ),
      ),
    );
  }
}

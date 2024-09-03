import 'package:flutter/material.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/text_style_extension.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

class OrderDropMenuWidget extends StatefulWidget {
  final List<Map<String, dynamic>> data; //数据
  final Function(int value) selectCallBack; //选中之后回调函数
  final int? selectedValue; //默认选中的值
  final Widget? leading; //前面的widget，一般是title
  final Widget trailing; //尾部widget，一般是自定义图片
  final Color? textColor;
  final Offset offset; //下拉框向下偏移量--手动调整间距---防止下拉框遮盖住显示的widget
  final TextStyle? normalTextStyle; //下拉框的文字样式
  final TextStyle? selectTextStyle; //下拉框选中的文字样式
  final double maxHeight; //下拉框的最大高度
  final double maxWidth; //下拉框的最大宽度
  final Color? backgroundColor; //下拉框背景颜色
  final bool animation; //是否显示动画---尾部图片动画
  final int duration; //动画时长
  const OrderDropMenuWidget({
    super.key,
    this.leading,
    required this.data,
    required this.selectCallBack,
    this.selectedValue,
    this.trailing = const Icon(Icons.arrow_drop_down),
    this.textColor = AppColor.black6,
    this.offset = const Offset(0, 44),
    this.normalTextStyle,
    this.selectTextStyle,
    this.maxHeight = 200.0,
    this.maxWidth = 200.0,
    this.backgroundColor = Colors.white,
    this.animation = true,
    this.duration = 200,
  });

  @override
  State<OrderDropMenuWidget> createState() => _OrderDropMenuWidgetState();
}

class _OrderDropMenuWidgetState extends State<OrderDropMenuWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  String _selectedLabel = '';
  int _currentValue = -1;
  // 是否展开下拉按钮
  bool _isExpand = false;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.selectedValue ?? 0;
    if (widget.animation) {
      _animationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: widget.duration),
      );
      _animation = Tween(begin: 0.0, end: 0.5).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeInOut,
        ),
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  _toggleExpand() {
    setState(() {
      if (_isExpand) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  //根据传值处理显示的文字
  _initLabel() {
    if (_currentValue != -1) {
      _selectedLabel = widget.data
          .firstWhere((item) => item['value'] == _currentValue)['label'];
    } else if (widget.data.isNotEmpty) {
      // 没值默认取第一个
      _selectedLabel = widget.data[0]['label'];
      _currentValue = widget.data[0]['value'];
    }
  }

  @override
  Widget build(BuildContext context) {
    _initLabel();
    return PopupMenuButton(
      // padding: EdgeInsets.all(18),
      shadowColor: Colors.black.withOpacity(0.5),
      constraints: BoxConstraints(
        maxHeight: widget.maxHeight,
        maxWidth: widget.maxWidth,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.rpx),
      ),
      offset: widget.offset,
      color: widget.backgroundColor,
      onOpened: () {
        if (widget.animation) {
          setState(() {
            _isExpand = true;
            _toggleExpand();
          });
        }
      },
      onCanceled: () {
        if (widget.animation) {
          setState(() {
            _isExpand = false;
            _toggleExpand();
          });
        }
      },
      child: FittedBox(
        //使用FittedBox是为了适配当字符串长度超过指定宽度的时候，会让字体自动缩小
        child: Row(
          children: [
            if (widget.leading != null) widget.leading!,
            Text(
              _selectedLabel,
              style: TextStyle(
                color: widget.textColor,
                fontWeight: FontWeight.w500,
                fontSize: 12.rpx,
              ),
            ),
            if (widget.animation)
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _animation.value * 2.0 * 3.14, // 180度对应的弧度值
                    child: widget.trailing,
                  );
                },
              ),
            if (!widget.animation) widget.trailing,
          ],
        ),
      ),
      itemBuilder: (context) {
        return widget.data.map((e) {
          return PopupMenuItem(
            height: 26.rpx,
            padding: EdgeInsets.zero,
            child: Center(
              child: Text(
                e['label'],
                style: e['value'] == _currentValue
                    ? widget.selectTextStyle ??
                        AppTextStyle.st.size(10.rpx).textColor(AppColor.primaryBlue)
                    : widget.normalTextStyle ??
                        AppTextStyle.st.size(10.rpx).textColor(AppColor.black9),
                textAlign: TextAlign.center,
                maxLines: 1,
              ),
            ),
            onTap: () {
              setState(() {
                _currentValue = e['value'];
                widget.selectCallBack(e['value']);
              });
            },
          );
        }).toList();
      },
    );
  }
}

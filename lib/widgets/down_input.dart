// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

/// 下拉选择器 支持 单选 多选操作
class DownInput extends StatefulWidget {
  final String? hitStr; //为空显示的文字
  final String? value;  //已选择内容后
  final String? dataKey;  //数据的key,默认为name
  final List? data;     // 列表数据[{'name':标题}]
  final Map? currentData;//默认选中项（单选参数 或有id即可）
  final List? currentDataList;//默认选中项（多选参数 每项有id即可）
  final Function(dynamic val)? callback;     // 事件
  final Function()? beforeClick;  //点击返回前的点击处理
  final bool more;    // 是否开启多选状态 默认单选
  final bool readOnly;    // 是否开启只读
  final Widget? iconWidget;    // 下拉图标icon
  final Color? defaultBackgroundColor;    // 默认展示的背景色
  final Color? defaultTextColor;    // 默认展示的文字颜色
  final Color? defaultIconColor;    // 默认展示的图标颜色

  const DownInput({super.key,
    this.hitStr = '请选择内容',
    this.value,
    this.data,
    this.dataKey,
    this.currentData,
    this.currentDataList,
    this.callback,
    this.beforeClick,
    this.more = false,
    this.readOnly = false,
    this.iconWidget,
    this.defaultBackgroundColor,
    this.defaultTextColor,
    this.defaultIconColor,
  });

  @override
  _DownInputState createState() => _DownInputState();
}

class _DownInputState extends State<DownInput> {

  GlobalKey? _globalKey;
  String? _hitStr;//标题背景
  String? _value;//选择后显示
  String _dataKey = 'name';//数据的key
  List _data = []; //下拉数据
  bool _more = false;//true 多选 false 单选
  Map _currentData = {}; //单选时候的内容
  List _currentDataList = [];//多选时候的内容
  Color _defaultBackgroundColor = const Color(0XFFF5F6FA); // 默认展示的背景色
  Color _defaultTextColor = const Color(0XFF45474D);// 默认展示的文字颜色
  Color _defaultIconColor = const Color(0XFF45474D);// 默认展示的文字颜色

  @override
  void initState() {

    super.initState();
    _globalKey = GlobalKey();
    _hitStr= widget.hitStr;
    _value= widget.value;
    _data = widget.data ?? [];
    _dataKey = widget.dataKey ?? _dataKey;
    _more = widget.more;
    _currentData = widget.currentData ?? _currentData;
    _currentDataList = widget.currentDataList ?? _currentDataList;
    _defaultBackgroundColor = widget.defaultBackgroundColor ?? _defaultBackgroundColor;
    _defaultTextColor = widget.defaultTextColor ?? _defaultTextColor;
    _defaultIconColor = widget.defaultIconColor ?? _defaultIconColor;
    onChange();
  }

  @override
  void didUpdateWidget(DownInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    _hitStr= widget.hitStr;
    _value= widget.value;
    _data = widget.data ?? _data;
    _dataKey = widget.dataKey ?? _dataKey;
    _more = widget.more;
    _currentData = widget.currentData ?? _currentData;
    _currentDataList = widget.currentDataList ?? _currentDataList;
    _defaultBackgroundColor = widget.defaultBackgroundColor ?? _defaultBackgroundColor;
    _defaultTextColor = widget.defaultTextColor ?? _defaultTextColor;
    _defaultIconColor = widget.defaultIconColor ?? _defaultIconColor;
    onChange();
    setState(() {});
  }

  ///判断多选还是单选的回调操作
  setList(Map val){
    if(_more){  //多选
      if(_currentDataList.contains(val)) {
        _currentDataList.remove(val);
      }else if(_currentDataList.map((e) => e.containsKey('id') && e['id']==val['id']).contains(true)){
        for(int i = 0; i < _currentDataList.length; i++){
          if(_currentDataList[i]['id'] == val['id']){
            _currentDataList.removeAt(i);
          }
        }
      } else {
        _currentDataList.add(val);
      }
      widget.callback?.call(_currentDataList);
    } else { //单选
      if(_currentData.toString() == val.toString()
          || ( _currentData.containsKey('id')
              && _currentData['id'] == val['id'])
      ) {
        _currentData = val;//不清空已选
        widget.callback?.call(_currentData);
      }else{
        _currentData = val;
        widget.callback?.call(_currentData);
      }
      Navigator.pop(context);
    }
    setState(() {});
  }

  void onChange(){
    if(_more){  //多选
      for(int i = 0; i < _currentDataList.length; i++){
        for (var item2 in _data) {
          if(_currentDataList[i].containsKey('id') && _currentDataList[i]['id'] == item2['id']){
            _currentDataList[i] = item2;
          }
        }
      }
    }
    setState(() {});
  }

  @override
  void dispose() {
    _globalKey = null;
    _currentData = {};
    _currentDataList = [];
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        width: 263.rpx,
        height: 36.rpx,
        key: _globalKey,
        decoration: BoxDecoration(
          color: _defaultBackgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(4.rpx)),
        ),
        child: Row(
          children: [
            Expanded(
                child: ScrollConfiguration(
                    behavior: OverScrollBehavior(),
                    child: ListView(
                      padding: const EdgeInsets.all(0),
                      scrollDirection:Axis.horizontal,
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        Container(
                          height: 28.rpx,
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(left: 8.rpx),
                          child: Text(
                            '${_value == null || _value == '' ? _hitStr : _value?.replaceAll("\n", " ")}',
                            style: TextStyle(
                                fontSize: 14.rpx,
                                color: _defaultTextColor
                            ),
                          ),
                        ),
                      ],
                    )
                )
            ),
            !widget.readOnly?
            (
                widget.iconWidget ??
                Container(
                  width: 25.rpx,
                  height: 28.rpx,
                  margin: EdgeInsets.only(right: 2.rpx),
                  child: Icon(Icons.expand_more,color: _defaultIconColor,),
                )
            ) :
            Container(),
          ],
        ),
      ),
      onTap: () async {
        if(widget.readOnly){
          return;
        }
        if(widget.beforeClick != null) {
          widget.beforeClick!();
        }
        if(widget.value ==null ) {
          print('未设置value---->\nvalue：选中后的内容，设置为您变量中的参数\nhitStr:默认提示',);
        }
        if(_data.isEmpty ) {
          return;
        }
        RenderBox renderBox = _globalKey!.currentContext!.findRenderObject() as RenderBox;
        Rect box = renderBox.localToGlobal(Offset.zero) & renderBox.size;
        Navigator.push(
            context,
            DropDownMenuRoute(
                position: box, //位置
                callback:(val) { setList(val); },
                data: _data, // 下拉数据
                more: _more, // 是否开启多选状态
                currentData: _currentData,
                dataKey: _dataKey,
                currentDataList: _currentDataList
            )
        );
      },
    );
  }
}
/// 获取位置
/// position：定位
/// menuHeight:渲染的高度
class DropDownMenuRouteLayout extends SingleChildLayoutDelegate {
  final Rect position;
  final double menuHeight;

  DropDownMenuRouteLayout({required this.position, required this.menuHeight});

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return BoxConstraints.loose(
        Size(position.right - position.left, menuHeight));
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    return Offset(position.left, position.bottom);
  }

  @override
  bool shouldRelayout(SingleChildLayoutDelegate oldDelegate) {
    return true;
  }
}

class DropDownMenuRoute extends PopupRoute {
  final Rect position; //出現的位置
  final double? menuHeight; //下拉顯示的高度 已设置默认 4*px（58）
  final List data; //数据
  final Map? currentData;//单选内容
  final List? currentDataList;//多选内容
  final bool more;//多选状态
  final String? dataKey;//数据key
  final callback;
  DropDownMenuRoute({
    required this.position,
    this.menuHeight,
    required this.data,
    this.currentData,
    this.currentDataList,
    this.dataKey,
    required this.more,
    this.callback
  });

  @override
  Color? get barrierColor => null;

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => null;
  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return CustomSingleChildLayout(
      delegate: DropDownMenuRouteLayout(
          position: position,
          menuHeight: menuHeight != null
              ? menuHeight!
              : data.length <= 5 ? data.length * 29.rpx + data.length.rpx : 5 * 29.rpx + 20.rpx
      ),
      child: SizeTransition(
          sizeFactor: Tween<double>(begin: 0.0, end: 1.0).animate(animation),
          child:WindowsPop(
            data: data,
            callback:  callback,
            currentData: currentData,
            currentDataList: currentDataList,
            dataKey: dataKey,
            more: more,
          )
      ),
    );
  }

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);
}

///下拉菜单样式
class WindowsPop extends StatefulWidget {
  final List data; //数据
  final Map? currentData;//单选内容
  final List? currentDataList;//多选内容
  final bool more;//多选状态
  final String? dataKey;//数据key
  final callback;
  const WindowsPop({super.key,
    required this.data,
    this.currentData,
    this.dataKey,
    this.currentDataList,
    required this.more,
    this.callback
  });
  @override
  _WindowsPopState createState() => _WindowsPopState();
}

class _WindowsPopState extends State<WindowsPop> {

  List  _data = [];
  Map _currentData = {};
  List _currentDataList = [];
  bool _more = false;
  String _dataKey = 'name';

  @override
  void initState() {

    super.initState();
    _data = widget.data;
    _dataKey = widget.dataKey ?? _dataKey;
    _currentData = widget.currentData ?? _currentData;
    _currentDataList = widget.currentDataList ?? _currentDataList;
    _more = widget.more;
  }
  @override
  void didUpdateWidget(WindowsPop oldWidget) {
    super.didUpdateWidget(oldWidget);
    _data = widget.data;
    _currentData = widget.currentData ?? _currentData;
    _currentDataList = widget.currentDataList ?? _currentDataList;
    _more = widget.more;
    _dataKey = widget.dataKey ?? _dataKey;
  }

  bool _bools(index) {
    bool _bo = false;
    if(_more) {
      if(_currentDataList.contains(_data[index])
          || _currentDataList.map((e) => e.containsKey('id') && e['id']==_data[index]['id']).contains(true)
      ) {
        _bo = true;
      }
    }else if(!_more && _currentData.toString() != '' && _currentData != {}){
      if( _currentData.toString() == _data[index].toString()
          || ( _currentData.containsKey('id') && _currentData['id'] == _data[index]['id'])
      ) {
        _bo = true;
      }
    }
    return _bo;
  }
  @override
  void dispose() {
    _currentData = {};
    _currentDataList = [];
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Container(
          decoration: BoxDecoration(
            color: const Color(0XFFFFFFFF),
            border: Border.all(width: 1.rpx,color: const Color(0X99A1A6B3)),
            borderRadius: BorderRadius.all(Radius.circular(4.rpx)),
          ),
          child: ScrollConfiguration(
              behavior: OverScrollBehavior(),
              child: ListView.builder(
                  itemCount: _data.length,
                  padding: const EdgeInsets.all(0),
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      child: Container(
                        height: 30.rpx,
                        width: double.infinity,
                        padding: EdgeInsets.only(left: 8.rpx),
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(width: 1.rpx,color: const Color(0X99A1A6B3))),
                            color: (_bools(index) ? Theme.of(context).primaryColor : Colors.transparent)
                        ),
                        child: ListView(
                          padding: const EdgeInsets.all(0),
                          scrollDirection:Axis.horizontal,
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            Container(
                              height: 29.rpx,
                              color: Colors.transparent,
                              alignment: Alignment.center,
                              child:Text(_data[index][_dataKey] !=null ?
                                  '${_data[index][_dataKey]?.replaceAll("\n", " ")}':
                                  '${_data[index]['title']?.replaceAll("\n", " ")}',
                                style: TextStyle(fontSize: 13.rpx,color: (_bools(index) ? Colors.white : Colors.black)),),
                            ),
                          ],
                        )

                      ),
                      onTap: () {
                        widget.callback(_data[index]);
                        setState(() {});
                      },
                    );
                  }
              )
          )
      ),
    );
  }
}

class OverScrollBehavior extends ScrollBehavior{
  @override
  Widget buildViewportChrome(BuildContext context, Widget child, AxisDirection axisDirection) {
    switch (getPlatform(context)) {
      case TargetPlatform.iOS: return child;
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
        return GlowingOverscrollIndicator(
          child: child,
          //不显示头部水波纹
          showLeading: false,
          //不显示尾部水波纹
          showTrailing: false,
          axisDirection: axisDirection,
          color: Colors.transparent,
        );
      case TargetPlatform.linux:
        break;
      case TargetPlatform.macOS:
        break;
      case TargetPlatform.windows:
        break;
    }
    return Container();
  }

}
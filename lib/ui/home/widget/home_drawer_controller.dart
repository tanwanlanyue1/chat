
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/auto_dispose_mixin.dart';

///主页Drawer控制器
class HomeDrawerController extends StatefulWidget {
  static final _streamController = StreamController<bool>.broadcast();

  ///打开会话抽屉
  static void open() => _streamController.add(true);

  ///关闭会话抽屉
  static void close() => _streamController.add(false);

  final Widget child;

  const HomeDrawerController({super.key, required this.child});

  @override
  State<HomeDrawerController> createState() => _HomeDrawerControllerState();
}

class _HomeDrawerControllerState extends State<HomeDrawerController> with AutoDisposeMixin{

  @override
  void initState() {
    super.initState();
    autoCancel(HomeDrawerController._streamController.stream.listen((open) {
      if(mounted){
        if(open){
          SS.login.requiredAuthorized(() async {
            Scaffold.maybeOf(context)?.openDrawer();
          });
        }else{
          Scaffold.maybeOf(context)?.closeDrawer();
        }
      }
    }));
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
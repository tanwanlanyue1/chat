import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/network/api/model/talk_model.dart';
import 'package:guanjia/common/service/service.dart';

///指定角色才显示
class RoleVisibility extends StatelessWidget {
  final bool visible;
  final Widget child;

  RoleVisibility({
    super.key,
    required List<UserType> visibleTypes,
    required UserType? type,
    required this.child,
  }): visible = visibleTypes.contains(type);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: child,
    );
  }
}


///普通用户可见
class UserVisible extends StatelessWidget {
  final Widget child;
  const UserVisible({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Obx((){
      return RoleVisibility(
        visibleTypes: const [UserType.user],
        type: SS.login.info?.type,
        child: child,
      );
    });
  }
}


///佳丽可见
class BeautyVisible extends StatelessWidget {
  final Widget child;
  const BeautyVisible({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Obx((){
      return RoleVisibility(
        visibleTypes: const [UserType.beauty],
        type: SS.login.info?.type,
        child: child,
      );
    });
  }
}

///经纪人可见
class AgentVisible extends StatelessWidget {
  final Widget child;
  const AgentVisible({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Obx((){
      return RoleVisibility(
        visibleTypes: const [UserType.agent],
        type: SS.login.info?.type,
        child: child,
      );
    });
  }
}

import 'package:flutter/material.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/order/widgets/order_security_deposit_user_dialog.dart';
import 'package:guanjia/widgets/widgets.dart';

///约会状态View（显示在消息列表顶部）
class ChatDateView extends StatefulWidget {
  final UserModel user;

  //是否来自征友页面
  final bool isFriendDate;

  const ChatDateView({
    super.key,
    required this.user,
    required this.isFriendDate,
  });

  static double get height => 66.rpx;

  @override
  State<ChatDateView> createState() => _ChatDateViewState();
}

class _ChatDateViewState extends State<ChatDateView> {
  var isFetched = false;
  OrderItemModel? order;

  ///对方用户类型
  late UserType userType;

  ///当前登录用户类型
  late UserType selfType;

  @override
  void initState() {
    super.initState();
    userType = widget.user.type;
    selfType = SS.login.userType;
    _fetchData();
  }

  void _fetchData() async {
    final response = await OrderApi.getLastByUid(otherUid: widget.user.uid);
    if (response.isSuccess) {
      setState(() {
        order = response.data;
        isFetched = true;
      });
    }
  }
  ///是否显示
  bool get isVisible {
    if (!isFetched) {
      return false;
    }

    //双方都是佳丽或者经纪人,不显示
    if (!userType.isUser && !selfType.isUser) {
      return false;
    }

    final order = this.order;
    if (order == null) {
      //订单为空，佳丽和经纪人不显示
      return selfType.isUser && !userType.isUser;
    }

    switch (order.state) {
      case OrderState.waitingAcceptance:
      case OrderState.waitingPayment:
      case OrderState.going:
        return true;
      case OrderState.finish:
      case OrderState.cancel:
        //订单已结束，佳丽和经纪人不显示
        return selfType.isUser && !userType.isUser;
    }
  }


  ///描述文本
  String get desc {
    final order = this.order;
    if (order == null) {
      return '点击右侧按钮，发起约会吧！';
    }

    switch (order.state) {
      case OrderState.waitingAcceptance:
        if(selfType.isUser){
          return '佳丽正在接单中，请您耐心等待';
        }else{
          return '当前用户向您发起了约会请求，请注意及时接单哦';
        }
      case OrderState.waitingPayment:
        if(selfType.isUser){
          if(order.requestState == OrderUserState.waitingPayment){
            return '佳丽已接单，请您及时缴纳保证金和服务费';
          }
          if(order.receiveState == OrderUserState.waitingPayment){
            return '佳丽正在缴纳保证金，请您耐心等待';
          }
          return '';

        //   switch(order.requestState){
        //     case OrderUserState.waitingPayment:
        //       return '佳丽已接单，请您及时缴纳保证金和服务费';
        //     case OrderUserState.payment:
        //       return '佳丽正在缴纳保证金，请您耐心等待';
        //     case OrderUserState.confirm:
        //     case OrderUserState.cancel:
        //       return '';
        //   }
        // }else{
        //   switch(order.requestState){
        //     case OrderUserState.waitingPayment:
        //       return '您已接单,请及时缴纳保证金';
        //     case OrderUserState.payment:
        //       return '客户正在缴纳保证金，请您耐心等待';
        //     case OrderUserState.confirm:
        //     case OrderUserState.cancel:
        //       return '';
        //   }
        // }
      case OrderState.going:
        return true;
      case OrderState.finish:
      case OrderState.cancel:
      //订单已结束，佳丽和经纪人不显示
        return selfType.isUser && !userType.isUser;
    }
    return '';
  }


  @override
  Widget build(BuildContext context) {
    if (!isVisible) {
      return Spacing.blank;
    }
    return Container(
      height: ChatDateView.height,
      color: AppColor.grayF7,
      padding: FEdgeInsets(horizontal: 16.rpx),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              '佳丽已接单，请您及时缴纳保证金服务费',
              style: AppTextStyle.fs14m.copyWith(
                color: AppColor.gray5,
              ),
            ),
          ),
          Padding(
            padding: FEdgeInsets(left: 16.rpx),
            child: CommonGradientButton(
              onTap: () => OrderSecurityDepositUserDialog.show(),
              height: 37.rpx,
              padding: FEdgeInsets(horizontal: 16.rpx),
              borderRadius: BorderRadius.zero,
              text: '立即缴纳',
              textStyle: AppTextStyle.fs14m.copyWith(color: Colors.white),
            ),
          ),
          // Padding(
          //   padding: FEdgeInsets(left: 16.rpx),
          //   child: CommonGradientButton(
          //     onTap: () => OrderAcceptDialog.show(),
          //     height: 37.rpx,
          //     padding: FEdgeInsets(horizontal: 16.rpx),
          //     borderRadius: BorderRadius.zero,
          //     text: '立即接单',
          //     textStyle: AppTextStyle.fs14m.copyWith(color: Colors.white),
          //   ),
          // ),
          // Padding(
          //   padding: FEdgeInsets(left: 16.rpx),
          //   child: CommonGradientButton(
          //     onTap: () => OrderCreateDialog.show(),
          //     height: 37.rpx,
          //     padding: FEdgeInsets(horizontal: 16.rpx),
          //     borderRadius: BorderRadius.zero,
          //     text: '立即缴纳',
          //     textStyle: AppTextStyle.fs14m.copyWith(color: Colors.white),
          //   ),
          // ),
        ],
      ),
    );
  }
}

import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/utils/auto_dispose_mixin.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/widgets.dart';
import 'chat_feature_panel.dart';

///聊天输入视图
class ChatInputView extends StatefulWidget {
  final ValueChanged<String>? onSend;
  final ValueChanged<ChatFeatureAction>? onTapFeatureAction;
  ///更多功能面板
  final List<ChatFeatureAction> featureActions;
  final ChatFeatureItemBuilder? featureItemBuilder;

  const ChatInputView({
    super.key,
    this.onSend,
    this.onTapFeatureAction,
    required this.featureActions,
    this.featureItemBuilder,
  });

  @override
  State<ChatInputView> createState() => ChatInputViewState();
}

class ChatInputViewState extends State<ChatInputView>
    with AutoDisposeMixin
    implements RouteAware {
  final focusNode = TextInputFocusNode()..ignoreSystemKeyboardShow = false;
  final textEditingController = TextEditingController();
  final contentRx = ''.obs;
  final featurePanelVisibleRx = false.obs;

  @override
  void initState() {
    super.initState();
    textEditingController.addListener(() {
      contentRx.value = textEditingController.text;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    AppPages.routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool canPop) {
        if (canPop) {
          return;
        }
        if (featurePanelVisibleRx.isTrue) {
          featurePanelVisibleRx.toggle();
        } else {
          Get.back();
        }
      },
      child: Material(
        elevation: 0,
        color: Colors.white,
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              _buildInputView(),
              _buildFeaturePanel(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputView() {
    return Container(
      padding: FEdgeInsets(left: 16.rpx, right: 8.rpx, vertical: 8.rpx),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildInput(),
          _buildFeatureIconButton(),
          _buildSendButton(),
        ],
      ),
    );
  }

  Widget _buildInput() {
    return Expanded(
      child: Container(
        constraints:
            BoxConstraints(minHeight: 40.rpx, maxHeight: Get.height * 0.25),
        decoration: BoxDecoration(
          color: AppColor.background,
          borderRadius: BorderRadius.circular(4.rpx),
        ),
        margin: FEdgeInsets(right: 4.rpx),
        child: TextField(
          onTap: () {
            if (featurePanelVisibleRx.isTrue) {
              toggleFeaturePanelVisible();
              return;
            }
            //显示键盘，隐藏表情
            focusNode.ignoreSystemKeyboardShow = false;
            focusNode.requestFocus();
          },
          focusNode: focusNode,
          controller: textEditingController,
          cursorColor: AppColor.primaryBlue,
          inputFormatters: [LengthLimitingTextInputFormatter(500)],
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.newline,
          maxLines: null,
          style: AppTextStyle.fs14m.copyWith(
            height: 1.5,
            color: AppColor.blackBlue,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            contentPadding: FEdgeInsets(horizontal: 8.rpx, vertical: 8.rpx),
            hintText: S.current.enterText,
            hintStyle: AppTextStyle.fs14m.copyWith(
              color: AppColor.grayText,
            )
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureIconButton() {
    return IconButton(
        onPressed: toggleFeaturePanelVisible,
        splashRadius: 24.rpx,
        padding: FEdgeInsets.zero,
        icon: AppImage.asset(
          'assets/images/chat/ic_chat_more_feature.png',
          width: 24.rpx,
          height: 24.rpx,
        ));
  }

  Widget _buildSendButton() {
    return ObxValue<RxString>((data) {
      final disabled = data.isEmpty;
      return IconButton(
        splashRadius: 24.rpx,
        onPressed: disabled
            ? null
            : () {
                widget.onSend?.call(data.value);
                textEditingController.clear();
              },
        icon: AppImage.asset(
          'assets/images/chat/ic_chat_send.png',
          width: 24.rpx,
          height: 24.rpx,
          color: disabled ? AppColor.blue6.withOpacity(0.5) : null,
        ),
      );
    }, contentRx);
  }

  Widget _buildFeaturePanel() {
    return ObxValue<RxBool>((data) {
      return Visibility(
        visible: data(),
        child: ChatFeaturePanel(
          onTap: (item) {
            toggleFeaturePanelVisible(requestFocus: false);
            widget.onTapFeatureAction?.call(item);
          },
          actions: widget.featureActions,
          itemBuilder: widget.featureItemBuilder,
        ),
      );
    }, featurePanelVisibleRx);
  }

  ///切换更多面板显示隐藏
  void toggleFeaturePanelVisible({bool requestFocus = true}) async {
    if (focusNode.hasFocus) {
      focusNode.unfocus();
      await Future.delayed(200.milliseconds);
    }
    focusNode.ignoreSystemKeyboardShow = featurePanelVisibleRx.isFalse;
    featurePanelVisibleRx.toggle();
    if (featurePanelVisibleRx.isFalse && requestFocus) {
      focusNode.requestFocus();
    }
  }

  @override
  void didPushNext() {
    //跳转到其他页面时，将键盘关闭，取消输入框焦点，关闭表情面板
    closePanel();
  }

  ///将键盘关闭，取消输入框焦点，关闭表情面板
  void closePanel() {
    if (focusNode.hasFocus) {
      focusNode.unfocus();
    }
    if (featurePanelVisibleRx.isTrue) {
      featurePanelVisibleRx.toggle();
    }
  }

  @override
  void dispose() {
    AppPages.routeObserver.unsubscribe(this);
    focusNode.dispose();
    textEditingController.dispose();
    super.dispose();
  }

  @override
  void didPop() {}

  @override
  void didPopNext() {}

  @override
  void didPush() {}
}

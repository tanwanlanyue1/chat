import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/generated/l10n.dart';

extension GetExtension on GetInterface {
  ///Get.arguments未map类型时，尝试获取指定key的值
  T? tryGetArgs<T>(String key) {
    if (Get.arguments is Map) {
      final value = arguments[key];
      if (value is T) {
        return value;
      }
    }
    return null;
  }

  ///Get.arguments未map类型时，获取指定key的值,如果没有则返回defaultValue
  T getArgs<T>(String key, T defaultValue) {
    if (arguments is Map) {
      final value = arguments[key];
      if (value is T) {
        return value;
      }
    }
    return defaultValue;
  }

  ///尝试查找对象，如果不存在则返回null
  T? tryFind<T>({String? tag}) {
    if (Get.isRegistered<T>(tag: tag)) {
      return Get.find<T>(tag: tag);
    }
    return null;
  }

  Future<bool?> alertDialog({
    Widget? title,
    Widget? content,
    String? cancelText,
    String? confirmText,
    VoidCallback? onCancel,
    VoidCallback? onConfirm,
  }) {
    return Get.dialog<bool>(CupertinoAlertDialog(
      title: title,
      content: content,
      actions: [
        TextButton(
          onPressed: () {
            Get.back(result: false);
            onCancel?.call();
          },
          style: TextButton.styleFrom(foregroundColor: Colors.blue),
          child: Text(cancelText ?? S.current.cancel),
        ),
        TextButton(
          onPressed: () {
            Get.back(result: true);
            onConfirm?.call();
          },
          style: TextButton.styleFrom(foregroundColor: Colors.blue),
          child: Text(confirmText ?? S.current.confirm),
        ),
      ],
    ));
  }

  void backToRoot() {
    Get.until((route) => Get.currentRoute == AppRoutes.home);
  }

  void navigateToHomeOrLogin() {
    if (SS.login.isLogin) {
      Get.offAllNamed(AppRoutes.home);
    } else {
      Get.offAllNamed(AppRoutes.loginPage);
    }
  }

  EdgeInsets get padding => mediaQuery.padding;
}

/// 全局中间件
extension GlobalMiddleware on List<GetPage> {
  List<GetPage> addMiddleware(GetMiddleware middleware) {
    return map((page) {
      return page.copy(middlewares: [
        ...?page.middlewares,
        middleware,
      ]);
    }).toList();
  }
}

///自动取消stream订阅，自动dispose controller
mixin GetAutoDisposeMixin on DisposableInterface {
  final _subscriptions = <StreamSubscription>{};
  final _changeNotifiers = <ChangeNotifier>{};
  final _workers = <Worker>{};

  ///自动取消stream订阅
  StreamSubscription<T> autoCancel<T>(StreamSubscription<T> subscription) {
    _subscriptions.add(subscription);
    return subscription;
  }

  ///自动dispose
  void autoDispose(ChangeNotifier controller) {
    _changeNotifiers.add(controller);
  }

  ///自动dispose
  void autoDisposeWorker(Worker worker) {
    _workers.add(worker);
  }

  @override
  void onClose() {
    final iterator = _subscriptions.iterator;
    while (iterator.moveNext()) {
      iterator.current.cancel();
    }
    _subscriptions.clear();

    final changeNotifiersIterator = _changeNotifiers.iterator;
    while (changeNotifiersIterator.moveNext()) {
      changeNotifiersIterator.current.dispose();
    }
    _changeNotifiers.clear();

    final workersIterator = _workers.iterator;
    while (workersIterator.moveNext()) {
      workersIterator.current.dispose();
    }
    _workers.clear();
    super.onClose();
  }
}

class ObxValue2<T1 extends RxInterface, T2 extends RxInterface>
    extends StatelessWidget {
  final Widget Function(T1, T2) builder;
  final T1 data1;
  final T2 data2;

  const ObxValue2(this.builder, this.data1, this.data2, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return builder(data1, data2);
    });
  }
}

extension TextEditingControllerX on TextEditingController {
  VoidCallback bindTextRx(RxString textRx) {
    listener() => textRx.value = text;
    addListener(listener);
    return listener;
  }
}

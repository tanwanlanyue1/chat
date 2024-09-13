import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'app_image.dart';
import 'repeat_animated_builder.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading {
  const Loading._();

  static TransitionBuilder init({TransitionBuilder? builder}) {
    EasyLoading.instance
      ..indicatorWidget = const LoadingIndicator()
      ..loadingStyle = EasyLoadingStyle.custom
      ..backgroundColor = Colors.transparent
      ..textColor = Colors.transparent
      ..indicatorColor = Colors.transparent
      ..boxShadow = [const BoxShadow(color: Colors.transparent)]
      ..userInteractions = false
      ..dismissOnTap = true;

    return EasyLoading.init(builder: builder);
  }

  static Future<void> show({String? message, bool? dismissOnTap}) {
    return EasyLoading.show(status: message, dismissOnTap: dismissOnTap);
  }

  static Future<void> dismiss() async {
    return EasyLoading.dismiss();
  }

  static Future<void> showToast(String message) async {
    if(message.isNotEmpty){
      await Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        fontSize: 16.rpx,
      );
    }
  }

  static Future<void> dismissToast() async {
    await Fluttertoast.cancel();
  }
}

class LoadingIndicator extends StatelessWidget {
  final double? size;

  const LoadingIndicator({super.key, this.size});

  @override
  Widget build(BuildContext context) {
    final size = this.size ?? 70.rpx;
    return SizedBox.square(
      dimension: size,
      child: AppImage.svga(
        'assets/images/common/loading.svga',
        width: size,
        height: size,
      ),
    );
  }
}

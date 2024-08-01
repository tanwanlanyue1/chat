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

  static Future<void> dismiss() async{
    return EasyLoading.dismiss();
  }

  static Future<void> showToast(String message) async {
    await Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      fontSize: 16.rpx,
    );
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
    const scale = 6/7;
    final size = this.size ?? 70.rpx;
    final iconSize = size * scale;
    return SizedBox.square(
      dimension: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SpinKitSpinningLines(
            color: const Color(0xFFE8DDCB),
            size: size,
          ),
          RepeatAnimatedBuilder(
            upperBound: 1.1,
            lowerBound: 0.8,
            duration: const Duration(milliseconds: 1000),
            reverse: true,
            // child: AppImage.asset(
            //   'assets/images/common/ic_loading.png',
            //   width: iconSize,
            //   height: iconSize,
            //   fit: BoxFit.contain,
            //   alignment: Alignment.center,
            // ),
            child: const SizedBox(),
            builder: (_, value, child) {
              return Transform.scale(
                scale: value,
                child: child,
              );
            },
          ),
        ],
      ),
    );
  }
}


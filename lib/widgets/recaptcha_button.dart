
import 'package:flutter/material.dart';
import 'package:flutter_recaptcha_v2_compat/flutter_recaptcha_v2_compat.dart';
import 'package:guanjia/common/app_config.dart';
import 'package:guanjia/common/utils/app_logger.dart';
import 'package:guanjia/widgets/loading.dart';

class RecaptchaButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onAction;
  const RecaptchaButton({super.key, required this.child, this.onAction});

  @override
  State<RecaptchaButton> createState() => _RecaptchaButtonState();
}

class _RecaptchaButtonState extends State<RecaptchaButton> {
  final controller = RecaptchaV2Controller();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Stack(
        children: [
          widget.child,
          RecaptchaV2(
            pluginURL: AppConfig.recaptchaWebSite,
            apiKey: AppConfig.recaptchaApiKey,
            apiSecret: AppConfig.recaptchaApiSecret,
            controller: controller,
            onVerifiedError: (msg){
              Loading.showToast(msg);
            },
            onVerifiedSuccessfully: (result){
              if(result){
                widget.onAction?.call();
              }else{
                AppLogger.w('RecaptchaV2 验证不通过');
              }
            },
          ),
        ],
      ),
    );
  }
}

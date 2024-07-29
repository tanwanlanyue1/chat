import 'package:get/get.dart';
import 'privacy_dialog.dart';
import 'welcome_state.dart';
import 'welcome_storage.dart';

class WelcomeController extends GetxController {
  final WelcomeState state = WelcomeState();

  List<String> imageList = [
    'assets/images/common/ls_welcome.png',
  ];

  int index = 0;
}

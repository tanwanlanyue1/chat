import 'package:get/get.dart';

class SpeedDatingState {
  final isAnimation = false.obs;

  var allAvatars = <String>[];
  final avatarsRx = <String>[].obs;

  int roundCount = 1;

  final avatarIndex = 0.obs;
  final isCameraOpen = true.obs;

  int orderId = 0;
}

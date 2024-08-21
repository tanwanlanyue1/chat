import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'speed_dating_controller.dart';

class SpeedDatingPage extends StatelessWidget {
  SpeedDatingPage({
    super.key,
    required this.isVideo,
  });

  final bool isVideo;

  final controller = Get.put(SpeedDatingController());
  final state = Get.find<SpeedDatingController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isVideo ? '视频速配' : '语音速配'),
      ),
      body: Container(
        child: Text('速配'),
      ),
    );
  }
}

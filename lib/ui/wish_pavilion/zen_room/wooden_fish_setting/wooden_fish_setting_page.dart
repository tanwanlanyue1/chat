import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/wish_pavilion/zen_room/wooden_fish/wooden_fish_controller.dart';
import 'package:guanjia/widgets/widgets.dart';

///木鱼设置
class WoodenFishSettingPage extends GetView<WoodenFishController> {
  const WoodenFishSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffoldBackground,
      appBar: AppBar(title: const Text('设置')),
      body: ListView(
        padding: FEdgeInsets(all: 16.rpx),
        children: <Widget>[
          buildAutoKnockOnSection(),
          // Spacing.h(10),
          // buildAudioSection(),
        ],
      ),
    );
  }

  Widget buildAutoKnockOnSection() {
    return Obx(() {
      final setting = controller.state.settingRx();
      return SettingSectionTile(
        title: const Text('自动敲击'),
        selected: setting.isAutoKnockOn,
        onChanged: (value){
          controller.state.settingRx.value = setting.copyWith(isAutoKnockOn: value);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSliderTile(
              label: '自动敲击频次（${setting.frequency.toStringAsFixed(1)}s）',
              value: setting.frequency,
              min: 0.5,
              max: 3.0,
              onChanged: (value){
                controller.state.settingRx.value = setting.copyWith(frequency: value);
              },
            ),
            // const Divider(height: 0),
            // buildSliderTile(
            //   label: '背景音乐音量（${setting.musicVolume.ceil()}）',
            //   value: setting.musicVolume,
            //   min: 0,
            //   max: 100,
            //   onChanged: (value){
            //     controller.state.settingRx.value = setting.copyWith(musicVolume: value);
            //   },
            // ),
          ],
        ),
      );
    });
  }

  Widget buildSliderTile({
    required String label,
    required double value,
    required double min,
    required double max,
    ValueChanged<double>? onChanged,
  }) {
    return SettingListTile(
      padding: FEdgeInsets(top: 12.rpx),
      title: Padding(
        padding: FEdgeInsets(horizontal: 12.rpx),
        child: Text(label),
      ),
      subtitle: Slider(
        value: value,
        min: min,
        max: max,
        onChanged: onChanged,
        thumbColor: AppColor.red1,
        activeColor: AppColor.red1,
        inactiveColor: AppColor.brown8,
      ),
    );
  }

  Widget buildAudioSection(){
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.rpx),
        color: Colors.white,
      ),
      child: Column(
        children: <Widget>[
          SettingSectionTile(
            title: const Text('木鱼音效'),
            trailing: const Text('默认音效'),
            onTap: (){},
          ),
          const Divider(height: 0),
          SettingSectionTile(
            title: const Text('僧磬音效'),
            trailing: const Text('默认音效'),
            onTap: (){},
          )
        ],
      ),
    );
  }

}

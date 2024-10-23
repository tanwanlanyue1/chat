import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/chat/custom/message_location_content.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:image_editor/image_editor.dart';

///显示消息位置
class DisplayLocationPage extends StatelessWidget {
  final MessageLocationContent content;

  const DisplayLocationPage({required this.content, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('位置'),
      ),
      body: Column(
        children: [Expanded(child: buildMap())],
      ),
    );
  }

  Future<BitmapDescriptor> getMarkerIcon() async{
    final data = await rootBundle.load('assets/images/chat/ic_chat_location.png');
    final option = ImageEditorOption();
    option.outputFormat = const OutputFormat.png();
    option.addOption(ScaleOption(
      40.px.toInt(),
      40.px ~/ (160/302),
      keepRatio: true,
    ));
    final bytes = await ImageEditor.editImage(
      image: data.buffer.asUint8List(),
      imageEditorOption: option,
    );
    return BitmapDescriptor.fromBytes(bytes!);
  }

  Widget buildMap() {
    final position = LatLng(content.latitude, content.longitude);
    return FutureBuilder(
        future: getMarkerIcon(),
        builder: (_, data) {
          return GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: position,
              zoom: 14.4746,
            ),
            markers: {
              if (data.hasData)
                Marker(
                  markerId: const MarkerId('MarkerId'),
                  anchor: const Offset(0.5, 0.5),
                  icon: data.data!,
                  position: position,
                )
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            rotateGesturesEnabled: false,
          );
        });
  }
}

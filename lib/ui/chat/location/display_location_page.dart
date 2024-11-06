import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/chat/custom/message_location_content.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:guanjia/widgets/widgets.dart';
import 'package:image_editor/image_editor.dart';

///显示消息位置
class DisplayLocationPage extends StatelessWidget {
  final MessageLocationContent content;

  const DisplayLocationPage({required this.content, super.key});

  @override
  Widget build(BuildContext context) {

    final hasPlace = content.poi.isNotEmpty || content.address.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.position),
      ),
      body: hasPlace ? Stack(
        children: [
          Column(
            children: [
              Expanded(child: buildMap()),
              buildPlace(padding: FEdgeInsets(vertical: 16.rpx)),
            ],
          ),
          Positioned.fill(
            top: null,
            bottom: 4.rpx,
            child: buildPlace(padding: FEdgeInsets(all: 16.rpx)),
          )
        ],
      ) : buildMap(),
    );
  }

  Future<BitmapDescriptor> getMarkerIcon() async {
    final data =
        await rootBundle.load('assets/images/chat/ic_chat_location.png');
    final option = ImageEditorOption();
    option.outputFormat = const OutputFormat.png();
    option.addOption(ScaleOption(
      40.px.toInt(),
      40.px ~/ (160 / 302),
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
              zoom: 16,
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

  Widget buildPlace({EdgeInsets? padding}) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(8.rpx)),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (content.poi.isNotEmpty)
            Text(
              content.poi,
              style: AppTextStyle.fs18m.copyWith(
                color: AppColor.blackBlue,
              ),
            ),
          if (content.address.isNotEmpty)
            Text(
              content.address,
              style: AppTextStyle.fs14.copyWith(
                color: AppColor.black3,
              ),
            ),
        ],
      ),
    );
  }
}

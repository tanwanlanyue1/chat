import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:guanjia/widgets/input_widget.dart';
import 'package:guanjia/widgets/upload_image.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

import 'release_dynamic_controller.dart';

///发布动态
class ReleaseDynamicPage extends StatelessWidget {
  ReleaseDynamicPage({Key? key}) : super(key: key);

  final controller = Get.put(ReleaseDynamicController());
  final state = Get.find<ReleaseDynamicController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: TabBar(
            controller: controller.tabController,
            indicatorSize: TabBarIndicatorSize.label,
            // indicatorPadding: EdgeInsets.only(bottom: 4.rpx,left: 8.rpx,right: 8.rpx),
            isScrollable: true,
            labelColor: Colors.black,
            labelStyle: TextStyle(fontSize: 14.rpx),
            unselectedLabelColor: Colors.black,
            unselectedLabelStyle: TextStyle(fontSize: 14.rpx),
            indicatorColor:Colors.black,
            indicatorWeight: 3.rpx,
            labelPadding: EdgeInsets.only(bottom: 8.rpx,right: 12.rpx),
            overlayColor: MaterialStateProperty.resolveWith((states) {
              return Colors.transparent;
            }),
            tabs: ["动态","创作"].map((item) {
              return Text("${item}");
            }).toList()
        ),
        actions: [
          Container(
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(4.rpx),
            ),
            width: 56.rpx,
            height: 12.rpx,
            margin: EdgeInsets.only(right: 12.rpx,top: 12.rpx,bottom: 12.rpx),
            child: Center(child: Text("发布",style: TextStyle(color: Colors.white),)),
          ),
        ],
      ),
      body: TabBarView(
        controller: controller.tabController,
        children: [
          buildDynamic(),
          buildDynamic(),
        ],
      ),
    );
  }

  ///动态
  Widget buildDynamic(){
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(12.rpx),
          child: InputWidget(
              hintText: '分享我近期的动态...',
              fillColor: Colors.black12,
              lines: 8,
              onChanged: (val) {
                print("val===$val");
              }
          ),
        ),
        UploadImage(
          imgList: [],
        ),
        GestureDetector(
          child: Container(
            color: Colors.red,
            child: Icon(Icons.add),
          ),
          onTap: () async{
            print("object====");
            final ImagePicker picker = ImagePicker();

            // final XFile? image = await picker.pickImage(source: ImageSource.gallery);

            final XFile? photo = await picker.pickImage(source: ImageSource.camera);

            print("object====${photo?.path}");
            // getLostData();
          },
        ),
      ],
    );
  }
  Future<void> getLostData() async {
    final ImagePicker picker = ImagePicker();
    final LostDataResponse response = await picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    final List<XFile>? files = response.files;
    print("files=====$files");
    // if (files != null) {
    //   _handleLostFiles(files);
    // } else {
    //   _handleError(response.exception);
    // }
  }
}

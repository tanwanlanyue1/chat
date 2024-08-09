import 'dart:io';
import 'package:flutter/material.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/widgets/loading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/photo_and_camera_bottom_sheet.dart';
import 'package:guanjia/widgets/photo_view_gallery_page.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

import '../common/network/api/user_api.dart';

///上传图片
///callback:回调
///closeIcon:是否开启修改
class UploadImage extends StatefulWidget {
  const UploadImage({
    super.key,
    required this.imgList,
    this.callback,
    this.closeIcon = true,
    this.url,
    this.limit,
  });

  final void Function(List<String>)? callback;
  final bool closeIcon;
  final List<String> imgList;
  final String? url;
  final int? limit; // 选择图片最大数量

  @override
  _UploadImageState createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  List<String> _imagesList = []; // 图片数组
  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    _imagesList = widget.imgList;
    super.initState();
  }

  //上传文件
  Future<void> uploadImage(List<File> images) async {

    for (var element in images) {
      final res = await UserApi.upload(filePath: element.path);

      final data = res.data;

      if (res.isSuccess && data != null) {
        _imagesList.add(data);
        setState(() {});
      }
    }
    widget.callback?.call(_imagesList);
  }

  @override
  void didUpdateWidget(covariant UploadImage oldWidget) {
    _imagesList = widget.imgList;
    super.didUpdateWidget(oldWidget);
  }

  ///选择图片或者拍照
  void selectCamera() {
    PhotoAndCameraBottomSheet.show(
      autoUpload: false,
      onTapIndex: (index) async {
        switch (index) {
          case 0:
            final List<XFile> image = await picker.pickMultiImage(
              imageQuality: 9,
              limit: widget.limit,
            );
            if (image.isNotEmpty) {
              List<File> res = [];
              for (var item in image.take(widget.limit ?? 9)) {
                res.add(File(item.path));
              }
              if(image.length > (widget.limit ?? 9)){
                Loading.showToast("最多选择${widget.limit}张图片");
              }
              uploadImage(res);
            }
            break;
          case 1:
            final XFile? photo =
                await picker.pickImage(source: ImageSource.camera);
            if (photo != null) {
              uploadImage([File(photo.path)]);
            }
            break;

          default:
            break;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: List.generate(
          widget.closeIcon ? _imagesList.length + 1 : _imagesList.length,
          (index) {
        if (index == _imagesList.length && widget.closeIcon) {
          return GestureDetector(
              onTap: () {
                selectCamera();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(width: 1.rpx,color: AppColor.gray9),
                  borderRadius: BorderRadius.circular(8.rpx),
                ),
                width: 80.rpx,
                height: 80.rpx,
                margin: EdgeInsets.only(
                  top: 8.rpx,
                ),
                alignment: Alignment.center,
                child: AppImage.asset(
                  'assets/images/mine/add_image.png',
                  width: 20.rpx,
                  height: 20.rpx,
                ),
              ));
        }
        if (_imagesList.isNotEmpty) {
          return _createGridViewItem(
              Container(
                width: 80.rpx,
                height: 80.rpx,
                margin: EdgeInsets.only(
                  right: 10.rpx,
                  top: 8.rpx,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.rpx),
                  child: AppImage.network(
                    _imagesList[index],
                    width: 80.rpx,
                    height: 80.rpx,
                  ),
                ),
              ),
              index);
        }
        return Container();
      }),
    );
  }

  ///创建GridView
  ///child：子组件
  ///index：下标
  Widget _createGridViewItem(Widget child, index) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.rpx),
        ),
        child: Stack(children: [
          InkWell(
            child: child,
            onTap: () async {
              PhotoViewGalleryPage.show(
                  context,
                  PhotoViewGalleryPage(
                    images: [],
                    index: index,
                    heroTag: '',
                  ));
            },
          ),
          if (widget.closeIcon)
            Positioned(
              top: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _imagesList.removeAt(index);
                    widget.callback?.call(_imagesList);
                  });
                },
                child: AppImage.asset(
                  'assets/images/common/ic_close_gray.png',
                  width: 16.rpx,
                  height: 16.rpx,
                ),
              ),
            )
        ]));
  }
}

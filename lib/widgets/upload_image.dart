import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/generated/l10n.dart';
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
    this.spacing,
    this.url,
    this.limit,
  });

  final void Function(List<String>)? callback;
  final bool closeIcon;
  final double? spacing;
  final List<String> imgList;
  final String? url;
  final int? limit; // 选择图片最大数量

  @override
  _UploadImageState createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  static const heroTag = 'UploadImage';
  List<String> _imagesList = []; // 图片数组
  final ImagePicker picker = ImagePicker();
  final directory = Directory.systemTemp;

  @override
  void initState() {
    _imagesList = widget.imgList;
    super.initState();
  }

  //压缩图片
  void compressAndGetFile(List<File> file) async {
    Loading.show();
    List<File> compressedList = [];
    for(var i = 0; i < file.length; i++){
      var result = await FlutterImageCompress.compressAndGetFile(
        file[i].absolute.path, '${directory.path}/$i.jpg',
        quality: 90,
        minHeight: 1920,
        minWidth: 1080,
      );
      if(result != null){
        compressedList.add(File(result.path));
      }
    }
    uploadImage(compressedList);
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
    Loading.dismiss();
    widget.callback?.call(_imagesList);
  }

  @override
  void didUpdateWidget(covariant UploadImage oldWidget) {
    _imagesList = widget.imgList;
    super.didUpdateWidget(oldWidget);
  }

  ///选择图片或者拍照
  void selectCamera() {
    int limit = widget.limit ?? 9;
    PhotoAndCameraBottomSheet.show(
      autoUpload: false,
      onTapIndex: (index) async {
        switch (index) {
          case 1:
            final List<XFile> image = await picker.pickMultiImage(
              imageQuality: 100,
              limit: widget.limit,
            );
            if (image.isNotEmpty) {
              List<File> res = [];
              for (var item in image.take(limit-_imagesList.length)) {
                res.add(File(item.path));
              }
              compressAndGetFile(res);
            }
            break;
          case 0:
            if(_imagesList.length == limit){
              Loading.showToast(S.current.chooseImageLimit(limit));
              return;
            }
            final XFile? photo =
                await picker.pickImage(source: ImageSource.camera);
            if (photo != null) {
              Loading.show();
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
      runSpacing:10.rpx,
      spacing: widget.spacing ?? 0,
      children: List.generate(
          widget.closeIcon ? _imagesList.length + 1 : _imagesList.length,
          (index) {
        if (index == _imagesList.length && widget.closeIcon) {
          return GestureDetector(
              onTap: () {
                selectCamera();
              },
              child: Container(
                margin: EdgeInsets.only(top: 9.rpx),
                child: AppImage.asset(
                  'assets/images/mine/add_image.png',
                  width: 80.rpx,
                  height: 80.rpx,
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
                    heroTag: heroTag,
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
        child: Stack(
            children: [
              InkWell(
                child: child,
                onTap: () async {
                  PhotoViewGalleryPage.show(
                    images: _imagesList,
                    index: index,
                    heroTag: heroTag,
                  );
                },
              ),
              if (widget.closeIcon)
              Positioned(
                  top: 0,
                  right: 2.rpx,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _imagesList.removeAt(index);
                        widget.callback?.call(_imagesList);
                      });
                    },
                    child: AppImage.asset(
                      'assets/images/common/ic_close_gray.png',
                      width: 18.rpx,
                      height: 18.rpx,
                    ),
                  ),
                )
            ]
        ));
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/photo_and_camera_bottom_sheet.dart';
import 'package:guanjia/widgets/photo_view_gallery_page.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

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

  final void Function(List<File>)? callback;
  final bool closeIcon;
  final List<File> imgList;
  final String? url;
  final int? limit; // 选择图片最大数量

  @override
  _UploadImageState createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  List<File> _imagesList = []; // 图片数组
  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    _imagesList = widget.imgList;
    super.initState();
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
              for (var item in image) {
                res.add(File(item.path));
              }
              _imagesList.addAll(res);
              widget.callback?.call(_imagesList);
            }
            break;
          case 1:
            final XFile? photo =
                await picker.pickImage(source: ImageSource.camera);
            if (photo != null) {
              _imagesList.add(File(photo.path));
              widget.callback?.call(_imagesList);
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
                  color: const Color(0xffF4F5F7),
                  borderRadius: BorderRadius.circular(8.rpx),
                ),
                width: 56.rpx,
                height: 56.rpx,
                margin: EdgeInsets.only(
                  top: 8.rpx,
                ),
                alignment: Alignment.center,
                child: AppImage.asset(
                  'assets/images/mine/add_image.png',
                  width: 28.rpx,
                  height: 28.rpx,
                ),
              ));
        }
        if (_imagesList.isNotEmpty) {
          return _createGridViewItem(
              Container(
                width: 56.rpx,
                height: 56.rpx,
                margin: EdgeInsets.only(
                  right: 10.rpx,
                  top: 8.rpx,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.rpx),
                  child: AppImage.file(
                    _imagesList[index],
                    width: 56.rpx,
                    height: 56.rpx,
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

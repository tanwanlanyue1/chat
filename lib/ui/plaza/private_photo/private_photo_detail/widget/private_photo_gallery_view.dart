import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/plaza/private_photo/private_photo_detail/widget/bottom_review.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../../../../../common/network/api/model/plaza/plaza_list_model.dart';
import '../../../../../widgets/photo_view_gallery_page.dart';

class PrivatePhotoGalleryView extends StatefulWidget {
  final List images;
  final int index;
  final String heroTag;
  final PlazaListModel item;

  const PrivatePhotoGalleryView(
      {super.key,
      required this.images,
      required this.index,
      required this.heroTag,
      required this.item});

  @override
  State<PrivatePhotoGalleryView> createState() =>
      _PrivatePhotoGalleryViewState();

  static void show(BuildContext context, PrivatePhotoGalleryView galleryPage) {
    Navigator.of(context).push(
      FadeRoute(
        page: galleryPage,
      ),
    );
  }
}

class _PrivatePhotoGalleryViewState extends State<PrivatePhotoGalleryView> {
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();

    _currentIndex = widget.index;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            bottom: 0,
            right: 0,
            child: Container(
              color: Colors.black,
              child: PhotoViewGallery.builder(
                scrollPhysics: const AlwaysScrollableScrollPhysics(),
                builder: (BuildContext context, int index) {
                  final item = widget.images[index] as String;
                  final isNetworkUrl = item.startsWith('http');
                  print('origin: $item');
                  print('resize: ${item.getResizeImageUrl(
                    width: Get.width,
                    height: Get.height,
                  )}');
                  return PhotoViewGalleryPageOptions(
                    minScale: PhotoViewComputedScale.contained,
                    imageProvider: isNetworkUrl
                        ? CachedNetworkImageProvider(
                            item.getResizeImageUrl(
                              width: Get.width,
                              height: Get.height,
                            ),
                          )
                        : FileImage(File(item)) as ImageProvider,
                    heroAttributes: (widget.heroTag.isNotEmpty)
                        ? PhotoViewHeroAttributes(tag: widget.heroTag)
                        : null,
                  );
                },
                gaplessPlayback: true,
                itemCount: widget.images.length,
                pageController: _pageController,
                enableRotation: false,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
            ),
          ),
          Positioned(
            top: 0,
            child: Container(
              height: 40.rpx + MediaQuery.of(context).padding.top,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              color: Colors.black.withOpacity(0.05),
            ),
          ),
          if (widget.images.length > 1)
            Positioned(
              //图片index显示
              top: MediaQuery.of(context).padding.top + 15.rpx,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Text(
                  "${_currentIndex + 1}/${widget.images.length}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.rpx,
                  ),
                ),
              ),
            ),
          Positioned(
            //右上角关闭按钮
            right: 10,
            top: MediaQuery.of(context).padding.top,
            child: IconButton(
              icon: Icon(
                Icons.close,
                size: 30.rpx,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          Positioned(
              bottom: MediaQuery.of(context).padding.bottom,
              height: 80.rpx,
              width: MediaQuery.of(context).size.width,
              child: BottomReview(
                user: false,
                item: widget.item,
              ))
        ],
      ),
    );
  }
}

//渐隐动画
class FadeRoute extends PageRouteBuilder {
  final Widget page;

  FadeRoute({required this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
}

// ignore_for_file: library_private_types_in_public_api

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

class PhotoViewGalleryPage extends StatefulWidget {
  final List<String> images;
  final int index;
  final String? heroTag;

  const PhotoViewGalleryPage({
    super.key,
    required this.images,
    required this.index,
    this.heroTag,
  });

  @override
  _PhotoViewGalleryPageState createState() => _PhotoViewGalleryPageState();

  static void show(
      {required List<String> images, int index = 0, String? heroTag}) {
    Navigator.of(Get.context!).push(
      FadeRoute(
        page: PhotoViewGalleryPage(
          images: images,
          index: index,
          heroTag: heroTag,
        ),
      ),
    );
  }
}

class _PhotoViewGalleryPageState extends State<PhotoViewGalleryPage> {
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
                  final item = widget.images[index];
                  final isNetworkUrl = item.startsWith('http');
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
                    heroAttributes: widget.heroTag != null ? PhotoViewHeroAttributes(tag: '${widget.heroTag}$item') : null,
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

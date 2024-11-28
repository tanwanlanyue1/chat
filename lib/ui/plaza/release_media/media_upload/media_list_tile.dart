import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/utils/auto_dispose_mixin.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/plaza/release_media/media_upload/media_uploader.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/widgets.dart';

import 'media_item.dart';

class MediaListTile extends StatefulWidget {
  final MediaItem item;
  final double itemSize;
  final VoidCallback? onTapDelete;

  const MediaListTile({
    super.key,
    required this.item,
    required this.itemSize,
    this.onTapDelete,
  });

  @override
  State<MediaListTile> createState() => _MediaListTileState();
}

class _MediaListTileState extends State<MediaListTile> with AutoDisposeMixin {
  UploadProgress? progress;

  @override
  void initState() {
    super.initState();
    progress = MediaUploader().getProgress(item.uuid);
    autoCancel(MediaUploader().progressStream.listen((event) {
      final value = event[item.uuid];
      if (progress != value) {
        setState(() {
          progress = value;
        });
      }
    }));
  }

  MediaItem get item => widget.item;

  @override
  void didUpdateWidget(covariant MediaListTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.item.uuid != widget.item.uuid) {
      setState(() {
        progress = MediaUploader().getProgress(item.uuid);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = this.progress;
    return GestureDetector(
      onTap: () {},
      child: Stack(
        alignment: Alignment.center,
        children: [
          buildThumbnail(
            item: item,
            size: widget.itemSize,
          ),
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: widget.onTapDelete,
              child: AppImage.asset(
                'assets/images/common/ic_close_gray.png',
                width: 18.rpx,
                height: 18.rpx,
              ),
            ),
          ),
          if (progress?.state == 0)
            SizedBox(
              width: 32.rpx,
              height: 32.rpx,
              child: CircularProgressIndicator(
                value: progress?.progress ?? 0,
              ),
            ),
          if (progress?.state == 1) buildSuccessIcon(),
          if (progress?.state == 1 && item.isVideo) buildEditButton(),
          if (progress?.state == 2)
            Icon(
              Icons.error_outline,
              color: AppColor.red,
              size: 32.rpx,
            ),
        ],
      ),
    );
  }

  Widget buildSuccessIcon() {
    if (item.isVideo) {
      return Icon(
        Icons.play_circle,
        color: AppColor.green,
        size: 32.rpx,
      );
    }
    return Icon(
      Icons.check,
      color: AppColor.green,
      size: 32.rpx,
    );
  }

  Widget buildEditButton() {
    return Positioned(
      left: 0,
      bottom: 0,
      child: Button(
        height: 32.rpx,
        borderRadius: BorderRadius.zero,
        onPressed: () {},
        padding: FEdgeInsets(horizontal: 8.rpx),
        child: Text('编辑', style: AppTextStyle.fs12),
      ),
    );
  }

  Widget buildThumbnail({
    required MediaItem item,
    required double size,
  }) {
    if (item is VideoItem) {
      item = item.cover;
    }
    if (item.local != null) {
      return AppImage.file(
        File(item.local ?? ''),
        width: size,
        height: size,
        fit: BoxFit.cover,
      );
    }
    return AppImage.network(
      item.remote ?? '',
      length: size,
      fit: BoxFit.cover,
    );
  }
}

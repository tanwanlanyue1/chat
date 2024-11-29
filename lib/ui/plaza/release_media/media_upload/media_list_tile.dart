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

import 'media_upload_view.dart';

class MediaListTile extends StatefulWidget {
  static const heroTag = 'MediaListTile';

  final MediaItem item;
  final double itemSize;
  final VoidCallback? onTap;
  final VoidCallback? onTapDelete;
  final VoidCallback? onTapEdit;
  final MediaUploader mediaUploader;

  const MediaListTile({
    super.key,
    required this.item,
    required this.itemSize,
    required this.mediaUploader,
    this.onTap,
    this.onTapDelete,
    this.onTapEdit,
  });

  @override
  State<MediaListTile> createState() => _MediaListTileState();
}

class _MediaListTileState extends State<MediaListTile> with AutoDisposeMixin {
  UploadProgress? progress;

  @override
  void initState() {
    super.initState();
    progress = widget.mediaUploader.getProgress(item.uuid);
    autoCancel(widget.mediaUploader.progressStream.listen((event) {
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
        progress = widget.mediaUploader.getProgress(item.uuid);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = this.progress;
    return GestureDetector(
      onTap: widget.onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.rpx),
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
              child: Button.icon(
                width: 20.rpx,
                height: 20.rpx,
                backgroundColor: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(8.rpx),
                  bottomLeft: Radius.circular(4.rpx),
                ),
                onPressed: widget.onTapDelete,
                icon: AppImage.asset(
                  'assets/images/plaza/ic_mini_close.png',
                  size: 16.rpx,
                ),
              ),
            ),
            if (item.isVideo)
              AppImage.asset(
                'assets/images/plaza/ic_play.png',
                size: 28.rpx,
              ),
            if (progress?.state == 0) buildProgress(),
            if (progress?.state == 1 && item.isVideo) buildEditButton(),
            if (progress?.state == 2)
              Positioned(
                right: 0,
                bottom: 0,
                child: Button.icon(
                  onPressed: () {
                    Loading.showToast('上传失败，请重新上传');
                  },
                  height: 32.rpx,
                  padding: FEdgeInsets(all: 8.rpx),
                  icon: Icon(
                    Icons.error,
                    color: AppColor.red,
                    size: 16.rpx,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildProgress() {
    var value = progress?.progress ?? 0;

    //视频上传进度+封面上传进度
    if (item.isVideo) {
      final coverUuid = (item as VideoItem).cover.uuid;
      final coverProgress =
          widget.mediaUploader.getProgress(coverUuid)?.progress ?? 0;
      value = (value + coverProgress) / 2;
    }

    return Positioned.fill(
      child: Transform.scale(
        scaleY: 1 - value,
        alignment: Alignment.bottomCenter,
        child: ColoredBox(
          color: Colors.black.withOpacity(0.3),
        ),
      ),
    );
  }

  Widget buildEditButton() {
    return Positioned(
      left: 0,
      bottom: 0,
      child: GestureDetector(
        onTap: widget.onTapEdit,
        behavior: HitTestBehavior.translucent,
        child: Container(
          margin: FEdgeInsets(bottom: 8.rpx),
          padding: FEdgeInsets(left: 4.rpx, right: 6.rpx),
          height: 16.rpx,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.horizontal(right: Radius.circular(8.rpx)),
            color: Colors.black.withOpacity(0.4),
          ),
          child: Text('编辑', style: AppTextStyle.fs10.copyWith(color: Colors.white, height: 1)),
        ),
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
        heroTag: MediaListTile.heroTag,
      );
    }
    return AppImage.network(
      item.remote ?? '',
      length: size,
      fit: BoxFit.cover,
      heroTag: MediaListTile.heroTag,
    );
  }
}

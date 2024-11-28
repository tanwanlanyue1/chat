
class ImageItem extends MediaItem {
  ImageItem({
    required super.uuid,
    super.local,
    super.remote,
  }) : super(isVideo: false);
}

class VideoItem extends MediaItem {
  final ImageItem cover;
  final Duration duration;

  VideoItem({
    required this.cover,
    required this.duration,
    required super.uuid,
    super.local,
    super.remote,
  }) : super(isVideo: true);
}

abstract class MediaItem {
  final String uuid;
  final bool isVideo;
  final String? local;
  String? remote;

  MediaItem({
    required this.isVideo,
    required this.uuid,
    this.local,
    this.remote,
  });
}

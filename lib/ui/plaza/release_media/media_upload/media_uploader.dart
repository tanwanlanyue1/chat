import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:guanjia/common/extension/functions_extension.dart';
import 'package:guanjia/common/network/api/api.dart';

import 'media_upload_view.dart';

///媒体上传
class MediaUploader {
  static final instance = MediaUploader._();

  MediaUploader._();

  factory MediaUploader() => instance;

  final _streamController =
      StreamController<Map<String, UploadProgress>>.broadcast();

  ///上传进度流
  Stream<Map<String, UploadProgress>> get progressStream =>
      _streamController.stream;

  ///上传进度Map<uuid,progress>
  final _progressMap = <String, UploadProgress>{};

  ///取消上传
  final _cancelTokenMap = <String, CancelToken>{};

  ///获取上传进度
  UploadProgress? getProgress(String uuid) {
    return _progressMap[uuid];
  }

  ///批量上传
  void uploads(List<MediaItem> items) {
    for (var element in items) {
      _upload(element);
      if (element is VideoItem) {
        _upload(element.cover);
      }
    }
  }

  void _upload(final MediaItem item) {
    final uuid = item.uuid;
    final local = item.local;
    final remote = item.remote;
    if (local != null && remote == null && !_progressMap.containsKey(uuid)) {
      final cancelToken = CancelToken();
      _progressMap[item.uuid] = UploadProgress(
        uuid: uuid,
        progress: 0,
        state: 0,
      );
      _cancelTokenMap[item.uuid] = cancelToken;
      _streamController.add(_progressMap);
      UserApi.upload(
        filePath: local,
        cancelToken: cancelToken,
        onSendProgress: (int count, int total) {
          final value = _progressMap[uuid];
          if (value == null) {
            return;
          }
          //进度每走 1% 通知一次
          final progress = count / total;
          if ((progress * 100).toInt() != (value.progress * 100).toInt()) {
            _progressMap[uuid] = value.copyWith(progress: progress);
            _streamController.add(_progressMap);
          }
        },
      ).then((response) {
        var value = _progressMap[uuid];
        if (value == null) {
          return;
        }
        if (response.isSuccess) {
          value = value.copyWith(
            progress: 1,
            url: response.data,
            state: 1,
          );
        } else {
          value = value.copyWith(state: 2);
        }
        _progressMap[uuid] = value;
        _streamController.add(_progressMap);
      }).whenComplete(() => _cancelTokenMap.remove(uuid));
    }
  }

  ///取消上传
  void cancel(String uuid) {
    _cancelTokenMap.remove(uuid)?.cancel('user cancel upload');
    _progressMap.remove(uuid);
  }

  ///取消所有上传
  void cancelAll() {
    List.of(_cancelTokenMap.keys).forEach(cancel);
  }
}

class UploadProgress extends Equatable {
  final String uuid;

  ///进度0-1
  final double progress;

  ///上传成功后的url
  final String? url;

  ///状态 0进行中，1成功，2失败
  final int state;

  const UploadProgress({
    required this.uuid,
    required this.progress,
    this.url,
    required this.state,
  });

  UploadProgress copyWith({
    String? uuid,
    double? progress,
    String? url,
    int? state,
  }) {
    return UploadProgress(
      uuid: uuid ?? this.uuid,
      progress: progress ?? this.progress,
      url: url ?? this.url,
      state: state ?? this.state,
    );
  }

  @override
  List<Object?> get props => [
    uuid,
    progress,
    url,
    state,
  ];

  @override
  String toString() {
    return 'UploadProgress{uuid: $uuid, progress: $progress, url: $url, state: $state}';
  }
}

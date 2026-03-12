import 'package:flutter/material.dart';
import 'package:video_store/features/features.dart';

class FeedViewModel extends ChangeNotifier {
  final GetVideosUseCase _getVideos;
  final AddVideoUseCase _addVideo;
  final ToggleFavoriteUseCase _toggleFavorite;

  List<VideoEntity> videos = [];
  bool isLoading = false;

  FeedViewModel(
    this._getVideos,
    this._addVideo,
    this._toggleFavorite,
  );

  Future<void> loadVideos() async {
    isLoading = true;
    notifyListeners();

    videos = await _getVideos();

    isLoading = false;
    notifyListeners();
  }

  Future<void> addVideo(String path) async {
    await _addVideo(path);
    await loadVideos();
  }

  Future<void> toggleFavorite(String videoId) async {
    await _toggleFavorite(videoId);

    final index = videos.indexWhere((v) => v.id == videoId);
    if (index != -1) {
      videos[index] = VideoEntity(
        id: videos[index].id,
        videoUrl: videos[index].videoUrl,
        isFavorite: !videos[index].isFavorite,
      );
      notifyListeners();
    }
  }
}
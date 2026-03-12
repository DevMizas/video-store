import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:video_store/features/features.dart';

class GridViewModel extends ChangeNotifier {
  final GetVideosUseCase _getVideosUseCase = GetIt.I<GetVideosUseCase>();

  List<VideoEntity> videos = [];
  bool isLoading = false;

  Future<void> loadVideos() async {
    isLoading = true;
    notifyListeners();

    videos = await _getVideosUseCase();

    isLoading = false;
    notifyListeners();
  }
}

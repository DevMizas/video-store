import 'package:flutter/foundation.dart';
import 'package:video_store/features/features.dart';

class FeedViewModel extends ChangeNotifier {
  final GetVideosUseCase _getVideos;
  final AddVideoUseCase _addVideo;
  final ToggleFavoriteUseCase _toggleFavorite;

  List<VideoEntity> _videos = [];
  List<VideoEntity> get videos => List.unmodifiable(_videos);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _hasError = false;
  bool get hasError => _hasError;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  FeedViewModel({
    required GetVideosUseCase getVideos,
    required AddVideoUseCase addVideo,
    required ToggleFavoriteUseCase toggleFavorite,
  })  : _getVideos = getVideos,
        _addVideo = addVideo,
        _toggleFavorite = toggleFavorite;

  Future<void> loadVideos() async {
    if (_isLoading) return;

    _isLoading = true;
    _hasError = false;
    _errorMessage = null;
    notifyListeners();

    try {
      _videos = await _getVideos();
    } catch (e, stack) {
      _hasError = true;
      _errorMessage = 'Falha ao carregar vídeos: $e';
      debugPrint('Erro em loadVideos: $e\n$stack');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addVideo(String path) async {
    try {
      await _addVideo(path);
      await loadVideos();
    } catch (e) {
      _errorMessage = 'Falha ao adicionar vídeo: $e';
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(String videoId) async {
    try {
      await _toggleFavorite(videoId);

      final index = _videos.indexWhere((v) => v.id == videoId);
      if (index != -1) {
        final oldVideo = _videos[index];
        _videos[index] = VideoEntity(
          id: oldVideo.id,
          videoUrl: oldVideo.videoUrl,
          isFavorite: !oldVideo.isFavorite,
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Erro ao alternar favorito: $e');
    }
  }

  void reset() {
    _videos.clear();
    _isLoading = false;
    _hasError = false;
    _errorMessage = null;
    notifyListeners();
  }
}

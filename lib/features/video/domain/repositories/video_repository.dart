import 'package:video_store/features/features.dart';

abstract class VideoRepository {
  Future<List<VideoEntity>> getAllVideos();
  Future<void> addVideo(String filePath);
  Future<void> toggleFavorite(String id);
  Future<List<VideoEntity>> getFavorites();
}

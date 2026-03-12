import 'package:video_store/features/features.dart';

class VideoRepositoryImpl implements VideoRepository {
  final LocalVideoDataSource _dataSource;

  VideoRepositoryImpl(this._dataSource);

  @override
  Future<List<VideoEntity>> getAllVideos() => _dataSource.getAllVideos();

  @override
  Future<void> addVideo(String filePath) => _dataSource.addVideo(filePath);

  @override
  Future<void> toggleFavorite(String id) => _dataSource.toggleFavorite(id);

  @override
  Future<List<VideoEntity>> getFavorites() => _dataSource.getFavorites();
}

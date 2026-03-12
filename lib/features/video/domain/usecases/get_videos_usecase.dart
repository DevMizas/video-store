import 'package:video_store/features/features.dart';

class GetVideosUseCase {
  final VideoRepository repository;
  GetVideosUseCase(this.repository);
  Future<List<VideoEntity>> call() => repository.getAllVideos();
}

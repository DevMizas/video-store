import 'package:video_store/features/features.dart';

class GetFavoritesUseCase {
  final VideoRepository repository;
  GetFavoritesUseCase(this.repository);
  Future<List<VideoEntity>> call() => repository.getFavorites();
}

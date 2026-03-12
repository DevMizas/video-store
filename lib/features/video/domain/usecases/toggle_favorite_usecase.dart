import 'package:video_store/features/features.dart';

class ToggleFavoriteUseCase {
  final VideoRepository repository;
  ToggleFavoriteUseCase(this.repository);
  Future<void> call(String id) => repository.toggleFavorite(id);
}

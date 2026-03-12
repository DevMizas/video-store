import 'package:video_store/features/features.dart';

class AddVideoUseCase {
  final VideoRepository repository;
  AddVideoUseCase(this.repository);
  Future<void> call(String filePath) => repository.addVideo(filePath);
}
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:video_store/features/features.dart';

import 'get_videos_usecase_test.mocks.dart';

@GenerateMocks([VideoRepository])
void main() {
  late GetVideosUseCase usecase;
  late MockVideoRepository mockRepository;

  setUp(() {
    mockRepository = MockVideoRepository();
    usecase = GetVideosUseCase(mockRepository);
  });

  final tVideos = [
    VideoEntity(id: '1', videoUrl: 'path1.mp4', isFavorite: false),
    VideoEntity(id: '2', videoUrl: 'path2.mp4', isFavorite: true),
  ];

  test('deve retornar lista de vídeos do repositório', () async {
    // arrange
    when(mockRepository.getAllVideos()).thenAnswer((_) async => tVideos);

    // act
    final result = await usecase();

    // assert
    expect(result, equals(tVideos));
    verify(mockRepository.getAllVideos()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}

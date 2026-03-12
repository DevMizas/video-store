import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:video_player/video_player.dart';
import 'package:mockito/mockito.dart';
import 'package:video_store/features/features.dart';

class MockVideoPlayerController extends Mock implements VideoPlayerController {}

void main() {
  late MockVideoPlayerController mockController;

  setUp(() {
    mockController = MockVideoPlayerController();
  });

  testWidgets('VideoTile deve mostrar CircularProgressIndicator enquanto não inicializado', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: VideoTile(
            video: VideoEntity(id: 'test', videoUrl: 'fake.mp4', isFavorite: false),
          ),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  // Teste mais avançado requer mock do VideoPlayerController real (mais complexo)
}

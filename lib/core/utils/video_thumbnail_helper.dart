import 'dart:typed_data';
import 'package:video_thumbnail/video_thumbnail.dart';

Future<Uint8List?> generateVideoThumbnail(String videoPath, {int timeMs = 0}) async {
  try {
    final uint8list = await VideoThumbnail.thumbnailData(
      video: videoPath,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 200,
      quality: 50,
      timeMs: timeMs,
    );
    return uint8list;
  } catch (e) {
    print('Erro ao gerar thumbnail: $e');
    return null;
  }
}

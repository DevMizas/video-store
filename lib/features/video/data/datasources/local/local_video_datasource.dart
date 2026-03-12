import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:video_store/core/core.dart';
import 'package:video_store/features/features.dart';

class LocalVideoDataSource {
  final _uuid = const Uuid();

  Future<String> get _videosDir async {
    final appDir = await getApplicationDocumentsDirectory();
    final dir = Directory('${appDir.path}/${AppConstants.videosFolder}');
    await dir.create(recursive: true);
    return dir.path;
  }

  Future<List<VideoEntity>> getAllVideos() async {
    final dir = Directory(await _videosDir);
    final files = dir.listSync().whereType<File>().where((f) => f.path.endsWith('.mp4'));
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(AppConstants.favoritesKey) ?? [];

    return files.map((f) {
      final id = f.path.split('/').last.replaceAll('.mp4', '');
      return VideoEntity(
        id: id,
        videoUrl: f.path,
        isFavorite: favorites.contains(id),
      );
    }).toList();
  }

  Future<void> addVideo(String originalPath) async {
    final dirPath = await _videosDir;
    final newPath = '$dirPath/${_uuid.v4()}.mp4';
    await File(originalPath).copy(newPath);
  }

  Future<void> toggleFavorite(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(AppConstants.favoritesKey) ?? [];
    if (favorites.contains(id)) {
      favorites.remove(id);
    } else {
      favorites.add(id);
    }
    await prefs.setStringList(AppConstants.favoritesKey, favorites);
  }

  Future<List<VideoEntity>> getFavorites() async {
    final all = await getAllVideos();
    return all.where((v) => v.isFavorite).toList();
  }
}

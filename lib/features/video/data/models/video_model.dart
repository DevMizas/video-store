class VideoModel {
  final String id;
  final String videoUrl;
  bool isFavorite;

  VideoModel({
    required this.id,
    required this.videoUrl,
    this.isFavorite = false,
  });
}

class VideoDto {
  final String id;
  final String videoUrl;
  bool isFavorite;

  VideoDto({
    required this.id,
    required this.videoUrl,
    this.isFavorite = false,
  });
}

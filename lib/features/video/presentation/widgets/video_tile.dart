import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';
import '../../domain/entities/video_entity.dart';
import '../viewmodels/feed_viewmodel.dart';

class VideoTile extends StatefulWidget {
  final VideoEntity video;
  final bool autoPlay;

  const VideoTile({
    super.key,
    required this.video,
    this.autoPlay = true,
  });

  @override
  State<VideoTile> createState() => _VideoTileState();
}

class _VideoTileState extends State<VideoTile> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _isPlaying = true;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  Future<void> _initController() async {
    _controller = VideoPlayerController.file(File(widget.video.videoUrl));

    try {
      await _controller.initialize();
      _controller.setLooping(true);

      if (widget.autoPlay && mounted) {
        await _controller.play();
        _isPlaying = true;
      }

      if (mounted) {
        setState(() => _isInitialized = true);
      }
    } catch (e) {
      debugPrint('Erro ao inicializar vídeo: $e');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return Container(
        color: Colors.black,
        child: const Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    return Consumer<FeedViewModel>(
      builder: (context, viewModel, child) {
        final currentVideo = viewModel.videos.firstWhere(
          (v) => v.id == widget.video.id,
          orElse: () => widget.video,
        );

        return Stack(
          fit: StackFit.expand,
          children: [
            Container(
              color: Colors.black,
              child: Center(
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: SizedBox(
                      width: _controller.value.size.width,
                      height: _controller.value.size.height,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isPlaying = !_isPlaying;
                  _isPlaying ? _controller.play() : _controller.pause();
                });
              },
              child: _isPlaying
                  ? null
                  : const Center(
                      child: Icon(
                        Icons.play_circle_fill,
                        size: 80,
                        color: Colors.white70,
                      ),
                    ),
            ),
            Positioned(
              top: 40,
              right: 16,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(
                    currentVideo.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: currentVideo.isFavorite ? Colors.red : Colors.white,
                    size: 32,
                  ),
                  onPressed: () {
                    viewModel.toggleFavorite(widget.video.id);
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

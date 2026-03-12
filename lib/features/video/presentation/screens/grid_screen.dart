import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:video_store/core/core.dart';
import 'package:video_store/features/features.dart';

class GridScreen extends StatefulWidget {
  const GridScreen({super.key});

  @override
  State<GridScreen> createState() => _GridScreenState();
}

class _GridScreenState extends State<GridScreen> {
  final vm = GetIt.I<GridViewModel>();

  @override
  void initState() {
    super.initState();
    vm.loadVideos();
  }

  Widget _fallbackPlaceholder() {
    return Container(
      color: Colors.grey[900],
      child: const Center(
        child: Icon(Icons.videocam_off, size: 50, color: Colors.white54),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50),
      child: ListenableBuilder(
        listenable: vm,
        builder: (context, _) {
          if (vm.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (vm.videos.isEmpty) {
            return const Center(child: Text('Nenhum vídeo adicionado ainda'));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
              childAspectRatio: 9 / 16,
            ),
            itemCount: vm.videos.length,
            itemBuilder: (_, i) {
              final video = vm.videos[i];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Scaffold(
                        backgroundColor: const Color.fromARGB(0, 0, 0, 0),
                        body: Stack(
                          children: [
                            VideoTile(video: video),
                            Positioned(
                              top: 40,
                              left: 16,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(0, 0, 0, 0.5),
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                    size: 32,
                                  ),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                child: FutureBuilder<Uint8List?>(
                  future: generateVideoThumbnail(video.videoUrl),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        color: Colors.grey[900],
                        child: const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                      );
                    }

                    if (snapshot.hasData && snapshot.data != null) {
                      return Image.memory(
                        snapshot.data!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _fallbackPlaceholder(),
                      );
                    }

                    return _fallbackPlaceholder();
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

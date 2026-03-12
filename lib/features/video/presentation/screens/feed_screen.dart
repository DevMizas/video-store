import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:video_store/features/features.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final vm = GetIt.I<FeedViewModel>();

  @override
  void initState() {
    super.initState();
    vm.loadVideos();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FeedViewModel>.value(
      value: vm,
      child: Consumer<FeedViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.videos.isEmpty) {
            return const Center(
              child: Text(
                'Nenhum vídeo ainda\nToque em + para adicionar',
                textAlign: TextAlign.center,
              ),
            );
          }

          return PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: viewModel.videos.length,
            itemBuilder: (context, index) {
              return VideoTile(video: viewModel.videos[index]);
            },
          );
        },
      ),
    );
  }
}

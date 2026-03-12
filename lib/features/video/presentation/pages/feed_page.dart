import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:video_store/features/features.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
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
          if (vm.isLoading) return const Center(child: CircularProgressIndicator());
          if (vm.hasError) return Center(child: Text(vm.errorMessage ?? 'Erro desconhecido'));
          if (vm.videos.isEmpty) return const Center(child: Text('Nenhum vídeo ainda'));

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

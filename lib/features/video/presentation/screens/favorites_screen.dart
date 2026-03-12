import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:video_store/features/features.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final vm = GetIt.I<FavoritesViewModel>();

  @override
  void initState() {
    super.initState();
    vm.loadFavorites();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    vm.loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: vm,
      builder: (context, _) {
        if (vm.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (vm.favorites.isEmpty) {
          return const Center(
            child: Text(
              'Nenhum favorito ainda.\nMarque vídeos como favoritos no feed.',
              textAlign: TextAlign.center,
            ),
          );
        }

        return PageView.builder(
          scrollDirection: Axis.vertical,
          itemCount: vm.favorites.length,
          itemBuilder: (context, index) {
            return VideoTile(video: vm.favorites[index]);
          },
        );
      },
    );
  }
}

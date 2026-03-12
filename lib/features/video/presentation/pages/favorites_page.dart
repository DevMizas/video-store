import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:video_store/features/features.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
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
    return ChangeNotifierProvider<FeedViewModel>.value(
      value: GetIt.I<FeedViewModel>(),
      child: Consumer<FeedViewModel>(
        builder: (context, vm, child) {
          if (vm.isLoading) return const Center(child: CircularProgressIndicator());

          final favorites = vm.videos.where((v) => v.isFavorite).toList();

          if (favorites.isEmpty) {
            return const Center(child: Text('Nenhum favorito ainda'));
          }

          return PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: favorites.length,
            itemBuilder: (context, index) => VideoTile(video: favorites[index]),
          );
        },
      ),
    );
  }
}

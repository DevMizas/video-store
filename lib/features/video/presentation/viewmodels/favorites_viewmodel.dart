import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:video_store/features/features.dart';

class FavoritesViewModel extends ChangeNotifier {
  final GetFavoritesUseCase _getFavoritesUseCase = GetIt.I<GetFavoritesUseCase>();

  List<VideoEntity> favorites = [];
  bool isLoading = false;

  Future<void> loadFavorites() async {
    isLoading = true;
    notifyListeners();

    favorites = await _getFavoritesUseCase();

    isLoading = false;
    notifyListeners();
  }
}

import 'package:get_it/get_it.dart';
import '../features/video/video.dart';

final GetIt getIt = GetIt.instance;

void setupInjection() {
  // Data Sources
  getIt.registerLazySingleton<LocalVideoDataSource>(
    () => LocalVideoDataSource(),
  );

  // Repositories
  getIt.registerLazySingleton<VideoRepository>(
    () => VideoRepositoryImpl(getIt<LocalVideoDataSource>()),
  );

  // Use Cases
  getIt.registerLazySingleton<GetVideosUseCase>(
    () => GetVideosUseCase(getIt<VideoRepository>()),
  );
  getIt.registerLazySingleton<AddVideoUseCase>(
    () => AddVideoUseCase(getIt<VideoRepository>()),
  );
  getIt.registerLazySingleton<ToggleFavoriteUseCase>(
    () => ToggleFavoriteUseCase(getIt<VideoRepository>()),
  );
  getIt.registerLazySingleton<GetFavoritesUseCase>(
    () => GetFavoritesUseCase(getIt<VideoRepository>()),
  );

  // ViewModels
  getIt.registerLazySingleton<FeedViewModel>(
    () => FeedViewModel(
      getVideos: getIt<GetVideosUseCase>(),
      addVideo: getIt<AddVideoUseCase>(),
      toggleFavorite: getIt<ToggleFavoriteUseCase>(),
    ),
  );

  getIt.registerLazySingleton<GridViewModel>(() => GridViewModel());

  getIt.registerLazySingleton<FavoritesViewModel>(() => FavoritesViewModel());
}

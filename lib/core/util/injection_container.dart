import 'package:bai5_bloc_dio/features/story/data/data_sources/local/story_local_datasource.dart';
import 'package:bai5_bloc_dio/features/story/data/data_sources/remote/story_api_service.dart';
import 'package:bai5_bloc_dio/features/story/data/repository/story_repository_impl.dart';
import 'package:bai5_bloc_dio/features/story/domain/repository/story_repository.dart';
import 'package:bai5_bloc_dio/features/story/domain/usecases/delete_local_story.dart';
import 'package:bai5_bloc_dio/features/story/domain/usecases/get_local_story.dart';
import 'package:bai5_bloc_dio/features/story/domain/usecases/get_story.dart';
import 'package:bai5_bloc_dio/features/story/domain/usecases/save_story.dart';
import 'package:bai5_bloc_dio/features/story/presentation/bloc/story/remote/remote_story_bloc.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  sl.registerSingleton<Dio>(Dio());

  sl.registerSingleton<StoryApiService>(StoryApiServiceImpl(dio: sl()));
  sl.registerSingleton(DatabaseHelper());

  sl.registerLazySingleton<StoryRepository>(
      () => StoryRepositoryImpl(sl(), sl()));

  sl.registerLazySingleton(() => GetStoryUsecase(sl()));

  sl.registerLazySingleton(() => GetLocalStoryUseCase(sl()));
  sl.registerLazySingleton(() => DeleteLocalStoryUseCase(sl()));
  sl.registerLazySingleton(() => SaveStoryUseCase(sl()));

  sl.registerFactory(() => RemoteStoryBloc(sl(), sl(), sl(), sl()));
}

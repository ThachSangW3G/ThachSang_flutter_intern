import 'dart:async';

import 'package:bai5_bloc_dio/core/resources/data_state.dart';
import 'package:bai5_bloc_dio/features/story/domain/usecases/delete_local_story.dart';
import 'package:bai5_bloc_dio/features/story/domain/usecases/get_local_story.dart';
import 'package:bai5_bloc_dio/features/story/domain/usecases/get_story.dart';
import 'package:bai5_bloc_dio/features/story/domain/usecases/save_story.dart';
import 'package:bai5_bloc_dio/features/story/presentation/bloc/story/remote/remote_story_event.dart';
import 'package:bai5_bloc_dio/features/story/presentation/bloc/story/remote/remote_story_state.dart';
import 'package:bai5_bloc_dio/core/util/internet_connect.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RemoteStoryBloc extends Bloc<RemoteStoriyEvent, RemoteStoryState> {
  final GetStoryUsecase _getStoryUsecase;
  final DeleteLocalStoryUseCase _deleteLocalStoryUseCase;
  final SaveStoryUseCase _saveStoryUseCase;
  final GetLocalStoryUseCase _getLocalStoryUseCase;
  int _page = 1;

  RemoteStoryBloc(this._getStoryUsecase, this._deleteLocalStoryUseCase,
      this._saveStoryUseCase, this._getLocalStoryUseCase)
      : super(RemoteStoryState.initial()) {
    on<GetStories>(onGetStories);
  }

  Future<void> onGetStories(
      GetStories event, Emitter<RemoteStoryState> emit) async {
    try {
      emit(state.copyWith(isLoading: true));
      if (await InternetConnect().isInternetConnected()) {
        final dataState = await _getStoryUsecase(_page++);
        if (dataState is DataSuccess && dataState.data!.isNotEmpty) {
          emit(state.copyWith(
              stories: [...state.stories, ...dataState.data!],
              isLoading: false,
              isLoadedLocal: false));
        }
        await _deleteLocalStoryUseCase();

        await _saveStoryUseCase(params: dataState.data!);
      } else {
        if (!state.isLoadedLocal) {
          final dataState = await _getLocalStoryUseCase();
          if (dataState is DataSuccess && dataState.data!.isNotEmpty) {
            emit(state.copyWith(
                stories: [...state.stories, ...dataState.data!],
                isLoading: false,
                isLoadedLocal: true));
          }
        } else {
          emit(state.copyWith(isLoading: false));
        }
      }
    } on DioException catch (e) {
      emit(state.copyWith(isLoading: false, error: e.message));
    }
  }
}

import 'package:bai5_bloc_dio/blocs/story_bloc/story_event.dart';
import 'package:bai5_bloc_dio/blocs/story_bloc/story_state.dart';
import 'package:bai5_bloc_dio/database/database.dart';
import 'package:bai5_bloc_dio/models/story_model.dart';
import 'package:bai5_bloc_dio/repositories/story_repository.dart';
import 'package:bai5_bloc_dio/services/internet_connect.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StoryBloc extends Bloc<StoryEvent, StoryState> {
  final StoryRepository storyRepository;
  final ScrollController scrollController;
  final DatabaseHelper dbHelper = DatabaseHelper();
  int _currentPage = 1;

  StoryBloc({required this.storyRepository, required this.scrollController})
      : super(StoryState.initial()) {
    scrollController.addListener(_onScroll);

    on<GetStories>(getStories);

    add(GetStories());
  }

  Future<void> getStories(StoryEvent event, Emitter<StoryState> emit) async {
    try {
      emit(state.copyWith(isLoading: true));

      if (await InternetConnect().isInternetConnected()) {
        final stories = await storyRepository.getStories(_currentPage);
        emit(state.copyWith(
            stories: [...state.stories, ...stories],
            isLoading: false,
            error: '',
            isLoadedLocal: false));
        await dbHelper.deleteAllStories();

        await dbHelper.saveStories(stories);
      } else {
        if (!state.isLoadedLocal) {
          final stories = await dbHelper.getStories();
          print('No internet');
          print(stories);
          emit(state.copyWith(
              stories: [...state.stories, ...stories],
              isLoading: false,
              error: '',
              isLoadedLocal: true));
        } else {
          emit(state.copyWith(isLoading: false));
        }
      }
    } catch (e) {
      print(e);
      emit(state.copyWith(isLoading: false, error: 'Error: $e'));
    }
  }

  Future<void> _onScroll() async {
    if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        await InternetConnect().isInternetConnected()) {
      print(await InternetConnect().isInternetConnected());
      if (!state.isLoading) {
        _currentPage++;
        add(GetStories());
      }
    }
  }

  @override
  Stream<StoryState> mapEventToState(StoryEvent event) async* {
    yield state.copyWith(isLoading: true);
    try {
      // Gọi API để lấy dữ liệu mới
      List<Story> apiStories = await storyRepository.getStories(_currentPage);

      // Lưu dữ liệu vào cơ sở dữ liệu local
      await dbHelper.saveStories(apiStories);

      // Cập nhật trạng thái của Bloc với dữ liệu mới
      yield state.copyWith(stories: apiStories, isLoading: false, error: '');
    } catch (e) {
      // Xử lý lỗi khi gọi API
      yield state.copyWith(isLoading: false, error: 'Error: $e');
    }
  }
}

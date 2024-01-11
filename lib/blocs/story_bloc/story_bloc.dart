import 'package:bai5_bloc_dio/blocs/story_bloc/story_event.dart';
import 'package:bai5_bloc_dio/blocs/story_bloc/story_state.dart';
import 'package:bai5_bloc_dio/repositories/story_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StoryBloc extends Bloc<StoryEvent, StoryState> {
  final StoryRepository storyRepository;
  final ScrollController scrollController;
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
      final stories = await storyRepository.getStories(_currentPage);
      emit(state.copyWith(
          stories: [...state.stories, ...stories],
          isLoading: false,
          error: ''));
    } catch (e) {
      print(e);
      emit(state.copyWith(isLoading: false, error: 'Error: $e'));
    }
  }

  Future<void> _onScroll() async {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (!state.isLoading) {
        _currentPage++;
        add(GetStories());
      }
    }
  }
}

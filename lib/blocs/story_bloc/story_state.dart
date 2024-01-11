import 'package:bai5_bloc_dio/models/story_model.dart';

class StoryState {
  final List<Story> stories;
  final bool isLoading;
  final String error;

  StoryState(
      {required this.stories, required this.isLoading, required this.error});

  factory StoryState.initial() {
    return StoryState(stories: [], isLoading: false, error: '');
  }

  StoryState copyWith({List<Story>? stories, bool? isLoading, String? error}) {
    return StoryState(
        stories: stories ?? this.stories,
        isLoading: isLoading ?? this.isLoading,
        error: error ?? this.error);
  }
}

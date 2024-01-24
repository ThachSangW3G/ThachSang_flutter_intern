import 'package:bai5_bloc_dio/features/story/domain/entities/story_entity.dart';
import 'package:equatable/equatable.dart';

class RemoteStoryState extends Equatable {
  final List<StoryEntity> stories;
  final String error;
  final bool isLoading;
  final bool isLoadedLocal;

  const RemoteStoryState(
      {required this.stories,
      required this.error,
      required this.isLoading,
      required this.isLoadedLocal});

  @override
  List<Object?> get props => [stories, error, isLoading];

  factory RemoteStoryState.initial() {
    return const RemoteStoryState(
        stories: [], isLoading: false, error: '', isLoadedLocal: false);
  }

  RemoteStoryState copyWith(
      {List<StoryEntity>? stories,
      bool? isLoading,
      String? error,
      bool? isLoadedLocal}) {
    return RemoteStoryState(
        stories: stories ?? this.stories,
        isLoading: isLoading ?? this.isLoading,
        error: error ?? this.error,
        isLoadedLocal: isLoadedLocal ?? this.isLoadedLocal);
  }
}

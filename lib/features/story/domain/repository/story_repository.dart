import 'package:bai5_bloc_dio/core/resources/data_state.dart';
import 'package:bai5_bloc_dio/features/story/domain/entities/story_entity.dart';

abstract class StoryRepository {
  Future<DataState<List<StoryEntity>>> getStories(int page);
  Future<DataState<List<StoryEntity>>> getLocalStories();
  Future<void> saveStories(List<StoryEntity> stories);
  Future<void> deleteLocalStories();
}

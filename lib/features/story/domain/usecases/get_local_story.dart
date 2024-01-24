import 'package:bai5_bloc_dio/core/resources/data_state.dart';
import 'package:bai5_bloc_dio/core/usecases/usecase.dart';
import 'package:bai5_bloc_dio/features/story/domain/entities/story_entity.dart';
import 'package:bai5_bloc_dio/features/story/domain/repository/story_repository.dart';

class GetLocalStoryUseCase
    implements UseCaseWithoutParams<DataState<List<StoryEntity>>> {
  final StoryRepository repository;

  const GetLocalStoryUseCase(this.repository);

  @override
  Future<DataState<List<StoryEntity>>> call() async {
    return await repository.getLocalStories();
  }
}

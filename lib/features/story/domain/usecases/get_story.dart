import 'package:bai5_bloc_dio/core/resources/data_state.dart';
import 'package:bai5_bloc_dio/core/usecases/usecase.dart';
import 'package:bai5_bloc_dio/features/story/domain/entities/story_entity.dart';
import 'package:bai5_bloc_dio/features/story/domain/repository/story_repository.dart';

class GetStoryUsecase
    implements UseCaseWithoutParams<DataState<List<StoryEntity>>> {
  final StoryRepository _storyRepository;
  GetStoryUsecase(this._storyRepository);

  @override
  Future<DataState<List<StoryEntity>>> call([int page = 1]) {
    return _storyRepository.getStories(page);
  }
}

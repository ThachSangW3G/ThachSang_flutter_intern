import 'package:bai5_bloc_dio/core/usecases/usecase.dart';
import 'package:bai5_bloc_dio/features/story/domain/entities/story_entity.dart';
import 'package:bai5_bloc_dio/features/story/domain/repository/story_repository.dart';

class SaveStoryUseCase implements Usecase<void, List<StoryEntity>> {
  final StoryRepository _storyRepository;
  SaveStoryUseCase(this._storyRepository);

  @override
  Future<void> call({List<StoryEntity>? params}) {
    return _storyRepository.saveStories(params!);
  }
}

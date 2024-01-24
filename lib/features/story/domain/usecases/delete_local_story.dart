import 'package:bai5_bloc_dio/core/usecases/usecase.dart';
import 'package:bai5_bloc_dio/features/story/domain/repository/story_repository.dart';

class DeleteLocalStoryUseCase implements UseCaseWithoutParams<void> {
  final StoryRepository _storyRepository;
  DeleteLocalStoryUseCase(this._storyRepository);

  @override
  Future<void> call() {
    return _storyRepository.deleteLocalStories();
  }
}

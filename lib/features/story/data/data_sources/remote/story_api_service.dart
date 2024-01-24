import 'package:bai5_bloc_dio/core/exceptions/remote_exception.dart';
import 'package:bai5_bloc_dio/features/story/data/models/story_model.dart';
import 'package:dio/dio.dart';

abstract class StoryApiService {
  const StoryApiService();

  Future<List<StoryModel>> getStories(int page);
}

class StoryApiServiceImpl implements StoryApiService {
  final Dio dio;

  StoryApiServiceImpl({required this.dio});

  @override
  Future<List<StoryModel>> getStories(int page) async {
    try {
      final response = await dio.get(
        'http://54.226.141.124/intern/news?page=$page',
      );

      print(response);

      return (response.data as List).map((storyJson) {
        return StoryModel.fromJson(storyJson);
      }).toList();
    } on DioException catch (e) {
      throw RemoteException(e.message!, 500);
    }
  }
}

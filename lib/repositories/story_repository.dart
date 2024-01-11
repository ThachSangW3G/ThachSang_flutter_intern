import 'package:bai5_bloc_dio/models/story_model.dart';
import 'package:dio/dio.dart';

class StoryRepository {
  final dio = Dio();

  Future<List<Story>> getStories(currentPage) async {
    try {
      final response =
          await dio.get('http://54.226.141.124/intern/news?page=$currentPage');
      print(response.data.toString());

      if (response.statusCode == 200) {
        List<Story> stories = (response.data as List).map((storyJson) {
          return Story.fromJson(storyJson);
        }).toList();

        print(stories);
        return stories;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}

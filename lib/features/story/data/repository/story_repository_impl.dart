import 'dart:io';

import 'package:bai5_bloc_dio/core/resources/data_state.dart';
import 'package:bai5_bloc_dio/features/story/data/data_sources/local/story_local_datasource.dart';
import 'package:bai5_bloc_dio/features/story/data/data_sources/remote/story_api_service.dart';
import 'package:bai5_bloc_dio/features/story/data/models/story_model.dart';
import 'package:bai5_bloc_dio/features/story/domain/entities/story_entity.dart';
import 'package:bai5_bloc_dio/features/story/domain/repository/story_repository.dart';
import 'package:dio/dio.dart';

class StoryRepositoryImpl implements StoryRepository {
  final StoryApiService _storyApiService;
  final DatabaseHelper _databaseHelper;

  StoryRepositoryImpl(this._storyApiService, this._databaseHelper);

  @override
  Future<DataState<List<StoryModel>>> getStories(int page) async {
    try {
      final stories = await _storyApiService.getStories(page);

      print(stories);

      return DataSuccess(stories);
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<List<StoryEntity>>> getLocalStories() async {
    try {
      final stories = await _databaseHelper.getStories();
      return DataSuccess(stories);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> saveStories(List<StoryEntity> params) async {
    try {
      return await _databaseHelper.saveStories(params);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> deleteLocalStories() async {
    try {
      return await _databaseHelper.deleteAllStories();
    } catch (e) {
      throw Exception(e);
    }
  }
}

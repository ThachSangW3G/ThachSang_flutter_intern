import 'package:bai5_bloc_dio/features/story/domain/entities/story_entity.dart';

class StoryModel extends StoryEntity {
  const StoryModel(
      {required super.storyId,
      required super.title,
      required super.summary,
      required super.modifiedAt,
      required super.image});

  factory StoryModel.fromJson(Map<String, dynamic> json) {
    return StoryModel(
        storyId: json['storyId'] ?? 0,
        title: json['title'] ?? '',
        summary: json['summary'] ?? '',
        modifiedAt: json['modifiedAt'] ?? '',
        image: json['image'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      'storyId': storyId,
      'title': title,
      'summary': summary,
      'modifiedAt': modifiedAt,
      'image': image
    };
  }
}

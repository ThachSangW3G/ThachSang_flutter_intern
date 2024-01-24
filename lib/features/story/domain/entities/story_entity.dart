import 'package:equatable/equatable.dart';

class StoryEntity extends Equatable {
  final int storyId;
  final String title;
  final String summary;
  final String modifiedAt;
  final String image;

  const StoryEntity(
      {required this.storyId,
      required this.title,
      required this.summary,
      required this.modifiedAt,
      required this.image});

  @override
  List<Object?> get props {
    return [storyId, title, summary, modifiedAt, image];
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

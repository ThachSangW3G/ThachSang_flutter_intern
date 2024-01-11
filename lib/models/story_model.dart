class Story {
  final int storyId;
  final String title;
  final String summary;
  final String modifiedAt;
  final String image;

  Story(
      {required this.storyId,
      required this.title,
      required this.summary,
      required this.modifiedAt,
      required this.image});

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
        storyId: json['storyId'] ?? 0,
        title: json['title'] ?? '',
        summary: json['summary'] ?? '',
        modifiedAt: json['modifiedAt'] ?? '',
        image: json['image'] ?? '');
  }
}

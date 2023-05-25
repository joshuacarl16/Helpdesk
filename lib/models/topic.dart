class Topic {
  final String categoryId;
  final String userId;
  final String topicName;
  late final bool helpStatus;
  final String content;
  final DateTime dateCreated;
  final int? numberOfComments;

  Topic({
    required this.topicName,
    required this.content,
    required this.categoryId,
    required this.userId,
    this.helpStatus = false,
    required this.dateCreated,
    required this.numberOfComments,
  });

  Map<String, dynamic> toJson() {
    return {
      'categoryId': categoryId,
      'userId': userId,
      'topicName': topicName,
      'content': content,
      'helpStatus': helpStatus,
      'dateCreated': dateCreated.toIso8601String(),
      'numberOfComments': numberOfComments,
    };
  }

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      categoryId: json['categoryId'] ?? 'N/A',
      userId: json['userId'] ?? 'N/A',
      helpStatus: json['helpStatus'] ?? false,
      dateCreated: json['dateCreated'] != null
          ? DateTime.parse(json['dateCreated'])
          : DateTime.now(),
      numberOfComments: json['numberOfComments'] ?? 0,
      topicName: json['topicName'] ?? 'N/A',
      content: json['content'] ?? 'N/A',
    );
  }
}

import 'package:helpdesk_ipt/models/comment.dart';

class Topic {
  String topicId;
  String title;
  String description;
  String categoryId;
  String categoryName;
  String userId;
  String created;
  List<Comment> comments;
  Topic({
    required this.topicId,
    required this.title,
    required this.description,
    required this.categoryId,
    required this.categoryName,
    required this.userId,
    required this.created,
    List<Comment>? comments,
  }) : comments = comments ?? [];

  Map<String, dynamic> toJson() => {
        'topicId': topicId,
        'title': title,
        'description': description,
        'categoryId': categoryId,
        'categoryName': categoryName,
        'userId': userId,
        'created': created
      };

  factory Topic.fromJson(Map<String, dynamic> map) {
    return Topic(
      topicId: map['topicId'],
      title: map['title'],
      description: map['description'],
      categoryId: map['categoryId'],
      categoryName: map['categoryName'] ?? '',
      userId: map['userId'],
      created: map['created'],
    );
  }

  @override
  bool operator ==(covariant Topic other) => topicId == other.topicId;

  @override
  int get hashCode => topicId.hashCode;
}

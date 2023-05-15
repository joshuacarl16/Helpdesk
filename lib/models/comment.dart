import 'package:uuid/uuid.dart';

class Comment {
  final String commentId;
  String topicId;
  String userId;
  bool isMostHelpful;
  String content;
  DateTime dateCreated;
  int replyCount;

  Comment({
    required this.topicId,
    required this.userId,
    this.content = '',
    this.isMostHelpful = false,
    this.replyCount = 0,
    required this.dateCreated,
  }) : commentId = const Uuid().v4();

  @override
  bool operator ==(covariant Comment other) => commentId == other.commentId;

  @override
  int get hashCode => commentId.hashCode;
}
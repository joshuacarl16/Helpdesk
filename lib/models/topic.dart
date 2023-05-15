import 'package:uuid/uuid.dart';

class Topic {
  final String topicId;
  String categoryName;
  String userId;
  String topicName;
  bool helpStatus;
  String content;
  DateTime dateCreated;
  int numberOfComments;

  Topic({
    required this.categoryName,
    required this.userId,
    required this.topicName,
    this.content = '',
    this.helpStatus = false,
    this.numberOfComments = 0,
    required this.dateCreated,
  }) : topicId = const Uuid().v4();

  @override
  bool operator ==(covariant Topic other) => topicId == other.topicId;

  @override
  int get hashCode => topicId.hashCode;
}

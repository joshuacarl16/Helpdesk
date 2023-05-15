import 'package:uuid/uuid.dart';

class Reply {
  final String replyId;
  String commentId;
  String userId;
  String adminId;
  String content;
  DateTime dateCreated;

  Reply({
    required this.commentId,
    required this.userId,
    required this.adminId,
    this.content = '',
    required this.dateCreated,
  }) : replyId = const Uuid().v4();

  @override
  bool operator ==(covariant Reply other) => replyId == other.replyId;

  @override
  int get hashCode => replyId.hashCode;
}
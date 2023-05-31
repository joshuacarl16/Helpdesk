class Comment {
  String commentId;
  String content;
  String topicId;
  bool showReply;
  String userId;
  Comment({
    required this.commentId,
    required this.topicId,
    required this.userId,
    required this.content,
    this.showReply = false,
  });

  get categoryId => null;

  Map<String, dynamic> toJson() {
    return {
      'commentId': commentId,
      'content': content,
      'topicId': topicId,
      'showReply': showReply,
      'userId': userId,
    };
  }

  factory Comment.fromJson(Map<String, dynamic> map) {
    return Comment(
      commentId: map['commentId'],
      content: map['content'],
      topicId: map['topicId'],
      showReply: map['showReply'],
      userId: map['userId'],
    );
  }

  @override
  bool operator ==(covariant Comment other) => commentId == other.commentId;

  @override
  int get hashCode => commentId.hashCode;
}

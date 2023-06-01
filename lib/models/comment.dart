class Comment {
  String commentId;
  String content;
  String topicId;
  String replies;
  String userId;
  Comment(
      {required this.commentId,
      required this.topicId,
      required this.userId,
      required this.content,
      required this.replies});

  get categoryId => null;

  Map<String, dynamic> toJson() {
    return {
      'commentId': commentId,
      'content': content,
      'topicId': topicId,
      'replies': replies,
      'userId': userId,
    };
  }

  factory Comment.fromJson(Map<String, dynamic> map) {
    return Comment(
      commentId: map['commentId'],
      content: map['content'],
      topicId: map['topicId'],
      replies: map['replies'],
      userId: map['userId'],
    );
  }

  @override
  bool operator ==(covariant Comment other) => commentId == other.commentId;

  @override
  int get hashCode => commentId.hashCode;
}

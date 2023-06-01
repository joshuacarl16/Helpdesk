class Reply {
  String replyId;
  String replyContent;
  String commentId;
  String userId;
  Reply({
    required this.commentId,
    required this.replyId,
    required this.userId,
    required this.replyContent,
  });

  Map<String, dynamic> toJson() {
    return {
      'replyId': replyId,
      'replyContent': replyContent,
      'commentId': commentId,
      'userId': userId,
    };
  }

  factory Reply.fromJson(Map<String, dynamic> map) {
    return Reply(
      replyId: map['replyId'],
      replyContent: map['replyContent'],
      commentId: map['commentId'],
      userId: map['userId'],
    );
  }

  @override
  bool operator ==(covariant Reply other) => replyId == other.replyId;

  @override
  int get hashCode => replyId.hashCode;
}

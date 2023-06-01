import 'package:flutter/material.dart';
import 'package:helpdesk_ipt/models/topic.dart';
import 'package:helpdesk_ipt/provider/provider.dart';
import 'package:helpdesk_ipt/widgets/comment_card.dart';
import 'package:provider/provider.dart';

class CommentListWidget extends StatelessWidget {
  const CommentListWidget({Key? key, required this.topic}) : super(key: key);

  final Topic topic;

  @override
  Widget build(BuildContext context) {
    final cProvider = context.read<CommentProvider>();
    final comments = cProvider.commentList;
    final commentsList = cProvider.commentList
        .where((comment) => comment.topicId == topic.topicId)
        .toList();

    Future<void> _refreshComments() async {
      await cProvider.fetchCommentsByTopicId(topic.topicId);
    }

    return commentsList.isEmpty
        ? Center(
            child: Container(
              padding: const EdgeInsets.all(6),
              child: Text(
                'NO COMMENTS',
                style: TextStyle(),
              ),
            ),
          )
        : RefreshIndicator(
            onRefresh: _refreshComments,
            child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(6),
                separatorBuilder: (context, index) => Container(height: 8),
                itemCount: commentsList.length,
                itemBuilder: (context, index) {
                  final comment = commentsList[index];
                  return CommentCard(
                    comment: comment,
                  );
                }),
          );
  }
}

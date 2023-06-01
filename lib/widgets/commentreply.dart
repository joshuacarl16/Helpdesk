import 'package:flutter/material.dart';
import 'package:helpdesk_ipt/models/comment.dart';
import 'package:helpdesk_ipt/models/reply.dart';

class CommentReplyPage extends StatelessWidget {
  final Comment comment;

  const CommentReplyPage({Key? key, required this.comment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comment Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Comment:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              comment.content,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Replies:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: comment.replies.length,
                itemBuilder: (context, index) {
                  Reply reply = comment.replies[index];
                  return ListTile(
                    title: Text(reply.replyContent),
                    subtitle: Text('- ${reply.userId}'),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Navigate to the reply page
                // Pass the comment or comment ID if needed
              },
              child: Text('Reply'),
            ),
          ],
        ),
      ),
    );
  }
}

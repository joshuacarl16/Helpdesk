// import 'package:flutter/material.dart';
// import 'package:helpdesk_ipt/models/comment.dart';
// import 'package:helpdesk_ipt/models/reply.dart';
// import 'package:helpdesk_ipt/models/topic.dart';
// import 'package:helpdesk_ipt/provider/provider.dart';
// import 'package:helpdesk_ipt/widgets/comment_card.dart';
// import 'package:helpdesk_ipt/widgets/reply_card.dart';
// import 'package:provider/provider.dart';

// class ReplyListWidget extends StatelessWidget {
//   const ReplyListWidget({Key? key, required this.reply}) : super(key: key);

//   final Reply reply;

//   @override
//   Widget build(BuildContext context) {
//     final rProvider = context.read<ReplyProvider>();
//     final comments = rProvider.replyList;
//     final repliesList = rProvider.replyList
//         .where((reply) => reply.commentId == reply.commentId)
//         .toList();

//     Future<void> _refreshReplies() async {
//       // await cProvider.fetchCommentsByTopicId(comment.topicId);
//     }

//     return repliesList.isEmpty
//         ? Center(
//             child: Container(
//               padding: const EdgeInsets.all(6),
//               child: Text(
//                 'NO REPLIES',
//                 style: TextStyle(),
//               ),
//             ),
//           )
//         : RefreshIndicator(
//             onRefresh: _refreshReplies,
//             child: ListView.separated(
//                 physics: const BouncingScrollPhysics(),
//                 padding: const EdgeInsets.all(6),
//                 separatorBuilder: (context, index) => Container(height: 8),
//                 itemCount: repliesList.length,
//                 itemBuilder: (context, index) {
//                   final reply = repliesList[index];
//                   return ReplyCard(
//                     reply: reply,
//                   );
//                 }),
//           );
//   }
// }

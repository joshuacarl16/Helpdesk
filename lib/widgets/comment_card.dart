import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:helpdesk_ipt/models/comment.dart';
import 'package:helpdesk_ipt/models/reply.dart';
import 'package:helpdesk_ipt/widgets/commentreply.dart';
// import 'package:helpdesk_ipt/widgets/reply_list.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import '../main.dart';
import '../models/user.dart';
import '../provider/provider.dart';

class CommentCard extends StatelessWidget {
  const CommentCard({Key? key, required this.comment}) : super(key: key);
  final Comment comment;

  @override
  Widget build(BuildContext context) {
    final uProvider = context.watch<UserProvider>();
    final provider = context.watch<ReplyProvider>();
    final currentUser = context.select<UserProvider, User?>(
      (provider) => provider.user,
    );

    final user = context.select<UserProvider, User?>((provider) {
      for (int i = 0; i < provider.usersList.length; i++) {
        if (provider.usersList.elementAt(i)?.userId == comment.userId) {
          return provider.usersList.elementAt(i);
        }
      }
      return null;
    });

    final username = context.select<UserProvider, String>((provider) {
      for (int i = 0; i < uProvider.usersList.length; i++) {
        if (comment.userId == uProvider.usersList[i]?.userId) {
          return provider.usersList.elementAt(i)!.username;
        }
      }
      return '';
    });

    // return GestureDetector(
    //   onTap: () {
    //     Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //         builder: (context) => CommentReplyPage(comment: comment),
    //       ),
    //     );
    //   },

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: PhysicalModel(
        color: Colors.white,
        shadowColor: Colors.black,
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
          margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
          child: Column(
            children: [
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    child: Icon(
                      Icons.account_box_outlined,
                      size: 40,
                    ),
                  ),
                  Expanded(
                    flex: 8,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (comment.content.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    username,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    comment.content,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else
                            const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:helpdesk_ipt/models/comment.dart';
import 'package:helpdesk_ipt/models/topic.dart';
import 'package:helpdesk_ipt/provider/provider.dart';
import 'package:helpdesk_ipt/widgets/comment_card.dart';
import 'package:helpdesk_ipt/widgets/comment_list.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class TopicDetails extends StatefulWidget {
  final Topic topic;

  const TopicDetails({Key? key, required this.topic}) : super(key: key);

  @override
  State<TopicDetails> createState() => _TopicDetailsState();
}

class _TopicDetailsState extends State<TopicDetails> {
  late Topic topic;
  late UserProvider uProvider;
  late CategoryProvider cProvider;

  @override
  void initState() {
    super.initState();
    topic = widget.topic;
    uProvider = Provider.of<UserProvider>(context, listen: false);
    cProvider = Provider.of<CategoryProvider>(context, listen: false);
    final commentProvider =
        Provider.of<CommentProvider>(context, listen: false);
    commentProvider.fetchComments();
  }

  @override
  Widget build(BuildContext context) {
    final createdDateTime = DateTime.parse(topic.created);
    final formattedDateTime =
        DateFormat('MM-dd-yyyy HH:mm').format(createdDateTime);

    final username = context.select<UserProvider, String>((provider) {
      for (int i = 0; i < uProvider.usersList.length; i++) {
        if (topic.userId == uProvider.usersList[i]?.userId) {
          return provider.usersList.elementAt(i)!.username;
        }
      }
      return '';
    });

    final categoryName = context.select<CategoryProvider, String>((provider) {
      for (int i = 0; i < cProvider.categoryList.length; i++) {
        if (topic.categoryId == cProvider.categoryList[i].categoryId) {
          return provider.categoryList.elementAt(i).categoryName;
        }
      }
      return '';
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Topic Details'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35),
            child: Container(
              height: 800,
              width: 500,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            topic.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Category: $categoryName',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Posted by: $username',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Created on: $formattedDateTime',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            topic.description,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView(
                      children: [
                        Slidable(
                          actionPane: SlidableDrawerActionPane(),
                          actionExtentRatio: 0.25,
                          child: Container(
                            height: 50,
                            color: Colors.white,
                            child: Center(),
                          ),
                          secondaryActions: <Widget>[
                            IconSlideAction(
                              caption: 'Delete',
                              color: Colors.red,
                              icon: Icons.delete,
                              onTap: () {},
                            ),
                          ],
                        ),
                        CommentCard(
                          comment: Comment(
                            commentId: '',
                            topicId: '',
                            userId: '',
                            content: '',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _displayAddCommentDialog(
            context,
            Comment(commentId: '', topicId: '', userId: '', content: ''),
          );
        },
        backgroundColor: Colors.black,
        child: Icon(Icons.comment),
      ),
    );
  }

  Future<void> _displayAddCommentDialog(
      BuildContext context, Comment comment) async {
    final topicProvider = context.read<TopicProvider>();
    topicProvider.setTopic(topic);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddCommentDialog(comment: comment);
      },
    );
  }
}

class AddCommentDialog extends StatefulWidget {
  final Comment comment;

  const AddCommentDialog({Key? key, required this.comment}) : super(key: key);

  @override
  _AddCommentDialogState createState() => _AddCommentDialogState();
}

class _AddCommentDialogState extends State<AddCommentDialog> {
  late final TextEditingController _commentController;

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final commentController = TextEditingController();
    final currentTopic = context.select<TopicProvider, Topic?>(
      (provider) => provider.topic,
    );
    context.watch<TopicProvider>();

    final uProvider = Provider.of<UserProvider>(context, listen: false);
    final currentUser = uProvider.user;
    final username = context.select<UserProvider, String>((provider) {
      for (int i = 0; i < uProvider.usersList.length; i++) {
        if (widget.comment.userId == uProvider.usersList[i]?.userId) {
          return provider.usersList.elementAt(i)!.username;
        }
      }
      return '';
    });
    final cProvider = Provider.of<CategoryProvider>(context, listen: false);
    final catName = context.select<CategoryProvider, String>((provider) {
      for (int i = 0; i < cProvider.categoryList.length; i++) {
        if (widget.comment.categoryId == cProvider.categoryList[i].categoryId) {
          return provider.categoryList.elementAt(i).categoryName;
        }
      }
      return '';
    });

    Future<void> _addComment() async {
      final String topicComment = _commentController.text;

      final commentId = Uuid().v4();
      final comment = Comment(
        userId: currentUser!.userId,
        commentId: commentId,
        content: _commentController.text,
        topicId: currentTopic!.topicId,
      );
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/add_comment/'),
        headers: <String, String>{
          'Content-type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(comment.toJson()),
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        final newComment = Comment.fromJson(responseData);
        context.read<TopicProvider>().fetchTopics();
        context.read<CommentProvider>().fetchComments();
        final tProvider = Provider.of<TopicProvider>(context, listen: false);
        tProvider.addComment(newComment);
      }
    }

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _commentController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Add Comment',
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _addComment();
                    Navigator.pop(context);
                  },
                  child: const Text('Save'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

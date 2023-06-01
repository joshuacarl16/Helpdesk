import 'dart:convert';

import 'package:flutter/cupertino.dart';
import '../models/category.dart';
import '../models/comment.dart';
import '../models/reply.dart';
import '../models/topic.dart';
import '../models/user.dart';
import 'package:http/http.dart' as http;

class UserProvider extends ChangeNotifier {
  UserProvider() {
    fetchUsers();
  }

  List<User?> _userList = [];
  List<User?> get usersList => _userList;

  User? _user;
  User? get user => _user;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  Future<void> fetchUsers() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/users/'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      _userList.clear();
      for (var replyData in jsonData) {
        final users = User.fromJson(replyData);
        _userList.add(users);
      }
      notifyListeners();
    } else {
      throw Exception('Failed to fetch users');
    }
  }
  // User setCurrentUser(User user) {
  //   _currentUser = user;
  //   notifyListeners();
  //   return _currentUser;
  // }

  void remove(User user) {
    _userList.remove(user);
    notifyListeners();
  }
}

class CategoryProvider extends ChangeNotifier {
  CategoryProvider() {
    _currentCategory = Category(
      categoryId: 'All',
      categoryName: 'All',
      userId: '',
      isClicked: false,
    );
    fetchCategories();
  }
  final List<Category> _categoryList = [];
  bool activeCategory = false;
  late Category _currentCategory;
  Category get currentCategory => _currentCategory;
  List<Category> get categoryList => _categoryList;

  Future<void> fetchCategories() async {
    final response =
        await http.get(Uri.parse('http://127.0.0.1:8000/categories/'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      _categoryList.clear();
      for (var categoryData in jsonData) {
        final categories = Category.fromJson(categoryData);
        _categoryList.add(categories);
      }
      notifyListeners();
    } else {
      throw Exception('Failed to fetch categories');
    }
  }

  void add(Category category) {
    _categoryList.add(category);
    notifyListeners();
  }

  void setCurrentCategory(Category category) {
    _currentCategory = category;
    activeCategory = true;
    notifyListeners();
  }

  void setAllCategory() {
    _currentCategory =
        Category(categoryId: 'All', categoryName: 'All', userId: '');

    notifyListeners();
  }

  void remove(Category category) {
    _categoryList.remove(category);
    notifyListeners();
  }
}

class TopicProvider extends ChangeNotifier {
  List<Topic> _topicList = [];
  bool activeComment = false;
  List<Topic> get topicList => _topicList;
  Topic? _topic;
  Topic? get topic => _topic;
  List<Topic> _topics = [];
  List<Topic> get topics => [..._topics];

  Future<void> fetchTopics() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/topics/'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      _topicList.clear();
      for (var topicData in jsonData) {
        final topic = Topic.fromJson(topicData);
        _topicList.add(topic);
      }
      notifyListeners();
    } else {
      throw Exception('Failed to fetch topics');
    }
  }

  addComment(Comment comment) {
    final topicIndex =
        _topics.indexWhere((topic) => topic.topicId == comment.topicId);
    if (topicIndex != -1) {
      _topics[topicIndex].comments.add(comment);
      notifyListeners();
    }
  }

  setTopic(Topic topic) {
    _topic = topic;
    notifyListeners();
  }

  List<Topic> getFilteredTopics(String categoryId) {
    if (categoryId == 'All') {
      return _topicList;
    } else {
      return _topicList
          .where((topic) => topic.categoryId == categoryId)
          .toList();
    }
  }

  deleteTopic(Topic topic) async {
    final response = await http.delete(
        Uri.parse('http://127.0.0.1:8000/topics/${topic.topicId}/delete/'));
    if (response.statusCode == 200) {
      _topicList.remove(topic);
      notifyListeners();
    } else {
      throw Exception('Failed to delete topic');
    }
  }

  addTopic(Topic topic) async {
    _topicList.add(topic);
    notifyListeners();
  }
}

class CommentProvider extends ChangeNotifier {
  final List<Comment> _commentList = [];
  List<Comment> get commentList => _commentList;

  Comment? _comment;
  Comment? get comment => _comment;

  Future<void> fetchComments() async {
    final response =
        await http.get(Uri.parse('http://127.0.0.1:8000/comments/'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      _commentList.clear();
      for (var commentData in jsonData) {
        final comment = Comment.fromJson(commentData);
        _commentList.add(comment);
      }
      notifyListeners();
    } else {
      throw Exception('Failed to fetch comments');
    }
  }

  void setComment(Comment comment) {
    _comment = comment;
    notifyListeners();
  }

  void add(Comment comment) {
    _commentList.add(comment);
    notifyListeners();
  }

  void remove(Comment comment) {
    _commentList.remove(comment);
    notifyListeners();
  }
}

class ReplyProvider extends ChangeNotifier {
  final List<Reply> _replyList = [];
  List<Reply> get commentList => _replyList;

  void add(Reply comment) {
    _replyList.add(comment);
    notifyListeners();
  }

  void remove(Reply comment) {
    _replyList.remove(comment);
    notifyListeners();
  }
}

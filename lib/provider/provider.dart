import 'dart:convert';

import 'package:flutter/cupertino.dart';
import '../models/category.dart';
import '../models/comment.dart';
import '../models/reply.dart';
import '../models/topic.dart';
import '../models/user.dart';
import 'package:http/http.dart' as http;

class UserProvider extends ChangeNotifier {
  final List<User> _userList = [];
  late User _currentUser =
      User(username: '', password: '', firstName: '', lastName: '');
  User get currentUser => _currentUser;
  List<User> get userList => _userList.where((e) => e.roles == 'user').toList();
  List<User> get adminList =>
      _userList.where((e) => e.roles == 'admin').toList();

  void add(User user) {
    _userList.add(user);
    notifyListeners();
  }

  User setCurrentUser(User user) {
    _currentUser = user;
    notifyListeners();
    return _currentUser;
  }

  void remove(User user) {
    _userList.remove(user);
    notifyListeners();
  }
}

class CategoryProvider extends ChangeNotifier {
  final List<Category> _categoryList = [];
  bool activeCategory = false;
  late Category _currentCategory;
  Category get currentCategory => _currentCategory;
  List<Category> get categoryList => _categoryList;
  List<Category> categories = [];

  Future<void> fetchCategories() async {
    final response =
        await http.get(Uri.parse('http://127.0.0.1:8000/categories/'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> topicData = jsonData['categories'];

      categories =
          topicData.map((topicJson) => Category.fromJson(topicJson)).toList();
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

  void setActiveCategoryFalse() {
    activeCategory = false;
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

  Future<void> fetchTopics() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/topics/'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> topicData = jsonData['topics'];

      _topicList =
          topicData.map((topicJson) => Topic.fromJson(topicJson)).toList();
    } else {
      throw Exception('Failed to fetch topics');
    }
  }

  void add(Topic topic) {
    _topicList.add(topic);
    notifyListeners();
  }

  bool toggleHelpstatus(Topic topic) {
    topic.helpStatus = !topic.helpStatus;
    notifyListeners();
    return topic.helpStatus;
  }

  void remove(Topic topic) {
    _topicList.remove(topic);
    notifyListeners();
  }
}

class CommentProvider extends ChangeNotifier {
  final List<Comment> _commentList = [];
  List<Comment> get commentList => _commentList;

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

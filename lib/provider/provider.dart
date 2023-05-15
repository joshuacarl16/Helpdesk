import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:helpdesk_ipt/httpreqs/api_service.dart';
import 'package:http/src/response.dart';

import '../httpreqs/category_service.dart';
import '../models/category.dart';
import '../models/comment.dart';
import '../models/reply.dart';
import '../models/topic.dart';
import '../models/user.dart';

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
  final CategoryService _categoryService = CategoryService();
  final List<Category> _categoryList = [];
  bool activeCategory = false;
  late Category _currentCategory;
  Category get currentCategory => _currentCategory;
  List<Category> get categoryList => _categoryList;

  Future<void> fetchCategories() async {
    try {
      final http.Response response = await _categoryService.fetchCategories();
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final List<Category> fetchedCategories = data
            .map((categoryJson) => Category.fromJson(categoryJson))
            .toList();
        _categoryList.clear();
        _categoryList.addAll(fetchedCategories);
        notifyListeners();
      } else {
        print('API Request failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
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
  final List<Topic> _topicList = [];
  bool activeComment = false;
  List<Topic> get topicList => _topicList;

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

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:helpdesk_ipt/models/category.dart';

class CategoryService {
  Future<http.Response> fetchCategories() async {
    final response =
        await http.get(Uri.parse('http://127.0.0.1:8000/categories/'));
    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to fetch categories');
    }
  }
}

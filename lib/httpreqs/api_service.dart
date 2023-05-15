import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:helpdesk_ipt/models/category.dart';

class APIService {
  static const String baseUrl = 'http://127.0.0.1:8000';

  Future<List<Category>> fetchCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/categories/'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print("API Response: $data");
      return List<Category>.from(
          data.map((categoryJson) => Category.fromJson(categoryJson)));
    } else {
      print('API Request failed with status code: ${response.statusCode}');
      throw Exception('Failed to fetch categories');
    }
  }
}

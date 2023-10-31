import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/model/comments_model.dart';

class ApiServices {
  static Future<List<CommentsModel>> fetchPosts() async {
    const url = 'https://jsonplaceholder.typicode.com/comments';
    final uri = Uri.parse(url);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => CommentsModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch posts');
    }
  }
}

final userProvider = Provider<ApiServices>((ref) => ApiServices());

final dataProvider = FutureProvider<List<CommentsModel>>((ref) async {
  final apiService = ref.read(userProvider);
  return await ApiServices.fetchPosts();
});

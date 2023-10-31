import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_app/model/comments_model.dart';

class FetchComment {
  final String id;

  FetchComment({required this.id});

  Future<CommentsModel> fetchComment() async {
    final url = 'https://jsonplaceholder.typicode.com/comments/$id';
    final uri = Uri.parse(url);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      return CommentsModel.fromJson(jsonData);
    } else {
      throw Exception('Failed to fetch comment');
    }
  }
}

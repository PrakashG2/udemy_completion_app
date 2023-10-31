import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_app/api_services/comments_api.dart';
import 'package:my_app/model/comments_model.dart';

final commentsProvider = Provider((ref) {
  return ApiServices();
});

final postsProvider = FutureProvider<List<CommentsModel>>((ref) async {
  return await ApiServices.fetchPosts();
});


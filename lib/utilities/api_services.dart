import 'dart:convert';
import 'dart:io';

import 'package:api_prov_try/models/comments_model.dart';
import 'package:api_prov_try/models/users_model.dart';
import 'package:http/http.dart' as http;

//---------------------------------------------------------------------> API ENDPOINT
String apiBaseUrl = "https://jsonplaceholder.typicode.com/comments";
Uri apiEndpoint = Uri.parse(apiBaseUrl);

//----------------------------------------------------------> GET COMMENTS API CALL
Future<List<CommentsModel>> getComments() async {
  List<CommentsModel> commentsResult = [];
  try {
    final response = await http.get(
      Uri.parse(apiBaseUrl),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> items = json.decode(response.body);
      commentsResult =
          items.map((item) => CommentsModel.fromJson(item)).toList();
    } else {
      print("ERROR @ getComments API CALL ********** : ${response.statusCode}");
    }
  } catch (e) {
    print("ERROR @ getComments API ********** : $e");
  }
  return commentsResult;
}

//---------------------------------------------------------> GET SPECIFIC COMMENT API CALL
// Future<List<CommentsModel>> getSpecificComment(int commentId) async {
//   List<CommentsModel> specificCommentResult = [];

//  try {
//   final response = await http.get(
//     Uri.parse("$apiBaseUrl/${commentId + 1}"),
//     headers: {
//       HttpHeaders.contentTypeHeader: "application/json",
//     },
//   );
//   if (response.statusCode == 200) {
//     final dynamic data = json.decode(response.body);

//     if (data is List) {
//       specificCommentResult = data
//           .map((item) => CommentsModel.fromJson(item))
//           .cast<CommentsModel>()
//           .toList();
//     } else {
//       specificCommentResult.add(CommentsModel.fromJson(data));
//     }
//   } else {
//     print(
//         "ERROR @ getSpecificComment API CALL ********** : ${response.statusCode}");
//   }
// } catch (e) {
//   print("ERROR @ getSpecificComment API ********** : $e");
// }

//   return specificCommentResult;
// }

//---------------------------------------------------------> DELETE COMMENT API CALL
Future<http.Response> deleteComment(int commentId) async {
  http.Response response;
  try {
    response = await http.delete(Uri.parse("$apiBaseUrl/$commentId"));

    if (response.statusCode == 200) {
      print('DELETE COMMENT API CALL RESPONDED SUCCESS');
    } else {
      print(
          "ERROR @ deleteComment API CALL ********** : ${response.statusCode}");
    }
  } catch (e) {
    print("ERROR @ deleteComment API ********** : $e");
    rethrow;
  }
  return response;
}

//---------------------------------------------------------> POST COMMENT API CALL
Future<http.Response> postComment(CommentsModel newCommentData) async {
  http.Response response;
  try {
    response = await http.post(
      Uri.parse(apiBaseUrl),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
      },
      body: jsonEncode(newCommentData.toJson()),
    );

    if (response.statusCode == 201) {
      print('NEW COMMENT API CALL RESPONDED SUCCESS');
    } else {
      print("ERROR @ postComment API CALL ********** : ${response.statusCode}");
    }
  } catch (e) {
    print("ERROR @ postComment API ********** : $e");
    rethrow;
  }
  return response;
}

//---------------------------------------------------------> PUT COMMENT API CALL
Future<http.Response> putComment(
    CommentsModel putCommentData, String id) async {
  http.Response response;
  try {
    response = await http.put(
      Uri.parse("$apiBaseUrl/$id"),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
      },
      body: jsonEncode(putCommentData.toJson()),
    );

    if (response.statusCode == 200) {
      print('PUT OPERATION API CALL RESPONDED SUCCESS');
    } else {
      print('ERROR @ putComment API CALL ********** : ${response.statusCode}');
    }
  } catch (e) {
    print('ERROR @ putComment API **********: $e');
    rethrow;
  }
  return response;
}

//----------------------------------------------------------------> USERS API CALLS

Future<List<UsersModel>> getUsers() async {
  List<UsersModel> users = [];
  try {
    final response = await http.get(
      Uri.parse("https://jsonplaceholder.typicode.com/users"),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> items = json.decode(response.body);
      users = items.map((item) => UsersModel.fromJson(item)).toList();
    } else {
      print("Error code: ${response.statusCode}");
    }
  } catch (e) {
    print("Error code: $e");
    rethrow;
  }
  return users;
}

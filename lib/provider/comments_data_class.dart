import 'package:api_prov_try/utilities/api_services.dart';
import 'package:api_prov_try/models/comments_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//-------------------------------------------------------> DEFINING A PROVIDER

class CommentsProvider extends ChangeNotifier {
  List<CommentsModel>? commentsList;
  List<CommentsModel>? SpecificComment;
  bool getPostloading = false;
  bool isBack = false;
  bool isLoading = false;
  bool postDataLoading = false;
  int responseCode = 0;
  int dismissStatus = 0;

  //---------------------------------------------------> GETPOST METHOD TO LOAD DATA FROM API

  Future<void> getPostData() async {
    getPostloading = true;
    commentsList = await getComments();
    getPostloading = false;
    notifyListeners();
  }

  //---------------------------------------------------> GET SPECIFIC COMMENT USING ID TO EDIT IT

  // Future<void> fetchSpecificComment(int commentId) async {
  //   SpecificComment = await getSpecificComment(commentId);
  //   notifyListeners();
  // }

  //----------------------------------------------------> CUSTOM DISMISS FUNCTION TO DELETE SPRCIFIC COMMENT ON DISMISSING IT

  Future<void> customDismissFunction(int commentId) async {
    var dismissible = await deleteComment(commentId);
    dismissStatus = dismissible.statusCode;
    notifyListeners();
  }

  //-------------------------------------------------------> POST NEW COMMENT

  Future<void> postData(CommentsModel body) async {
    postDataLoading = true;
    notifyListeners();

    try {
      http.Response response = await postComment(body);

      if (response.statusCode == 201) {
        isBack = true;
        responseCode = response.statusCode;
      } else {
        print('Unexpected status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error posting data: $e');
    }

    postDataLoading = false;
    responseCode;
    notifyListeners();
  }

  //------------------------------------------------------> EDIT A COMMENT

  Future<void> editCommentProvider(CommentsModel body, String id) async {
    isLoading = true;

    notifyListeners();

    try {
      http.Response response = await putComment(body, id);

      if (response.statusCode == 200) {
        isBack = true;
        responseCode = response.statusCode;
        print(isBack);

        print("puted");
      } else {
        print('Unexpected status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error posting data: $e');
    }

    isLoading = false;
    responseCode;
    notifyListeners();
  }
}

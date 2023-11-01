import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_app/api_services/comments_api.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_app/model/comments_model.dart';
import 'package:http/http.dart' as http;

class AddCommentNew extends StatefulWidget {
  const AddCommentNew(
      {super.key, required this.editMode, required this.postId});

  final bool editMode;
  final int postId;

  @override
  State<AddCommentNew> createState() => _AddCommentState();
}

class _AddCommentState extends State<AddCommentNew> {
  List<CommentsModel> currentComment = [];

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    try {
      final List<CommentsModel> fetchedPosts = await ApiServices.fetchPosts();

      // Filter comments with postId of 4
      final filteredComments = fetchedPosts
          .where((comment) => comment.id == widget.postId + 1)
          .toList();

      setState(() {
        currentComment = filteredComments;
        print(filteredComments);
        print("555555555555555555");

        if (filteredComments.isNotEmpty) {
          nameController.text = filteredComments[0].name;
          emailController.text = filteredComments[0].email;
          bodyController.text = filteredComments[0].body;
        }
      });
    } catch (e) {
      print('Error fetching posts: $e');
    }
  }

  Future<void> _editPost(String postId) async {
    final url = 'https://jsonplaceholder.typicode.com/posts/$postId';
    final uri = Uri.parse(url);

    final response = await http.put(
      uri,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        "postId": 501,
        "id": idController.text,
        " name": nameController.text,
        " email": emailController.text,
        "body": bodyController.text,
      }),
    );

    if (response.statusCode == 200) {
      print('-------------------------------------------------------------');
      print('Post edited successfully:--- response code = 200');
      print('Edited Post ID: $postId');
      print('-------------------------------------------------------------');
    } else {
      print('Failed to edit post');
    }
  }

  TextEditingController idController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController bodyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Comment'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            controller: idController,
            decoration: const InputDecoration(
              labelText: 'ID',
            ),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'EMAIL'),
          ),
          TextField(
            controller: emailController,
            decoration: const InputDecoration(
              labelText: 'E MAIL',
            ),
          ),
          TextField(
            controller: bodyController,
            decoration: const InputDecoration(labelText: 'BODY'),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text('CANCEL'),
        ),
        ElevatedButton(
          onPressed: () {
            _editPost(currentComment[0].id.toString());
          },
          child: const Text('ADD COMMENT'),
        ),
      ],
    );
  }
}

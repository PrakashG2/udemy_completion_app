import 'package:flutter/material.dart';
import 'package:my_app/api_services/comments_api.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_app/model/comments_model.dart';

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

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController bodyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Comment'),
      content: FutureBuilder(
        future: fetchPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snap) {
            
          }
        }
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text('CANCEL'),
        ),
        ElevatedButton(
          onPressed: () {},
          child: const Text('ADD COMMENT'),
        ),
      ],
    );
  }
}

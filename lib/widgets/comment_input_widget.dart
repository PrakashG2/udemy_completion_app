import 'package:api_prov_try/provider/comments_data_class.dart';
import 'package:api_prov_try/models/comments_model.dart';
import 'package:api_prov_try/tabs/comments_tab.dart';
import 'package:api_prov_try/widgets/snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

class CommentInput extends StatefulWidget {
  const CommentInput({super.key, required this.editMode, required this.postId});

  final bool editMode;
  final int postId;

  @override
  State<CommentInput> createState() => _CommentInputState();
}

class _CommentInputState extends State<CommentInput> {
  //---------------------------------------------------------------------> CONTROLLERS

  TextEditingController postIdController = TextEditingController();
  TextEditingController idController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController bodyController = TextEditingController();

  void snackBar(String message, IconData icon) {
    AwesomeSnackbar.show(context, message, icon);
  }

  //---------------------------------------------------------------------> INIT
  @override
  void initState() {
    super.initState();
    if (widget.editMode) {
      final commentsProvider =
          Provider.of<CommentsProvider>(context, listen: false);
      setState(() {
        final comment = commentsProvider.commentsList![widget.postId];
        postIdController.text = comment.postId.toString();
        idController.text = comment.id.toString();
        nameController.text = comment.name;
        emailController.text = comment.email;
        bodyController.text = comment.body;
      });
    }
  }

  //-------------------------------------------------------------------------> PUT DATA
  Future<void> _editComment(String commentId) async {
    try {
      CommentsModel data = CommentsModel(
        postId: int.parse(postIdController.text),
        id: int.parse(idController.text),
        name: emailController.text,
        email: nameController.text,
        body: bodyController.text,
      );

      var response = Provider.of<CommentsProvider>(context, listen: false);
      await response.editCommentProvider(data, commentId);

      if (response.responseCode == 200) {
        snackBar("COMMENT EDITED SUCCESSFULLY", Icons.thumb_up_rounded);
      } else {
        print(
            'ERROR @_editComment PROVIDER RESPONSE *****: ${response.responseCode}');
        snackBar("SOMETHING WENT WRONG", Icons.thumb_down_rounded);
      }
    } catch (e) {
      print('ERROR EDITING COMMENT *****: $e');
    }
  }

  //----------------------------------------------------------------------> POST DATA
  Future<void> _addComment() async {
    try {
      CommentsModel addCommentData = CommentsModel(
        postId: int.parse(postIdController.text),
        id: int.parse(idController.text),
        name: nameController.text,
        email: emailController.text,
        body: bodyController.text,
      );

      var provider = Provider.of<CommentsProvider>(context, listen: false);
      await provider.postData(addCommentData);

      if (provider.responseCode == 201) {
        // ignore: use_build_context_synchronously
        AwesomeSnackbar.show(context, "Success", Icons.thumb_up_rounded);
      } else {
        // ignore: use_build_context_synchronously
        AwesomeSnackbar.show(context, 'Something went wrong', Icons.warning);
      }
    } catch (e) {
      print('ERROR ADDING COMMENT *****: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final commentsProvider = Provider.of<CommentsProvider>(context);

    if (commentsProvider.isLoading) {
      if (widget.editMode == true && commentsProvider.responseCode == 200 ||
          widget.editMode == false && commentsProvider.responseCode == 201) {
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => CommentsTab()));
        });
      }

      return const AlertDialog(
        content: SizedBox(
          height: 50,
          width: 50,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return AlertDialog(
      title: widget.editMode
          ? const Text("EDIT COMMENT")
          : const Text("ADD NEW COMMENT"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            controller: postIdController,
            decoration: const InputDecoration(
              labelText: 'POST ID',
            ),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: idController,
            decoration: const InputDecoration(
              labelText: 'ID',
            ),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'NAME'),
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
            if (widget.editMode) {
              _editComment((widget.postId + 1).toString());
            } else {
              _addComment();
            }
          },
          child: const Text('ADD COMMENT'),
        ),
      ],
    );
  }
}

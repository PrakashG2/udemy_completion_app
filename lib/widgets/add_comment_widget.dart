import 'package:flutter/material.dart';
import 'package:my_app/api_services/comments_api.dart';
import 'package:my_app/providers/comments_provider.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddComment extends ConsumerWidget {
  const AddComment({super.key, required this.editMode, required this.postId});

  final bool editMode;
  final int postId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commentsData = ref.watch(dataProvider);

    

    TextEditingController nameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController bodyController = TextEditingController();

    return commentsData.when(
        data: (data) {
          return FutureBuilder(
              future: ApiServices.fetchPosts(),
              builder: (context, snapshot) {
                final comentsData = snapshot.data;
                return AlertDialog(
                  title: const Text('Add New Comment'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const TextField(
                        decoration: InputDecoration(
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
                      onPressed: () {},
                      child: const Text('ADD COMMENT'),
                    ),
                  ],
                );
              });
        },
        error: (error, s) {
          return Text(error.toString());
        },
        loading: () => CircularProgressIndicator());
  }
}

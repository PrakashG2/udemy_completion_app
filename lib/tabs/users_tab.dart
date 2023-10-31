import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_app/api_services/comments_api.dart';
import 'package:my_app/model/comments_model.dart';
import 'package:my_app/providers/comments_provider.dart';
import 'package:my_app/widgets/add_comment_widget.dart'; // Assuming you've named the file comments_provider.dart

class UsersTab extends ConsumerWidget {
  const UsersTab({Key? key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<List<CommentsModel>>(
      future: ApiServices.fetchPosts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No comments available'));
        } else {
          final List<CommentsModel> commentsData = snapshot.data!;
          return ListView.builder(
              itemCount: commentsData.length,
              itemBuilder: ((context, index) {
//-----------------------------------------------> TO PROCESS THE NAME
                String truncatedName = commentsData[index].name.length > 20
                    ? '${commentsData[index].name.substring(0, 20)}...' // Adjust the character limit as needed
                    : commentsData[index].name;

                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(255, 212, 208, 208),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.blue,
                                child: Text(
                                  commentsData[index].name[0].toUpperCase(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              const SizedBox(
                                  width:
                                      10), // Add some spacing between the avatar and text
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(truncatedName),
                                  Text(
                                    commentsData[index].email,
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 85, 81, 81),
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AddComment(
                                              editMode: true,
                                              postId: index,
                                            ); // Show the AddComment dialog
                                          },
                                        );
                                      },
                                      icon: const Icon(Icons.edit))
                                ],
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: SingleChildScrollView(
                              child: Text(
                                commentsData[index].body,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }) // Display the first comment's name
              );
        }
      },
    );
  }
}

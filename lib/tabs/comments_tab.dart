import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_app/api_services/comments_api.dart';
import 'package:my_app/model/comments_model.dart';

import 'package:http/http.dart' as http;
import 'package:my_app/widgets/add_comment_new.dart';
import 'package:my_app/widgets/add_comment_widget.dart';

class CommentsTab extends StatefulWidget {
  const CommentsTab({super.key});

  @override
  State<CommentsTab> createState() => _CommentsTabState();
}

class _CommentsTabState extends State<CommentsTab> {
  List<CommentsModel> posts = [];

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  Future<void> _fetchPosts() async {
    try {
      final List<CommentsModel> fetchedPosts = await ApiServices.fetchPosts();
      setState(() {
        posts = fetchedPosts;
      });
    } catch (e) {
      print('Error fetching posts: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (posts.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      body: ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
//-----------------------------------------------> TO PROCESS THE NAME
            String truncatedName = posts[index].name.length > 20
                ? posts[index].name.substring(0, 20) +
                    '...' // Adjust the character limit as needed
                : posts[index].name;

            return Padding(
              padding: EdgeInsets.all(10),
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
                              posts[index].name[0].toUpperCase(),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          SizedBox(
                              width:
                                  10), // Add some spacing between the avatar and text
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(truncatedName),
                              Text(
                                posts[index].email,
                                style: TextStyle(
                                  color: Color.fromARGB(255, 85, 81, 81),
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AddCommentNew(
                                          editMode: true,
                                          postId: index,
                                        ); // Show the AddComment dialog
                                      },
                                    );
                                  },
                                  icon: Icon(Icons.edit))
                            ],
                          )
                        ],
                      ),
                    ),
                    Expanded(
                        child: Padding(
                      padding: EdgeInsets.all(10),
                      child: SingleChildScrollView(
                        child: Text(
                          posts[index].body,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    )),
                  ],
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AddComment(
                editMode: false,
                postId: 0,
              ); // Show the AddComment dialog
            },
          );
        },
      ),
    );
  }
}

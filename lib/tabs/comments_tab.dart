import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_app/model/comments_model.dart';

import 'package:http/http.dart' as http;

class CommentsTab extends StatefulWidget {
  const CommentsTab({super.key});

  @override
  State<CommentsTab> createState() => _CommentsTabState();
}

class _CommentsTabState extends State<CommentsTab> {
  List<CommentsModel> posts =
      []; //to store the fetched data and acess it for ui updation...

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  Future<void> _fetchPosts() async {
    const url = 'https://jsonplaceholder.typicode.com/comments';
    final uri = Uri.parse(url);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList =
          jsonDecode(response.body); //decode json to dart objects
      final List<CommentsModel> fetchedPosts = jsonList
          .map((json) => CommentsModel.fromJson(json))
          .toList(); //mapping the fetched datas to model class
      setState(() {
        posts = fetchedPosts;
        print(posts);
      });
    } else {
      print('Failed to fetch posts');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (posts.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
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
                          Text(posts[index].name),
                          Text(
                            posts[index].email,
                            style: TextStyle(
                              color: Color.fromARGB(255, 85, 81, 81),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  // Use Expanded to allow the text to take up remaining space
                  child: SingleChildScrollView(
                    child: Text(posts[index].body),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

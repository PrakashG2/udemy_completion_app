import 'package:flutter/material.dart';
import 'package:my_app/tabs/comments_tab.dart';
import 'package:my_app/tabs/users_tab.dart';



class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("API"),
          centerTitle: true,
          actions: [IconButton(onPressed: () {}, icon: Icon(Icons.add))],
        ),
        body: const Column(
          children: [
            TabBar(
              tabs: [
                Icon(
                  Icons.badge_outlined,
                  color: Colors.red,
                ),
                Icon(
                  Icons.comment,
                  color: Colors.red,
                )
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  UsersTab(),
                  CommentsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:async';

import 'package:api_prov_try/tabs/comments_tab.dart';
import 'package:api_prov_try/tabs/users_tab.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:local_auth/local_auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final LocalAuthentication auth;
  bool support = false;
  bool authenticated = false;

  late StreamSubscription interntSubscription;
  bool hasInternet = false;

  //-------------------------------------------------------------> INIT

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    var interntSubscription =
        InternetConnectionChecker().onStatusChange.listen((status) {
      setState(() {
        hasInternet = status == InternetConnectionStatus.connected;
        print(hasInternet);
      });
      _checkInternet();
    });
  }

  void _checkInternet() {
    if (!hasInternet) {
      _showNoInternetDialog();
    }
  }

  void _showNoInternetDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Oops !'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.cloud_off, size: 28, color: Colors.red),
              SizedBox(height: 16),
              Center(
                child: Text(
                  'NO INTERNET CONNECTIVITY',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('RETRY'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _checkInternet();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "UDEMY FLUTTER COURSE COMPLETION APP",
            style: TextStyle(fontSize: 15),
          ),
        ),
        body: Column(
          children: [
            const SizedBox(height: 5),
            Padding(
              padding: EdgeInsets.all(10),
              child: Container(
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 211, 209, 209),
                    borderRadius: BorderRadius.circular(50)),
                child: Column(
                  children: [
                    TabBar(
                      padding: const EdgeInsets.all(5),
                      tabs: [
                        const Icon(
                          Icons.people_rounded,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          child: const Icon(
                            Icons.question_answer_rounded,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ],
                      indicator: BoxDecoration(
                        color: Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Expanded(
              child: TabBarView(
                children: [UsersTab(), CommentsTab()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

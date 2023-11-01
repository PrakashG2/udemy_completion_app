import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:my_app/tabs/comments_tab.dart';
import 'package:my_app/tabs/users_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final LocalAuthentication auth;
  bool support = false;
  bool authenticated = false;

  @override
  void initState() {
    auth = LocalAuthentication();
    auth.isDeviceSupported().then((bool isSupported) {
      setState(() {
        support = isSupported;
        _autheticate();
      });
      print("Biometric authentication support: $support");
    });
    super.initState();
  }

  void _autheticate() async {
    try {
      authenticated = await auth.authenticate(
          localizedReason: "A U T H E N T I C A T I O N   T E S T",
          options: AuthenticationOptions(stickyAuth: true));
      if (authenticated) {
        setState(() {
          this.authenticated = true;
        });
      }
    } on PlatformException catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!authenticated) {
      return Center(
        child: Text("AUTHENTICATION FAILED"),
      );
    } else {
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
}

import 'package:api_prov_try/provider/comments_data_class.dart';
import 'package:api_prov_try/provider/users_provider.dart';
import 'package:api_prov_try/screens/authentication_screen.dart';
import 'package:api_prov_try/screens/homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CommentsProvider()),
        ChangeNotifierProvider(create: (context) => UsersProvider()),
      ],
      child: const MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'UDEMY APP',
          home: HomeScreen()),
    );
  }
}

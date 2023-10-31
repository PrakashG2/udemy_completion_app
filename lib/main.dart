import 'package:flutter/material.dart';
import 'package:my_app/screens/home_screen.dart';

//imports
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    const ProviderScope( //-------> wrapping myapp within provider scope to use providers inside the whole app
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "API",
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

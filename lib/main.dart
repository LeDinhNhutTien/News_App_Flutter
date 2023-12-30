import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_news_app/page/user/AuthWrapper.dart';
import 'package:flutter_news_app/page/user/userauth.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserAuth(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(),
        home:  AuthWrapper(), // Use AuthWrapper here
      ),
    );
  }
}
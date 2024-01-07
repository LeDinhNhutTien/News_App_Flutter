import 'package:flutter/material.dart';
import 'package:flutter_news_app/page/admin/HomeAdmin.dart';
import 'package:flutter_news_app/page/home/news_page.dart';
import 'package:flutter_news_app/page/user/AuthWrapper.dart';
import 'package:flutter_news_app/page/user/userauth.dart';
import 'package:provider/provider.dart';


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
        home:  AdminApp(), // Use AuthWrapper here
      ),
    );
  }
}
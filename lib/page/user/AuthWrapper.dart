import 'package:flutter/material.dart';
import 'package:flutter_news_app/page/admin/HomeAdmin.dart';

import 'package:flutter_news_app/page/user/google.dart';
import 'package:flutter_news_app/page/user/profile.dart';
import 'package:flutter_news_app/page/user/userauth.dart';
import 'package:provider/provider.dart';

import 'package:flutter_news_app/page/user/login.dart';
class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userAuth = Provider.of<UserAuth>(context);

    if (userAuth.isLoggedIn) {
      // Assuming 'isAdmin' key exists, it will return its value, otherwise it defaults to 3.
      final isAdmin = userAuth.userData['isAdmin'] ?? 2;

      switch (isAdmin) {
        case 0:
          return AdminApp(); // Admin user
        case 1:
          return Profile(userData: userAuth.userData);
        case 2:
          return SignInDemo();
        default:

          return Login();
      }
    } else {
      return Login();
    }
  }
}
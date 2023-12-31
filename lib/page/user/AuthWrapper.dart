import 'package:flutter/material.dart';
import 'package:flutter_news_app/page/admin/HomeAdmin.dart';
import 'package:flutter_news_app/page/user/profile.dart';
import 'package:flutter_news_app/page/user/userauth.dart';
import 'package:provider/provider.dart';

import 'package:flutter_news_app/page/user/login.dart';
class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userAuth = Provider.of<UserAuth>(context);
    if (userAuth.isLoggedIn) {
      final isAdmin = userAuth.userData['isAdmin'] ?? 0; // Giả định rằng giá trị mặc định là 0 nếu không có thông tin.
      print(isAdmin);
      if (isAdmin == 0) {

        return AdminApp();
      } else {

        return Profile(userData: userAuth.userData);
      }
    } else {
      return Login();
    }
  }
}
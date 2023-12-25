import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../model/Category.dart';
import 'HomeAdmin.dart';
import 'NewsManager.dart';
import 'TheGioi.dart';
import 'TrongNuoc.dart';
import 'UserAdmin.dart';

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: [
          Container(
            height: 0,
            color: Colors.blueGrey[800],
          ),
          ListTile(
            title: const Text('Home'),
            onTap: () {
              // Handle when the user taps on the Home menu item
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AdminApp()),
              );
            },
          ),
          ListTile(
            title: const Text('Quản lý báo trong nước'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TrongNuoc()),
              );
            },
          ),
          ListTile(
            title: const Text('Quản lý báo ngoài nước'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NewsTheGioi()),
              );
            },
          ),
          ListTile(
            title: const Text('Quản lý người dùng'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UserAdmin()),
              );
            },
          ),

          ListTile(
            title: const Text('Danh sách bài báo'),
            onTap: () {
              // Handle when the user taps on the Danh sách bài báo menu item
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NewsManager()),
              );
            },
          ),
        ],
      ),
    );
  }
}
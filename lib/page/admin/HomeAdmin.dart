import 'package:flutter/material.dart';
import 'package:flutter_news_app/page/admin/managmentNews/NewsManager.dart';

import 'loadNews/TrongNuoc.dart';
import 'managmentUser/UserAdmin.dart';

void main() {
  runApp(const AdminApp());
}

class AdminApp extends StatelessWidget {
  const AdminApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AdminHomePage(),
    );
  }
}

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  bool isMenuOpen = false;

  void toggleMenu() {
    setState(() {
      isMenuOpen = !isMenuOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Home'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: toggleMenu,
        ),
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.grey[200],
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Main Content',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Additional Component',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),

                ],
              ),
            ),
          ),
          if (isMenuOpen)
            const NavigationDrawer(),
        ],
      ),
    );
  }
}
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
            title: const Text('Duyệt báo mới'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TrongNuoc()),
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

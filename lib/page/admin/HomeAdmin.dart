import 'package:flutter/material.dart';
import 'package:flutter_news_app/page/admin/managmentNews/NewsManager.dart';
import 'package:flutter_news_app/page/home/news_page.dart';
import 'package:flutter_news_app/page/user/login.dart';
import 'package:flutter_news_app/page/user/profile.dart';
import 'package:flutter_news_app/page/user/userauth.dart';
import 'package:flutter_news_app/page/widget/home_widget.dart';
import 'package:flutter_news_app/page/widget/lottery.dart';
import 'package:provider/provider.dart';

import 'loadNews/DuyetBaoMoi.dart';
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
  int _currentIndex = 0;
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
                    'Chào mừng bạn đã trở lại',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Quản lý báo mỗi ngày',
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
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.widgets),
            label: 'Widget',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Personal',
          ),
        ],
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          switch (index) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NewsPage()),
              );
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Home_Widget()),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Lottery()),
              );
              break;
            case 3:
              final userAuth = Provider.of<UserAuth>(context, listen: false);
              if (userAuth.isLoggedIn) {
                final isAdmin = userAuth.userData['isAdmin'] ?? 0;
                if(isAdmin == 1){
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Profile(userData: userAuth.userData), // Pass the userData here
                    ),
                  );
                }
                else{
                  if(isAdmin== 0){
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AdminApp(), // Pass the userData here
                      ),
                    );
                  }
                }

              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );
              }
              break;
          }
        },
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
                MaterialPageRoute(builder: (context) => const DuyetBaoMoi()),
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
          ListTile(
            title: const Text('Đăng Xuất'),
            onTap: () {
              // Handle when the user taps on the Danh sách bài báo menu item
              Provider.of<UserAuth>(context, listen: false).logout();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );
            },
          ),
        ],
      ),

    );

  }
}

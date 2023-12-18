import 'package:flutter/material.dart';
import 'package:flutter_news_app/page/home/news_page.dart';
import 'package:flutter_news_app/page/user/Input.dart';
import 'package:flutter_news_app/page/user/mybutton.dart';
import 'package:flutter_news_app/page/user/square.dart';
import 'package:flutter_news_app/page/widget/home_widget.dart';
import 'package:flutter_news_app/page/widget/lottery.dart';


// Make sure this class is a StatefulWidget if you want to update the current index
class Login extends StatefulWidget {
  Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  int _currentIndex = 0; // Initial index for the bottom navigation
  final username = TextEditingController();
  final password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Icon(Icons.lock, size: 100),
              const SizedBox(height: 30),
              Text(
                'Welcome to app',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(height: 20),
              Input(
                controller: username,
                hintText: 'username',
                obscureText: false,
              ),
              const SizedBox(height: 40),
              Input(
                controller: password,
                hintText: 'password',
                obscureText: true,
              ),
              const SizedBox(height: 10), // Khoảng cách chiều cao

// forgot password?
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end, // Căn chỉnh text về phía cuối của hàng (bên phải)
                  children: [
                    Text(
                      'Forgot Password?',
                      style: TextStyle(color: Colors.blueAccent), // Màu xám đậm cho chữ
                    ),
                  ],
                ),
              ),
              //button đăng nhập
              const SizedBox(height: 25),
              MyButton(onTap: Sign),
              const SizedBox(height: 15),

// or continue with
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ), // Expanded
                    Text('Or continue with'),
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ), // Expanded
                  ],
                ), // Row
              ), // Padding
              const SizedBox(height: 10),

// google + apple sign in buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  // google button
                  SquareTile(imagePath: 'images/search.png'),

                  SizedBox(width: 25),

                  // apple button
                  SquareTile(imagePath: 'images/github.png'),
                ],
              ), // Row
              const SizedBox(height: 15),

// not a member? register now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Not a account?'),
                  const SizedBox(width: 4),
                  Text(
                    'Register now.',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ), // Text
                ],
              ), // Row
            ],
          ),
        ),
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );
              break;
          }
        },
      ),
    );
  }
void Sign(){

}

}
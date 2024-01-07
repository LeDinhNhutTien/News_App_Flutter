import 'dart:async';
import 'dart:convert';

import 'package:email_auth/email_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app/page/admin/HomeAdmin.dart';
import 'package:flutter_news_app/page/history/histories.dart';
import 'package:flutter_news_app/page/home/news_page.dart';
import 'package:flutter_news_app/page/user/EmailTOtp.dart';
import 'package:flutter_news_app/page/user/Input.dart';

import 'package:flutter_news_app/page/user/google.dart';

import 'package:provider/provider.dart';
import 'package:flutter_news_app/page/user/userauth.dart';
import 'package:flutter_news_app/page/user/profile.dart';
import 'package:flutter_news_app/page/user/profile.dart';
import 'package:flutter_news_app/page/user/register.dart';
import 'package:flutter_news_app/page/user/square.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_news_app/page/widget/home_widget.dart';
import 'package:flutter_news_app/page/widget/lottery.dart';

import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  Login({super.key});

  @override
  _LoginState createState() => _LoginState();

}


class _LoginState extends State<Login> {
  int _currentIndex = 0; // Initial index for the bottom navigation
  final email = TextEditingController();
  final password = TextEditingController();
  String emailError = '';
  String passwordError = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),

      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView( // Wrap the content with SingleChildScrollView
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
                // Email error message
                if (emailError.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(left: 25.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        emailError,
                        style: TextStyle(color: Colors.red, fontSize: 14),
                      ),
                    ),
                  ),
                Input(
                  controller: email,
                  hintText: 'email',
                  obscureText: false,
                ),
                const SizedBox(height: 40),
                // Password error message
                if (passwordError.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        passwordError,
                        style: TextStyle(color: Colors.red, fontSize: 14),
                      ),
                    ),
                  ),
                Input(
                  controller: password,
                  hintText: 'password',
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                // Forgot password
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          sendOTP();
                        },
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(color: Colors.blueAccent),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // Login button
                ElevatedButton(
                  onPressed: () {
                    login();
                  },
                  child: Text('Đăng nhập'),
                ),
                const SizedBox(height: 15),
                // Divider with text
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                      Text('Or continue with'),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                // Social media sign-in buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: ()  {
                        // This context now has the Provider above it


                          Provider.of<UserAuth>(context, listen: false).setLoggedIn(true, userData: null);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignInDemo()),
                        );
                      },
                      child: SquareTile(imagePath: 'images/search.png'),
                    ),

                    const SizedBox(width: 25), // Make sure to keep constants for fixed widgets
                    SquareTile(imagePath: 'images/github.png'), // Assuming this is another tappable widget
                  ],
                ),
                const SizedBox(height: 15),
                // Register link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Not a member? '),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Register()),
                        );
                      },
                      child: Text(
                        'Register now.',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
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
                MaterialPageRoute(builder: (context) => Histories()),
              );
              break;
            case 3:

              final userAuth = Provider.of<UserAuth>(context, listen: false);
              if (userAuth.isLoggedIn) {
                final isAdmin = userAuth.userData['isAdmin'] ?? 2;
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
                  else{
                    if(isAdmin== 2){
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignInDemo(), // Pass the userData here
                        ),
                      );
                    }
                  }
                }

              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>Login()),
                );
              }
              break;
          }
        },
      ),
    );
  }
  /**
   *  mail
   */
  void sendOTP() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => EmailOtp()),
    );
  }
  void login() async {
    setState(() {
      // Clear error messages on new login attempt
      emailError = '';
      passwordError = '';
    });

    var url = "http://192.168.2.15/server/login.php";
    var response = await http.post(
      Uri.parse(url),
      body: {
        'email': email.text,
        'password': password.text,
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data["result"] == "success") {
        /**
         * lấy user
         */
        var userData = data['user'];
        print('User Data: $userData');
        int isAdmin = userData['isAdmin'] ?? 0;
        print(isAdmin);
        setState(() {
          Provider.of<UserAuth>(context, listen: false).setLoggedIn(true, userData: userData);


        });
        if(isAdmin ==0){
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => AdminApp(), // Pass the userData here
            ),
          );
        }else{
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>Profile(userData: userData), // Pass the userData here
            ),
          );
        }


        // Navigate to the profile page or home page
      } else {
        // If login fails, set the appropriate error message
        setState(() {
          if (data["message"].contains("User not found")) {
            emailError = 'Mail không tồn tại.';
          } else if (data["message"].contains("Invalid password")) {
            passwordError = 'password not found';
          } else {
            emailError = 'Login failed. Please try again.';
            passwordError = 'Login failed. Please try again.';
          }
        });
      }
    } else {
      // Handle non-200 responses
      setState(() {
        emailError = 'Error occurred while communicating with the server.';
        passwordError = 'Error occurred while communicating with the server.';
      });
    }
  }


}

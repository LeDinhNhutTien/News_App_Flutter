import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app/page/history/histories.dart';
import 'package:flutter_news_app/page/home/news_page.dart';
import 'package:flutter_news_app/page/user/Input.dart';
import 'package:flutter_news_app/page/user/MyButtonConfirm.dart';
import 'package:flutter_news_app/page/user/login.dart';
import 'package:flutter_news_app/page/user/userauth.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_news_app/page/user/mybuttonsignup.dart';

import 'package:flutter_news_app/page/widget/home_widget.dart';
import 'package:flutter_news_app/page/widget/lottery.dart';
import 'package:password_strength_checker/password_strength_checker.dart';
import 'package:provider/provider.dart';


// Make sure this class is a StatefulWidget if you want to update the current index
class ChanPass extends StatefulWidget {
  ChanPass({super.key});

  @override
  _RegsterState createState() => _RegsterState();
}

class _RegsterState extends State<ChanPass> {
  int _currentIndex = 0; // Initial index for the bottom navigation
  final old_pass = TextEditingController();
  final password = TextEditingController();
  final conpassword = TextEditingController();
  String emailError = '';
  String passwordError = '';
  String conPasswordError = '';
  PasswordStrength passwordStrength = PasswordStrength.weak;
  String registrationMessage = '';

  Widget build(BuildContext context) {
    UserAuth  userAuth = Provider.of<UserAuth>(context, listen: false);
    final id = userAuth.userData['id'].toString() ;
    print('nay la id' +id);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView( // Wrap with SingleChildScrollView
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              // Add this line to prevent Column from stretching
              children: [
                Icon(Icons.password, size: 100),
                const SizedBox(height: 30),
                Text(
                  'Đổi mật khẩu',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(height: 20),
                emailError.isNotEmpty ?
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      emailError,
                      style: TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  ),
                ) : SizedBox.shrink(),

                registrationMessage.isNotEmpty ?
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      registrationMessage,
                      style: TextStyle(color: Colors.green, fontSize: 14),
                    ),
                  ),
                ): SizedBox.shrink(),


                Input(
                  controller: old_pass,
                  hintText: 'Mật khẩu cũ',
                  obscureText: true,
                ),
                const SizedBox(height: 40),
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
                  hintText: 'Mật khẩu mới',
                  obscureText: true,
                ),
                const SizedBox(height: 40),
                if (conPasswordError.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        conPasswordError ,
                        style: TextStyle(color: Colors.red, fontSize: 14),
                      ),
                    ),
                  ),
                Input(
                  controller:conpassword,
                  hintText: 'xác nhận mật khẩu',
                  obscureText: true,
                ),
                SizedBox(height: 16.0),
                const SizedBox(height: 10), // Khoảng cách chiều cao


                //button đăng nhập
                const SizedBox(height: 25),
                MyButtonConfirm(onTap: () {
                  registerUser(id);
                }),
                const SizedBox(height: 15),
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChanPass()),
              );
              break;
          }
        },
      ),
    );
  }


  Future<void> registerUser(String userId) async {
    // Clear any existing errors
    setState(() {
      emailError = '';
      passwordError = '';
      conPasswordError = '';
      registrationMessage = '';
    });

    // Validate email


    // Validate password strength
    passwordStrength = checkPasswordStrength(password.text);
    final isPasswordStrongEnough = passwordStrength == PasswordStrength.strong;
    if (!isPasswordStrongEnough) {
      setState(() {
        passwordError = 'Mật khẩu không đúng yêu cầu.';
      });
      return; // Stop further processing if the password is not strong enough
    }

    // Check if passwords match
    if (conpassword.text != password.text) {
      setState(() {
        conPasswordError = 'Mật khẩu không trùng khớp.';
      });
      return; // Stop further processing if the passwords do not match
    }
    String old = md5.convert(utf8.encode(old_pass.text.trim())).toString();
    String hashedPassword = md5.convert(utf8.encode(password.text.trim())).toString();
    // If all validations pass, make the network call
    final String url = "http://172.30.80.1/server/changlePassword.php";
    final response = await http.post(
      Uri.parse(url),
      body: {
        'userid': userId,
        'old_password': old,
        'new_password': hashedPassword,
      },
    );

    // Handle the response
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data.containsKey("message")) {
        setState(() {
          registrationMessage = data["message"];
        });
      } else if (data.containsKey("error")) {
        setState(() {
          registrationMessage = data["error"];
        });
      }
    } else {
      // Handle the case where the server did not return a 200 OK response
      setState(() {
        registrationMessage = 'There was a problem registering the user.';
      });
    }
  }

  PasswordStrength checkPasswordStrength(String password) {
    final hasUpperCase = RegExp(r'[A-Z]').hasMatch(password);
    final hasLowerCase = RegExp(r'[a-z]').hasMatch(password);
    final hasDigits = RegExp(r'\d').hasMatch(password);
    final hasSpecialCharacters = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);
    final length = password.length;

    if (length < 8 || !hasSpecialCharacters || !hasUpperCase) {
      return PasswordStrength.weak;
    }
    int strength = 0;
    if (hasUpperCase) strength++;
    if (hasLowerCase) strength++;
    if (hasDigits) strength++;
    if (strength == 0) {
      return PasswordStrength.weak;
    } else if (strength == 5) {
      return PasswordStrength.medium;
    }
    return PasswordStrength.strong;
  }
}
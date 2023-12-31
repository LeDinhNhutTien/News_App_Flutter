import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app/page/admin/HomeAdmin.dart';
import 'package:flutter_news_app/page/history/histories.dart';
import 'package:flutter_news_app/page/home/news_page.dart';
import 'package:flutter_news_app/page/user/Input.dart';
import 'package:flutter_news_app/page/user/buttonedit.dart';
import 'package:flutter_news_app/page/user/google.dart';
import 'package:flutter_news_app/page/user/login.dart';
import 'package:flutter_news_app/page/user/profile.dart';
import 'package:flutter_news_app/page/user/userauth.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_news_app/page/user/mybuttonsignup.dart';

import 'package:flutter_news_app/page/widget/home_widget.dart';
import 'package:flutter_news_app/page/widget/lottery.dart';
import 'package:intl_phone_field_with_validator/intl_phone_field.dart';
import 'package:password_strength_checker/password_strength_checker.dart';
import 'package:provider/provider.dart';


// Make sure this class is a StatefulWidget if you want to update the current index
class Edit extends StatefulWidget {
  Edit({super.key});

  @override
  _RegsterState createState() => _RegsterState();
}

class _RegsterState extends State<Edit> {
  int _currentIndex = 0; // Initial index for the bottom navigation
  final name = TextEditingController();
  final Address = TextEditingController();
  final numberphone = TextEditingController();
  String success = '';
  String passwordError = '';
  String conPasswordError = '';

  String registrationMessage = '';

  Widget build(BuildContext context) {
    final userAuth = Provider.of<UserAuth>(context, listen: false);
    final id = userAuth.userData['id'].toString() ;
    print(id);
    return Scaffold(
      appBar: AppBar(
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
                Icon(Icons.edit, size: 100),
                const SizedBox(height: 30),
                Text(
                  'Chỉnh sửa hồ sơ cá nhân',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(height: 20),

                if (success.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        success,
                        style: TextStyle(color: Colors.green, fontSize: 14),
                      ),
                    ),
                  ),
                Input(
                  controller: name,
                  hintText: 'Tên người dùng',
                  obscureText: false,
                ),
                const SizedBox(height: 40),
                Input(
                  controller: Address,
                  hintText: 'địa chỉ',
                  obscureText: false,
                ),
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0), // Điều chỉnh padding để khớp với các Input khác
                  child: IntlPhoneField(
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                    ),
                    initialCountryCode: 'IN',
                    onChanged: (phone) {
                      numberphone.text = phone.completeNumber;
                    },
                  ),
                ),
                SizedBox(height: 16.0),
                const SizedBox(height: 10), // Khoảng cách chiều cao

// forgot password?

                //button đăng nhập
                const SizedBox(height: 25),
                MyButtonEdit(onTap: () => updateUserProfile(id,userAuth )),
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
                  MaterialPageRoute(builder: (context) => Login()),
                );
              }
              break;
          }
        },
      ),
    );
  }

  void updateUserProfile(String userId, UserAuth userAuth) async {
    var url = Uri.parse('http://172.27.240.1/server/editUser.php');
    var response = await http.post(url, body: {
      'id': userId,
      'name': this.name.text,
      'address': this.Address.text,
      'phone': this.numberphone.text,
    });
    setState(() {
      success = '';

    });
    if (response.statusCode == 200) {
      int isAdmin = userAuth.userData['isAdmin'];
     print('is ' + isAdmin.toString());


      userAuth.updateUserData({
        'id':userAuth.userData['id'].toString(),
        'email':userAuth.userData['email'].toString() ,
        'name': name.text,
        'address': Address.text,
        'phone': numberphone.text,
        'isAdmin':isAdmin ,
      });



      setState(() {
          success = 'Thông tin đã được cập nhập.';
        });

    } else {
      print('Failed to update profile.');
    }
  }


}
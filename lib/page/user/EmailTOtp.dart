
import 'dart:convert';
import 'dart:math';

import 'package:email_auth/email_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app/page/history/histories.dart';
import 'package:flutter_news_app/page/home/news_page.dart';
import 'package:flutter_news_app/page/user/Input.dart';
import 'package:flutter_news_app/page/widget/home_widget.dart';
import 'package:flutter_news_app/page/widget/lottery.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:http/http.dart' as http;
class EmailOtp extends StatefulWidget {
  EmailOtp({Key? key}) : super(key: key);

  @override
  _EmailOtpState createState() => _EmailOtpState();
}
String generateRandomPassword({int length = 12}) {
  const String _letters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
  const String _digits = '0123456789';
  const String _punctuation = '!@#';

  // Combine all the characters we want to allow
  String chars = '$_letters$_digits$_punctuation';

  Random rnd = Random.secure();

  return List.generate(length, (index) {
    return chars[rnd.nextInt(chars.length)];
  }).join('');
}

class _EmailOtpState extends State<EmailOtp> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  int _currentIndex = 0;
  String thongbao = '';
  /**
   * tạo mk mới
   */
  var password_nw = generateRandomPassword();
  void sendMail({
    required String recipientEmail,
   
  }) async {
    // change your email here
    String username = 'huynhduythuan668@gmail.com';
    // change your password here
    String password = 'vidaffzhjywdkiyi';
    final smtpServer = gmail(username, password);
    final message = Message()
      ..from = Address(username, 'Mail Service')
      ..recipients.add(recipientEmail)
      ..subject = 'service management center'
      ..text = 'Your new password is:' +password_nw;

    try {
      setState(() {
        thongbao = 'Mật khẩu mới đã được gửi qua email.';
      });
      await send(message, smtpServer);

      updatePassword(password_nw,recipientEmail);

    } catch (e) {
     
        print(e.toString());
      
    }
  }
 
  //create a method to send the Emails
  void sendOtp()async{
    EmailAuth.sessionName = "Test session";
    var data =
    await EmailAuth.sendOtp(receiverMail: _emailController.text);
    if(!data){
      //have your error handling logic here, like a snackbar or popup widget
    }
  }
  //create a bool method to validate if the OTP is true
  bool verify(){
    return(EmailAuth.validate(receiverMail: _emailController.value.text, userOTP: _otpController.value.text));//pass in the OTP typed in
    //This will return you a bool, and you can proceed further after that, add a fail case and a success case (result will be true/false)
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text('Quên mật khẩu'),
        centerTitle: true,
        titleSpacing: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 100.0),
        child: ListView(
          children: [
            if (thongbao.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    thongbao,
                    style: TextStyle(color: Colors.green, fontSize: 14),
                  ),
                ),
              ),
            Input(
              controller: _emailController,
              hintText: 'email',
              obscureText: false,
            ),

            SizedBox(height: 24.0),
            Align( // Use Align to control the alignment of the button
              alignment: Alignment.center,
              child: SizedBox(
                width: 150, // Specify the width of the button
                child: ElevatedButton(
                  onPressed: () {

                    sendMail(recipientEmail: _emailController.text.toString());

                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    shape: StadiumBorder(),
                  ),
                  child: Text('Xác nhận'),
                ),
              ),
            ),
          ],
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
                MaterialPageRoute(builder: (context) => EmailOtp()),
              );
              break;
          }
        },
      ),
    );
  }
  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: FittedBox(
          child: Text(
            message,
            style: const TextStyle(
              fontSize: 10,
            ),
          ),
        ),
      ),
    );
  }
  Future<void> updatePassword(String newPass,String email) async {
    final String url = "http://172.22.208.1/server/updatepassword.php";
    var response = await http.post(
      Uri.parse(url),
      body: {
        'email': email.toString(),
        'new_password': newPass.toString(),
      },
    );

  }


}

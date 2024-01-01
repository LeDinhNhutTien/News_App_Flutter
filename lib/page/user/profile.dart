import 'package:flutter/material.dart';
import 'package:flutter_news_app/page/admin/HomeAdmin.dart';
import 'package:flutter_news_app/page/history/histories.dart';
import 'package:flutter_news_app/page/home/news_page.dart';
import 'package:flutter_news_app/page/user/edit.dart';
import 'package:flutter_news_app/page/user/login.dart';
import 'package:flutter_news_app/page/user/logout.dart';
import 'package:flutter_news_app/page/widget/home_widget.dart';
import 'package:flutter_news_app/page/widget/lottery.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'package:flutter_news_app/page/user/userauth.dart';
class Profile extends StatefulWidget {
  final Map<String, dynamic> userData;
  Profile({super.key, required this.userData});

  @override
  _ProfileState createState() => _ProfileState();
}
    class _ProfileState extends State<Profile> {
      int _currentIndex = 0;

      @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    final email = widget.userData['email'] ?? 'not yet provided';
    final birthdate = widget.userData['name'] ?? 'not yet provided';
    final address = widget.userData['address'] ?? 'not yet provided';
    final phone = widget.userData['phone'] ?? 'not yet provided';
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Trang cá nhân',
          style: Theme.of(context).textTheme.headline4,
        ),
        centerTitle: true, // This centers the title in the AppBar
      ),
      // Body of Scaffold where the rest of your UI would be defined
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(
                width: 60,
                height: 60,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(90),
                  child: const Image(
                    image: AssetImage('images/Account-User-PNG.png'),
                  ),
                ),
              ), // SizedBox
              const SizedBox(height: 10),
              Text(
                email,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 16.0,
                ),
              ),

              const SizedBox(height: 20),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  Edit()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary:  Colors.blueAccent,
                    side: BorderSide.none,
                    shape: const StadiumBorder(),
                  ),
                  child: const Text(
                    'Edit',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ), // SizedBox
              const SizedBox(height: 30),
              const Divider(),
              // ... more widgets might follow
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0), // Added vertical padding
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Email :',
                      style: TextStyle(color: Colors.blueAccent),
                    ),
                    SizedBox(width: 18), // You can add a SizedBox for additional spacing between the label and the email
                    Text(
                      email,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0), // Added vertical padding
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Tên người dùng :',
                      style: TextStyle(color: Colors.blueAccent),
                    ),
                    SizedBox(width: 18), // You can add a SizedBox for additional spacing between the label and the email
                    Text(
                      birthdate,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0), // Added vertical padding
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Addrress :',
                      style: TextStyle(color: Colors.blueAccent),
                    ),
                    SizedBox(width: 18), // You can add a SizedBox for additional spacing between the label and the email
                    Text(
                      address,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0), // Added vertical padding
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Number phone:',
                      style: TextStyle(color: Colors.blueAccent),
                    ),
                    SizedBox(width: 18), // You can add a SizedBox for additional spacing between the label and the email
                    Text(
                      phone,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
             LogOut(onTap: logout ),
            ],
          ),
        ),
      ), // SingleChildScrollView
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
                MaterialPageRoute(builder: (context) =>  Histories()),
              );
              break;

            case 3:
              final userAuth = Provider.of<UserAuth>(context, listen: false);
              if (userAuth.isLoggedIn) {
                final isAdmin = userAuth.userData['isAdmin'] ?? 0;
                print(isAdmin);
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


      void logout() {
        Provider.of<UserAuth>(context, listen: false).logout();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Login()),
              (Route<dynamic> route) => false,
        );
      }

    }
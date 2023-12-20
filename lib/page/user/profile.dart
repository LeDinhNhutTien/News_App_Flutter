import 'package:flutter/material.dart';
import 'package:flutter_news_app/page/user/logout.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
class Profile extends  StatelessWidget {
   const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            // Implement your go back logic, usually Navigator.pop(context)
            Navigator.pop(context);
          },
          icon: FaIcon(FontAwesomeIcons.arrowLeft),
        ),
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
                'huynhduythuan668@gmail.com',
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
                    // TODO: implement button press logic
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
                      'huynhduythuan668@gmail.com',
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
                      'Ngày sinh :',
                      style: TextStyle(color: Colors.blueAccent),
                    ),
                    SizedBox(width: 18), // You can add a SizedBox for additional spacing between the label and the email
                    Text(
                      '13/01',
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
                      'Dĩ An - Bình Dương',
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
                      '0339171545',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
             LogOut(onTap: Lougout ),
            ],
          ),
        ),
      ), // SingleChildScrollView

    );
  }
   void Lougout(){

   }
}
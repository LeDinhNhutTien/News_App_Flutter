import 'package:flutter/material.dart';
import 'package:flutter_news_app/page/user/login.dart';
import 'package:flutter_news_app/page/user/profile.dart';
import 'package:flutter_news_app/page/widget/translate.dart';

import '../home/news_page.dart';
import 'chat_screen.dart';
import 'lottery.dart';

class Home_Widget extends StatefulWidget {
  const Home_Widget({super.key});

  @override
  _Home_WidgetState createState() => _Home_WidgetState();
}

class _Home_WidgetState extends State<Home_Widget> {
  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 200, 220, 239),
          title: const Text("Tiện ích"),
          centerTitle: true,
        ),
        body: Container(
          margin: const EdgeInsets.only(top: 45.0),
          child: MyGrid(),
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
            // Use Navigator to navigate to the corresponding pages
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
                  MaterialPageRoute(builder: (context) => const Profile()),
                );
                break;
            }
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}


class MyGrid extends StatelessWidget {
  final List<CellData> cellDataList = [
    CellData('images/weather.jpg', 'Thời tiết'),
    CellData('images/lottery.jpg', 'Sổ xố'),
    CellData('images/maps.png', 'Google map'),
    CellData('images/youtube.png', 'Youtube'),
    CellData('images/translate.png', 'Google dịch'),
    CellData('images/snake.jpg', 'Game rắn'),
    CellData('images/world.jpg', 'Báo nước ngoài'),
    CellData('images/qr.png', 'Quét mã qr'),
    CellData('images/calendar.jpg', 'Lịch'),
    CellData('images/chatgpt.jpg', 'ChatGPT'),
    CellData('images/google.png', 'Google'),
    // Add other image paths and names
  ];

  MyGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: cellDataList.length,
        shrinkWrap: true, // Ensure that the widget doesn't take more space than needed
        physics: const NeverScrollableScrollPhysics(), // Disable scrolling of the GridView
        itemBuilder: (BuildContext context, int index) {
          return GridCell(
            imagePath: cellDataList[index].imagePath,
            name: cellDataList[index].name,
          );
        },
      ),
    );
  }
}


class GridCell extends StatelessWidget {
  final String imagePath;
  final String name;

  const GridCell({Key? key, required this.imagePath, required this.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to different screens based on the 'name'
        switch (name) {
          case 'Thời Tiết':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Lottery(),
              ),
            );
            break;
          case 'Sổ xố':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Lottery(),
              ),
            );
            break;
          case 'Google map':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Lottery(),
              ),
            );
            break;
          case 'Youtube':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Lottery(),
              ),
            );
            break;
          case 'Google dịch':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Translator(),
              ),
            );
            break;
          case 'Game rắn':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Lottery(),
              ),
            );
            break;
          case 'Báo nước ngoài':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Lottery(),
              ),
            );
            break;
          case 'Quét mã qr':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Translator(),
              ),
            );
            break;
          case 'Lịch':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Lottery(),
              ),
            );
            break;
          case 'ChatGPT':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ChatGptScreen(),
              ),
            );
            break;
          case 'Google':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Home_Widget(),
              ),
            );
            break;
        // Add more cases for other items
          default: Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Home_Widget(),
            ),
          );
          // Navigate to a default screen or do nothing
            break;
        }
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey, // Set the color of the border
            width: 0.1, // Set the width of the border
          ),
          color: const Color.fromARGB(255, 253, 251, 251),
        ),
        // color: const Color.fromARGB(255, 253, 251, 251),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath, width: 90, height: 100),
            const SizedBox(height: 8),
            Text(name, style: const TextStyle(color: Colors.black)),
          ],
        ),
      ),
    );
  }
}

class CellData {
  final String imagePath; // Update to store image path
  final String name;

  CellData(this.imagePath, this.name);
}

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xml2json/xml2json.dart';
import 'package:flutter_news_app/page/admin/HomeAdmin.dart';
import 'package:flutter_news_app/page/history/histories.dart';
import 'package:flutter_news_app/page/home/news_web_view.dart';
import 'package:flutter_news_app/page/user/google.dart';
import 'package:flutter_news_app/page/user/login.dart';
import 'package:flutter_news_app/page/user/profile.dart';
import 'package:flutter_news_app/page/user/userauth.dart';
import 'package:news_api_flutter_package/news_api_flutter_package.dart';
import 'package:provider/provider.dart';
import '../admin/PHP/NewsApi.dart';
import '../admin/model/Category.dart';
import '../admin/model/NewsArticle.dart';
import '../widget/home_widget.dart';
import '../widget/lottery.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  List<NewsArticle> list = [];

  String? searchTerm;
  bool isSearching = false;
  TextEditingController searchController = TextEditingController();
  List<String> categoryItems = [
    "Thể thao", "Sức khỏe", "Xe", "Kinh doanh", "Khoa học",
    "Giải trí", "Giáo dục", "Thế giới"
  ];

  late String selectedCategory;

  @override
  void initState() {
    selectedCategory = categoryItems[0];
    super.initState();
  }

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isSearching ? _buildSearchAppBar() : _buildAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            _buildCategories(),
            Expanded(
              child: _buildNewsListView(),
            )
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // App Bar Widgets

  AppBar _buildSearchAppBar() {
    return AppBar(
      backgroundColor: Colors.green,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          setState(() {
            isSearching = false;
            searchTerm = null;
            searchController.text = "";
          });
        },
      ),
      title: TextField(
        controller: searchController,
        style: const TextStyle(color: Colors.white),
        cursorColor: Colors.white,
        decoration: const InputDecoration(
          hintText: "Search",
          hintStyle: TextStyle(color: Colors.white70),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
          ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            setState(() {
              searchTerm = searchController.text;
            });
          },
          icon: const Icon(Icons.search),
        ),
      ],
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 200, 220, 239),
      title: const Text("NEWS APP"),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {
            setState(() {
              isSearching = true;
            });
          },
          icon: const Icon(Icons.search),
        ),
      ],
    );
  }

// News List View Widget
  Widget _buildNewsListView() {
    final userAuth = Provider.of<UserAuth>(context, listen: false);
    final id = userAuth.userData['id'].toString();

    return ListView.builder(
      shrinkWrap: true,
      controller: ScrollController(),
      itemCount: list.length,
      itemBuilder: (BuildContext context, int index) {
        String description = list[index].description ?? '';
        String date = list[index].date;
        String title = list[index].title;
        String? imagePath = list[index].image;

        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(blurRadius: 2, spreadRadius: 2, color: Colors.black12),
            ],
          ),
          child: ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) =>
                      NewsWebView(url: list[index].url),
                ),
              );

              if (imagePath != null && description != null) {
                insertHistory(id, imagePath, title);
              }
            },
            horizontalTitleGap: 10,
            minVerticalPadding: 10,
            contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            title: Text(
              list[index].title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              date,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            leading: SizedBox(
              width: 80,
              height: 80,
              child: Image.network(
                imagePath ??
                    'https://image.24h.com.vn/upload/4-2023/images/2023-11-11/1699639283-848-thumbnail-width740height555.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }

// Categories Widget
  Widget _buildCategories() {
   
    return SizedBox(
      height: 60,
      child: ListView.builder(
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8),
            child: ElevatedButton(
              onPressed: () {
                setState(() async {
                  selectedCategory = categoryItems[index];
                  int indexx = categoryItems.indexOf(selectedCategory);
                  _onCategoryButtonPressed(indexx);

                  }

                );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  categoryItems[index] == selectedCategory
                      ? Colors.blue.withOpacity(0.5)
                      : Colors.blue,
                ),
              ),
              child: Text(categoryItems[index]),
            ),
          );
        },
        itemCount: categoryItems.length,
        scrollDirection: Axis.horizontal,
      ),
    );
  }
  void _onCategoryButtonPressed(int indexx) async {
    try {
      String selectedCategory = Category.categories[indexx];
      List<NewsArticle> newsList = await NewsApi.getNewsByType(selectedCategory);
      setState(() {
        list = newsList;
      });
    } catch (e) {
      print('Lỗi khi tải tin tức: $e');
    }
  }

  // Bottom Navigation Bar Widget

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      fixedColor: Colors.black,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.widgets), label: 'Widget'),
        BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Personal'),
      ],
      currentIndex: _currentIndex,
      onTap: (index) => _onBottomNavigationBarItemTapped(index),
    );
  }

  void _onBottomNavigationBarItemTapped(int index) {
    switch (index) {
      case 0:
        _navigateToNewsPage();
        break;
      case 1:
        _navigateToHomeWidget();
        break;
      case 2:
        _navigateToHistories();
        break;
      case 3:
        _navigateToUserProfile();
        break;
    }

    setState(() {
      _currentIndex = index;
    });
  }

  // Navigation Functions

  void _navigateToNewsPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NewsPage()),
    );
  }

  void _navigateToHomeWidget() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Home_Widget()),
    );
  }

  void _navigateToHistories() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Histories()),
    );
  }

  void _navigateToUserProfile() {
    final userAuth = Provider.of<UserAuth>(context, listen: false);
    final isAdmin = userAuth.userData['isAdmin'] ?? 2;

    if (userAuth.isLoggedIn) {
      if (isAdmin == 1) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Profile(userData: userAuth.userData),
          ),
        );
      } else if (isAdmin == 0) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AdminApp(),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SignInDemo(),
          ),
        );
      }
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    }
  }

  // Other Function

Future<void> insertHistory(
      String id, String imageUrl, String title) async {
    final uri = Uri.parse('http://192.168.2.15/server/history.php'); // URL to your PHP script
    try {
      final response = await http.post(uri, body: {
        'user_id': id, // Make sure this matches the expected key in your PHP
        'image': imageUrl,
        'title': title,
        'create_at': DateTime.now()
            .toIso8601String(), // Sends the current date and time
      });

      if (response.statusCode == 200) {
        // If the server returns an OK response, print the body
        print('Response data: ${response.body}');
      } else {
        // If the server did not return a 200 OK response,
        // throw an exception.
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending data: $e');
    }
  }
}

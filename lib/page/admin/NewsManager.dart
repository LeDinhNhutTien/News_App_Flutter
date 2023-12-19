import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'EditNewsPage.dart';
import 'UserAdmin.dart';

void main() {
  runApp(const NewsManager());
}

class NewsManager extends StatelessWidget {
  const NewsManager({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const NewsListPage(),
    );
  }
}

class NewsListPage extends StatefulWidget {
  const NewsListPage({Key? key}) : super(key: key);

  @override
  _NewsListPageState createState() => _NewsListPageState();
}

class _NewsListPageState extends State<NewsListPage> {
  final List<NewsArticle> newsArticles = [
    const NewsArticle(
      image:
      'https://binhminhdigital.com/StoreData/PageData/3429/Tim-hieu-ve-ban-quyen-hinh-anh%20(3).jpg',
      title: 'Article 1',
      author: 'John Doe',
      description: 'This is the first article.',
      url: 'https://example.com/article1',
    ),
    const NewsArticle(
      image:
      'https://binhminhdigital.com/StoreData/PageData/3429/Tim-hieu-ve-ban-quyen-hinh-anh%20(3).jpg',
      title: 'Article 2',
      author: 'Jane Smith',
      description: 'This is the second article.',
      url:
      'https://nld.com.vn/giai-nu-vdqg-2023-than-ksvn-cam-hoa-tp-hcm-i-ha-noi-i-tro-lai-ngoi-dau-196231219220505525.htm',
    ),
    // Add more articles as needed
  ];
  bool isLoading = false;
  bool isMenuOpen = false;

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
        actions: [
          TextButton(
            onPressed: isLoading ? null : _loadData,
            child: const Text('Load Data'),
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.grey[200],
            child: ListView.builder(
              itemCount: newsArticles.length,
              itemBuilder: (context, index) {
                final article = newsArticles[index];
                return ListTile(
                  leading: Image.network(
                    article.image,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                  title: Text(article.title),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Author: ${article.author}'),
                      Text('Description: ${article.description}'),
                      GestureDetector(
                        child: Text(
                          'URL: ${article.url}',
                          style: const TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        onTap: () {
                          _openArticle(article.url, context);
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    _editArticle(article);
                  },
                );
              },
            ),
          ),
          if (isMenuOpen) const NavigationDrawer(),
          if (isLoading)
            Container(
              color: Colors.white.withOpacity(0.8),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  void _openArticle(String url, BuildContext context) async {
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        // Handle error if the URL cannot be launched
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('Failed to open the URL.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print('Error launching URL: $e');
    }
  }

  void _editArticle(NewsArticle article) async {
    final updatedArticle = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditNewsPage(newsArticle: article),
      ),
    );

    //Handle the edited article returned from the edit page
    if (updatedArticle != null) {
      setState(() {
        // Find the index of the edited article in the list
        final index = newsArticles.indexOf(article);
        if (index != -1) {
          // Replace the old article with the updated article
          newsArticles[index] = updatedArticle;
        }
      });
    }
  }

  void _loadData() {
    setState(() {
      isLoading = true;
    });
    // Simulate loading data
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
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
              // Handle tapping on the 'Home' menu item
              Navigator.pop(context); // Close the drawer
            },
          ),
          ListTile(
            title: const Text('Quản lý người dùng'),
            onTap: () {
              // Handle tapping on the 'Quản lý người dùng' menu item
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UserAdmin()),
              );
            },
          ),
          ListTile(
            title: const Text('Quản lý báo'),
            onTap: () {
              // Handle tapping on the 'Quản lý báo' menu item
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NewsManager()),
              );
            },
          ),
          ListTile(
            title: const Text('Menu Item 3'),
            onTap: () {
              // Handle tapping on the 'Menu Item 3' menu item
              Navigator.pop(context); // Close the drawer
            },
          ),
        ],
      ),
    );
  }
}

class NewsArticle {
  final String image;
  final String title;
  final String author;
  final String description;
  final String url;

  const NewsArticle({
    required this.image,
    required this.title,
    required this.author,
    required this.description,
    required this.url,
  });
}
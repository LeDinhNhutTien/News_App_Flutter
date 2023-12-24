import 'package:flutter/material.dart';
import '../PHP/GetAllNews.dart';
import '../model/Category.dart';
import '../model/NewsArticle.dart';
import 'HomeAdmin.dart';
import 'TheGioi.dart';
import 'TrongNuoc.dart';
import 'UserAdmin.dart';

void main() {
  runApp(const NewsManager());
}

class NewsManager extends StatefulWidget {
  const NewsManager({Key? key}) : super(key: key);

  @override
  _NewsManagerState createState() => _NewsManagerState();
}

class _NewsManagerState extends State<NewsManager> {
  late Future<List<NewsArticle>> _newsArticlesFuture;

  @override
  void initState() {
    super.initState();
    _newsArticlesFuture = fetchDataDB();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News Manager'),
      ),
      drawer: const NavigationDrawer(),
      body: FutureBuilder<List<NewsArticle>>(
        future: _newsArticlesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to fetch data'));
          } else if (snapshot.hasData) {
            final articles = snapshot.data!;
            return ListView.builder(
              itemCount: articles.length,
              itemBuilder: (context, index) {
                final article = articles[index];
                return ListTile(
                  leading: Image.network(article.image), // Display the image
                  title: Text(article.title),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Author: ${article.author}'),
                      Text('Description: ${article.description}'),
                      Text('URL: ${article.url}'),
                      Text('Type: ${article.type}'),
                    ],
                  ),
                  onTap: () {
                    // Implement edit functionality here
                    // Use article object to pass data to the edit screen
                  },
                  onLongPress: () {
                    // Implement delete functionality here
                    // Use article object to identify the item to delete
                  },
                );
              },
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
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
              // Handle when the user taps on the Home menu item
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AdminApp()),
              );
            },
          ),
          ListTile(
            title: const Text('Quản lý báo trong nước'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TrongNuoc()),
              );
            },
          ),
          ListTile(
            title: const Text('Quản lý báo ngoài nước'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NewsTheGioi()),
              );
            },
          ),
          ListTile(
            title: const Text('Quản lý người dùng'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UserAdmin()),
              );
            },
          ),

          ListTile(
            title: const Text('Danh sách bài báo'),
            onTap: () {
              // Handle when the user taps on the Danh sách bài báo menu item
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NewsManager()),
              );
            },
          ),
        ],
      ),
    );
  }
}
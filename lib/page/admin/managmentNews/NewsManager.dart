import 'package:flutter/material.dart';
import 'package:flutter_news_app/page/admin/managmentNews/UpdateNewsDB.dart';
import 'package:flutter_news_app/page/PHP/NewsApi.dart';
import '../../model/NewsArticle.dart';
import '../loadNews/EditNewsPage.dart';
import '../HomeAdmin.dart';
import '../loadNews/TrongNuoc.dart';
import '../managmentUser/UserAdmin.dart';

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
  List<NewsArticle> articles = [];

  @override
  void initState() {
    super.initState();
    _newsArticlesFuture = NewsApi.getNewsArticles();
    _newsArticlesFuture.then((list) {
      setState(() {
        articles = list;
      });
    });
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
                  leading: Image.network(article.image),
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
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _deleteArticle(article);
                    },
                  ),
                  onTap: () {
                    _editArticle(article);
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

  void _deleteArticle(NewsArticle article) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Article'),
          content: Text('Are you sure you want to delete this article?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _performDelete(article);
                Navigator.pop(context);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _performDelete(NewsArticle article) {
    NewsApi.deleteNewsArticle(article);
    setState(() {
      articles.remove(article);
    });
    // Perform the actual delete operation here
    // You can call the appropriate method or API to delete the article
  }

  void _editArticle(NewsArticle article) async {
    final updatedArticle = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateNewsDB(newsArticle: article),
      ),
    );

    if (updatedArticle != null) {
      setState(() {
        final articleIndex = articles.indexOf(article);
        if (articleIndex != -1) {
          articles[articleIndex] = updatedArticle;
        }
      });
    }
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
            title: const Text('Duyệt báo mới'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TrongNuoc()),
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

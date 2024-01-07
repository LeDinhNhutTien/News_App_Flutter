import 'package:flutter/material.dart';
import 'package:flutter_news_app/page/admin/managmentNews/UpdateNewsDB.dart';
import 'package:flutter_news_app/page/PHP/NewsApi.dart';
import 'package:provider/provider.dart';
import '../../model/NewsArticle.dart';
import '../../user/login.dart';
import '../../user/userauth.dart';
import '../loadNews/EditNewsPage.dart';
import '../HomeAdmin.dart';
import '../loadNews/DuyetBaoMoi.dart';
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
  List<bool> selectedList = [];


  @override
  void initState() {
    super.initState();
    _newsArticlesFuture = NewsApi.getNewsArticles();
    _newsArticlesFuture.then((list) {
      setState(() {
        articles = list;
        selectedList = List.generate(articles.length, (index) => false);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News Manager'),
      ),
      drawer: const NavigationDrawer(),
      body: Column(
        children: [
          _buildToolbar(),
          Expanded(
            child: FutureBuilder<List<NewsArticle>>(
              future: _newsArticlesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Failed to fetch data'));
                } else if (snapshot.hasData) {
                  final articles = snapshot.data!;
                  return ListView.builder(
                    itemCount: articles.length,
                    itemBuilder: (context, index) {
                      final article = articles[index];
                      return ListTile(
                        leading: Checkbox(
                          value: selectedList[index],
                          onChanged: (value) {
                            setState(() {
                              selectedList[index] = value!;
                            });
                          },
                        ),
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
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            if (selectedList[index]) {
                              _deleteArticle(article);
                            } else {
                              _showDeleteConfirmationDialog(article);
                            }
                          },
                        ),
                        onTap: () {
                          _editArticle(article);
                        },
                        tileColor: selectedList[index] ? Colors.blue[50] : null,
                        onLongPress: () {
                          setState(() {
                            selectedList[index] = !selectedList[index];
                          });
                        },
                      );
                    },
                  );
                } else {
                  return const Center(child: Text('No data available'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolbar() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed: _selectAllArticles,
            child: const Text('Select All'),
          ),
          ElevatedButton(
            onPressed: _deleteSelectedArticles,
            child: const Text('Delete Selected'),
          ),
        ],
      ),
    );
  }

  void _selectAllArticles() {
    setState(() {
      selectedList = List.generate(articles.length, (index) => true);
    });
  }

  void _deleteSelectedArticles() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Selected Articles'),
          content: const Text('Are you sure you want to delete selected articles?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(

              onPressed: () {
                _performDeleteSelected();
                setState(() {
                  selectedList = List.generate(articles.length, (index) => false);
                });

                Navigator.pop(context);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _performDeleteSelected() {
    List<NewsArticle> selectedArticles = [];
    for (int i = 0; i < selectedList.length; i++) {
      if (selectedList[i]) {
        selectedArticles.add(articles[i]);
      }
    }

    for (var article in selectedArticles) {
      NewsApi.deleteNewsArticle(article);
      setState(() {
        articles.remove(article);
        selectedList.remove(false);
      });
    }
  }

  void _deleteArticle(NewsArticle article) {
    NewsApi.deleteNewsArticle(article);
    setState(() {
      articles.remove(article);
      selectedList.remove(false);
    });
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

  void _showDeleteConfirmationDialog(NewsArticle article) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Article'),
          content: const Text('Are you sure you want to delete this article?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteArticle(article);
                Navigator.pop(context);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
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
            title: const Text('Duyệt báo mới'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DuyetBaoMoi()),
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
          ListTile(
            title: const Text('Đăng Xuất'),
            onTap: () {
              // Handle when the user taps on the Danh sách bài báo menu item
              Provider.of<UserAuth>(context, listen: false).logout();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );
            },
          ),
        ],
      ),

    );

  }
}

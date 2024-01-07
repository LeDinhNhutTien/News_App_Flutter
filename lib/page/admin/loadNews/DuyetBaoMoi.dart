import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../PHP/RssItem.dart';
import '../../model/Category.dart';
import '../../PHP/NewsApi.dart';
import '../../model/NewsArticle.dart';
import '../../user/login.dart';
import '../../user/userauth.dart';
import '../HomeAdmin.dart';
import '../managmentNews/NewsManager.dart';
import '../managmentUser/UserAdmin.dart';
import 'EditNewsPage.dart';

void main() {
  runApp(const DuyetBaoMoi());
}

class DuyetBaoMoi extends StatelessWidget {
  const DuyetBaoMoi({Key? key}) : super(key: key);

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
  List<NewsArticle> list = [];
  bool isLoading = false;

  String selectedCategory = Category.categories[0];
  List<NewsArticle> selectedArticles = [];
  bool selectAll = false;
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
        title: const Text('Duyệt báo mới'),
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
            child: Column(
              children: [
                _buildCategoryFilter(),
                Expanded(
                  child: ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final article = list[index];
                      if (selectedCategory != "All" &&
                          article.type != selectedCategory) {
                        return const SizedBox();
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
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
                                Text('published date: ${article.date}'),
                                Text('Type: ${article.type}'),
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
                            trailing: GestureDetector(
                              onTap: () {
                                _selectArticle(
                                    !selectedArticles.contains(article),
                                    article);
                              },
                              child: Checkbox(
                                value:
                                selectAll || selectedArticles.contains(article),
                                onChanged: (value) {
                                  _selectArticle(value!, article);
                                },
                              ),
                            ),
                            onLongPress: () {
                              _editArticle(article);
                            },
                              onTap: () {
                                _selectArticle(
                                    !selectedArticles.contains(article), article);
                              },


                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
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
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: _saveData,
        child: const Icon(Icons.save),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align buttons at the ends
        children: [
          Row(
            children: [
              const Text('Category: '),
              DropdownButton<String>(
                value: selectedCategory,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCategory = newValue!;
                  });
                },
                items: [
                  ...Category.categories.map((category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                ],
              ),
            ],
          ),
          ElevatedButton(
            onPressed: _selectAllArticles,
            child: Text(selectAll ? 'Bỏ chọn' : 'Duyệt tất cả'),
          ),
        ],
      ),
    );
  }


  void _selectAllArticles() {
    setState(() {
      if (selectAll) {
        selectedArticles.clear();
      } else {
        selectedArticles.addAll(list);
      }
      selectAll = !selectAll;
    });
  }

  void _openArticle(String url, BuildContext context) async {
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(
                title: const Text('Error'),
                content: const Text('Failed to open the URL.'),
                actions: [
                  TextButton(
                    child:const Text('OK'),
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

    if (updatedArticle != null) {
      setState(() {
        final articleIndex = list.indexOf(article);
        if (articleIndex != -1) {
          list[articleIndex] = updatedArticle;
        }
      });
    }
  }

  void _loadData() {
    setState(() {
      isLoading = true;
    });

    selectedArticles.clear();

    NewsApi.fetchNews(RssItem.rssItems).then((articles) {
      setState(() {
        isLoading = false;
        list = articles;
      });
    }).catchError((error) {
      setState(() {
        isLoading = false;
      });
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text('Error'),
              content: Text('Failed to load data from API.'),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
      );
    });
  }

  void _selectArticle(bool isSelected, NewsArticle article) {
    setState(() {
      if (isSelected) {
        selectedArticles.add(article);
      } else {
        selectedArticles.remove(article);
      }
    });
  }

  void _saveData() async {
    List<NewsArticle> savedArticles = [];
    savedArticles.addAll(selectedArticles);

    // Remove selected articles from the list
    setState(() {
      list.removeWhere((article) => selectedArticles.contains(article));
    });

    selectedArticles.clear();

    // Gọi hàm lưu dữ liệu cho từng article
    for (var article in savedArticles) {
      NewsApi.saveNewsArticle(article);
    }

    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: const Text('Save Success'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Selected articles removed successfully.'),
                const Text('Removed Articles:'),
                ...savedArticles.map((article) => Text('- ${article.title}')),
              ],
            ),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
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

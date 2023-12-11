import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_news_app/page/home/news_web_view.dart';

import 'package:xml2json/xml2json.dart';
import 'package:http/http.dart' as http;

import '../widget/home_widget.dart';
import '../widget/lottery.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  late Future future;

  String? searchTerm;
  bool isSearching = false;
  TextEditingController searchController = TextEditingController();
  List<String> categoryItems = [
    "Thể thao",
    "Sức khỏe",
    "Xe",
    "Kinh doanh",
    "Khoa học",
    "Giải trí",
    "Giáo dục",
    "Thế giới"
  ];

  late String selectedCategory;
  late String chooseLink ='https://vtc.vn/rss/feed.rss';

  @override
  void initState() {
    selectedCategory = categoryItems[0];
    future = getNewsData('https://vtc.vn/rss/feed.rss');

    super.initState();
  }

  final Xml2Json xml2json = Xml2Json();
  List topStories = [];

  Future<void> getNewsData(String urllink) async {
    try {
      final url = Uri.parse(urllink);
      final response = await http.get(url);
      if (response.body.isEmpty) {
        // print('Empty response');
        return;
      }
      try {
        xml2json.parse(response.body.toString());
        var JSONata = await xml2json.toGData();
        var data = json.decode(JSONata);
        topStories = data['rss']['channel']['item'];
        // print(topStories);
      } catch (e) {
        // print('Error parsing XML: $e');
      }
    } catch (e) {
      // print("Error in getNewsData: $e");
    }
  }

  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isSearching ? searchAppBar() : appBar(),
      body: SafeArea(
          child: Column(
        children: [
          _buildCategories(),
          Expanded(
            child: FutureBuilder(
              future: getNewsData(chooseLink),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text("Error loading the news"),
                  );
                } else {
                  return _buildNewsListView();
                }
              },
            ),
          )
        ],
      )),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Colors.black,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home'
            ),BottomNavigationBarItem(
                icon: Icon(Icons.widgets),
                label: 'Widget'
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
                label: 'History'
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
                label: 'Personal'
            ),
      ],
          currentIndex: _currentIndex,
        onTap: (index){
            // Use Navigator to navigate to the corresponding pages
            switch (index) {
              case 0:
              // Navigate to the Home page
              // Replace 'YourHomePage()' with the widget representing your home page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NewsPage()),
                );
                break;
              case 1:
              // Navigate to the History page
              // Replace 'YourHistoryPage()' with the widget representing your history page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Home_Widget()),
                );
                break;
              case 2:
              // Navigate to the Personal page
              // Replace 'YourPersonalPage()' with the widget representing your personal page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Lottery()),
                );
                break;
              case 3:
              // Navigate to the Personal page
              // Replace 'YourPersonalPage()' with the widget representing your personal page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Lottery()),
                );
                break;
            }
            setState(() {
              _currentIndex = index;
            });
        },
      ),
    );
  }

  searchAppBar() {
    return AppBar(
      backgroundColor: Colors.green,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          setState(() {
            isSearching = false;
            searchTerm = null;
            searchController.text = "";
             future = getNewsData(chooseLink);
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
                future = getNewsData(chooseLink);
              });
            },
            icon: const Icon(Icons.search)),
      ],
    );
  }

  // tim kiem va tieu de
  appBar() {
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
            icon: const Icon(Icons.search)),
      ],
    );
  }

  Widget _buildNewsListView() {
    return ListView.builder(
        shrinkWrap: true,
        controller: ScrollController(),
        itemCount: topStories.length,
        itemBuilder: (BuildContext context, int index){
          // Get the image path from the 'description' field
          String description = topStories[index]['description']?['\$t'] ?? '';
          String date = topStories[index]['pubDate']['\$t'] ;
          // Parse the HTML content to extract the image path
          RegExp regex = RegExp(r'<img alt="[^"]+" src="([^"]+)"');
          Match? match = regex.firstMatch(description);

          // Check if a match is found
          String? imagePath = match?.group(1);
          return Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      blurRadius: 2,
                      spreadRadius: 2,
                      color: Colors.black12)
                ]),
            child: ListTile(
              onTap: (){
                Navigator.push(context,
                    MaterialPageRoute(builder:
                        (BuildContext context) => NewsWebView(url: topStories[index]['link']['\$t']
                    )));
              },
                horizontalTitleGap: 10,
                minVerticalPadding: 10,
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 10, horizontal: 10),
                title: Text(topStories[index]['title']['\$t'],
                    maxLines: 2, overflow: TextOverflow.ellipsis
                ),
                subtitle: Text(
                  date.substring(5, date.length-9),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              leading: SizedBox(
                width: 80,
                height: 80,
                child: Image.network(
                  imagePath ?? 'https://image.24h.com.vn/upload/4-2023/images/2023-11-11/1699639283-848-thumbnail-width740height555.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        });
  }

// xu ly danh muc
  Widget _buildCategories() {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  selectedCategory = categoryItems[index];
                  int indexx = categoryItems.indexOf(selectedCategory);

                  switch(indexx){
                    case 0:
                      chooseLink = 'https://vtc.vn/rss/the-thao.rss';
                      future = getNewsData(chooseLink);
                      break;
                    case 1:
                      chooseLink = 'https://vtc.vn/rss/suc-khoe.rss';
                      future = getNewsData(chooseLink);
                      break;
                    case 2:
                      chooseLink = 'https://vtc.vn/rss/oto-xe-may.rss';
                      future = getNewsData(chooseLink);
                      break;
                    case 3:
                      chooseLink = 'https://vtc.vn/rss/kinh-te.rss';
                      future = getNewsData(chooseLink);
                      break;
                    case 4:
                      chooseLink = 'https://vtc.vn/rss/khoa-hoc-cong-nghe.rss';
                      future = getNewsData(chooseLink);
                      break;
                    case 5:
                      chooseLink = 'https://vtc.vn/rss/van-hoa-giai-tri.rss';
                      future = getNewsData(chooseLink);
                      break;
                    case 6:
                      chooseLink = 'https://vtc.vn/rss/giao-duc.rss';
                      future = getNewsData(chooseLink);
                      break;
                    case 7:
                      chooseLink = 'https://vtc.vn/rss/the-gioi.rss';
                      future = getNewsData(chooseLink);
                      break;
                  }
                });
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                categoryItems[index] == selectedCategory
                    ? Colors.blue.withOpacity(0.5)
                    : Colors.blue,
              )),
              child: Text(categoryItems[index]),
            ),
          );
        },
        itemCount: categoryItems.length,
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_api_flutter_package/model/article.dart';
import 'package:news_api_flutter_package/news_api_flutter_package.dart';

import 'NewsDetailScreen.dart';

class NewsForeign extends StatefulWidget {
  const NewsForeign({super.key});

  @override
  State<NewsForeign> createState() => _NewsForeignState();
}

class _NewsForeignState extends State<NewsForeign> {
  late Future<List<Article>> future;
  String? searchTerm;
  bool isSearching  = false;
  TextEditingController searchController = TextEditingController();
  void _navigateToDetail(Article article) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewsDetailScreen(article: article),
      ),
    );
  }


  @override
  void initState() {

    future = getNewsData();
    super.initState();
  }

  Future<List<Article>> getNewsData() async{
    NewsAPI newsAPI = NewsAPI("b935e6bb8d834194b76d5b862e808877");
    return await newsAPI.getTopHeadlines(
      country: "us",
      query: searchTerm,
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isSearching? searchAppBar() : appBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
                child: FutureBuilder(
                  builder: (context, snapshot){
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }else if(snapshot.hasError){
                      return const Center(
                        child: Text("Error loading the news"),
                      );
                    } else {
                      if(snapshot.hasData && snapshot.data!.isNotEmpty){
                        return _buildNewsListview(snapshot.data as List<Article>);

                      }else {
                        return const Center(
                          child: Text("No news available"),
                        );
                      }
                    }

                  },
                  future: future,
                )
            ),
          ],
        ),
      ),
    );
  }

  searchAppBar(){
    return AppBar(
      backgroundColor: Colors.green,
      leading: IconButton(icon: const Icon(Icons.arrow_back),
      onPressed: (){
        setState(() {
          isSearching = false;
          searchTerm = null;
          searchController.text = "";
          future = getNewsData();
        });
      },),
      title: TextField(
        controller: searchController,
        style: const TextStyle(color:  Colors.white),
        cursorColor: Colors.white,
        decoration: const InputDecoration(
          hintText: "Search",
          hintStyle: TextStyle(color: Colors.white70),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
          ),
        ),
      ),
      actions: [
        IconButton(onPressed: () {
          setState(() {
            searchTerm = searchController.text;
            future = getNewsData();
          });
        }, icon: const Icon(Icons.search)),
      ],
    );
  }

  appBar(){
    return AppBar(
      backgroundColor: Colors.green,
      title: const Text("NEWS NOW"),
      actions: [
        IconButton(
            onPressed: () {
              setState(() {
                isSearching = true;
              });

        }, icon: const Icon(Icons.search)),
      ],
    );
  }

  Widget _buildNewsListview(List<Article> articleList){
    return ListView.builder(
      itemBuilder:  (context, index){
        Article article = articleList[index];
        return _buildNewsItem(article);
      },
       itemCount: articleList.length,
    );
  }

  Widget _buildNewsItem(Article article){
    return GestureDetector(
        onTap: () {
          _navigateToDetail(article);
        },
    child: Card(
      elevation: 4,
      child: Padding(
    padding: EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 80,
              width: 80,
            child: Image.network(article.urlToImage ?? "",
            fit:  BoxFit.fitHeight,
            errorBuilder: (context, error, stackTrace){
              return const Icon(Icons.image_not_supported);
            },),
          ),
          const SizedBox(width: 20),
          Expanded(
              child: Column(
             mainAxisAlignment: MainAxisAlignment.start,
             crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(article.title!,
              maxLines: 2,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              ),
              Text(article.source.name!,
              style: const TextStyle(color: Colors.grey),),
            ],
          ))
        ],
      ),),
    )
    );
  }
}

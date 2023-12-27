import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_api_flutter_package/model/article.dart';

class NewsDetailScreen extends StatelessWidget {
  final Article article;

  NewsDetailScreen({required this.article});

  @override
  Widget build(BuildContext context) {
    print("Content: ${article.content}");

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("News Detail"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                article.title ?? "",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              SizedBox(height: 10),
              Text(
                article.content ?? "",
                style: TextStyle(fontSize: 18),
                maxLines: 1000, // Số dòng lớn để đảm bảo hiển thị toàn bộ nội dung
              ),
            ],
          ),
        ),
      ),

    );
  }

}

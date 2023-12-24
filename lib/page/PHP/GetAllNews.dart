import '../model/NewsArticle.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<NewsArticle>> fetchDataDB() async {
  try {
    final url = Uri.parse('http://192.168.2.15/server/getAllNews.php');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonList = json.decode(response.body) as List<dynamic>;
      List<NewsArticle> articles = jsonList.map((json) => NewsArticle.fromJsonDB(json)).toList();
      return articles;
    } else {
      // Handle error response
      print('Failed to fetch data. Error: ${response.statusCode}');
      return []; // Return an empty list in case of an error
    }
  } catch (e) {
    // Handle network or other exceptions
    print('Failed to fetch data. Exception: $e');
    return []; // Return an empty list in case of an exception
  }
}
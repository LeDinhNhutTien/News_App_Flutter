import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/NewsArticle.dart';
import 'package:xml/xml.dart' as xml;

class NewsApi {
  static String ip = "192.168.2.15";
  static String urlGetAll ="http://$ip/server/getAllNews.php";
  static String urlArticleExistsInDatabase ="http://$ip/server/checkTitleAndCreate.php";
  static String urlSaveNewsArticle ="http://$ip/server/saveNews.php";
  static String urlDeleteNewsArticle ="'http://$ip/server/deleteNews.php'";
  static String urlUpdateNewsArticle ="''http://$ip/server/updateNews.php''";
  static String urlGetNewsByType ="http://$ip/server/getAllNewsByType.php";
  static String extractPubDate(xml.XmlElement item) {
    var pubDateElement = item.findElements('pubDate').single;
    var pubDateText = pubDateElement.text;

    // Remove the timezone offset
    var pubDateWithoutOffset = pubDateText.replaceFirst(RegExp(r'\s[+-]\d{4}$'), '');

    return pubDateWithoutOffset.trim();
  }
  static Future<List<NewsArticle>> fetchNews(List<String> rssUrls) async {
    List<NewsArticle> articles = [];

    try {
      for (var rssUrl in rssUrls) {
        http.Response response = await http.get(Uri.parse(rssUrl));

        if (response.statusCode == 200) {
          var rssXml = response.body;

          final document = xml.XmlDocument.parse(rssXml);
          final items = document.findAllElements('item');

          for (final item in items) {
            String title = item.findElements('title').single.text;
            String pubDate = extractPubDate(item);

            // Check if the article already exists in the database based on title and create_at
            if (!await articleExistsInDatabase(title, pubDate)) {
              String description = item.findElements('description').single.text;
              String link = item.findElements('link').single.text;
              String des = description.split("</br>")[1];
              des = des.substring(0, des.length - 4);

              // Extracting image URL using RegExp
              RegExp imageRegex = RegExp(r'src="([^"]+)"');
              Match? match = imageRegex.firstMatch(description);
              String image = match?.group(1) ?? '';

              NewsArticle article = NewsArticle(

                title: title,
                description: des,
                url: link,
                date: pubDate,
                image: image,
                author: '',
                type: getTypeForRssUrl(rssUrl),
              );

              articles.add(article);
            }
          }
        } else {
          print('Failed to load data from RSS feed: $rssUrl');
        }
      }

      return articles;
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  static Future<bool> articleExistsInDatabase(String title, String createAt) async {
    var url = Uri.parse(urlArticleExistsInDatabase);
    var response = await http.post(url, body: {'title': title, 'create_at': createAt});

    if (response.statusCode == 200) {

      var result = json.decode(response.body);
      return result['exists'] == true;
    } else {
      // Handle the error case
      print('Error checking article existence: ${response.statusCode}');
      return false;
    }
  }

  static getTypeForRssUrl(String rssUrl) {
    if (rssUrl.contains('the-thao')) {
      return 'Thể thao';
    } else if (rssUrl.contains('suc-khoe')) {
      return 'Sức khỏe';
    } else if (rssUrl.contains('oto-xe-may')) {
      return 'Xe';
    }else if (rssUrl.contains('kinh-te')) {
      return 'Kinh doanh';
    }else if (rssUrl.contains('khoa-hoc-cong-nghe')) {
      return 'Khoa học';
    }else if (rssUrl.contains('van-hoa-giai-tri')) {
      return 'Giải trí';
    }else if (rssUrl.contains('giao-duc')) {
      return 'Giáo dục';
    }
    else if (rssUrl.contains('the-gioi')) {
      return 'Báo thế giới';
    }
    // Add more conditions as needed

    return 'Unknown'; // Default type if none of the conditions match

  }
  static Future<void> saveNewsArticle(NewsArticle article) async {
    var url = Uri.parse(urlSaveNewsArticle);

    var response = await http.post(url, body: article.toJson());

    if (response.statusCode == 200) {
      print('Lưu dữ liệu thành công');
    } else {
      print('Lỗi khi lưu dữ liệu: ${response.statusCode}');
    }
  }
  static Future<void> updateNewsArticle(NewsArticle article, String oldTitle) async {
    var url = Uri.parse(urlUpdateNewsArticle);

    var response = await http.post(url, body: article.toJsonForUpdate(oldTitle));

    if (response.statusCode == 200) {
      print('Lưu dữ liệu thành công');
    } else {
      print('Lỗi khi lưu dữ liệu: ${response.statusCode}');
    }
  }
  static Future<void> deleteNewsArticle(NewsArticle article) async {
    var url = Uri.parse(urlDeleteNewsArticle);

    var response = await http.post(url, body: article.toJsonForDelete());

    if (response.statusCode == 200) {
      print('Lưu dữ liệu thành công');
    } else {
      print('Lỗi khi lưu dữ liệu: ${response.statusCode}');
    }
  }
  static Future<List<NewsArticle>> getNewsArticles() async {
    var url = Uri.parse(urlGetAll);

    var response = await http.get(url);

    if (response.statusCode == 200) {
      // Parse the response body
      var data = json.decode(response.body);

      // Map the data to a list of NewsArticle objects
      List<NewsArticle> articles = List.from(data.map((item) {
        return NewsArticle.fromJsonDB(item);
      }));

      return articles;
    } else {
      throw Exception('Failed to load news articles: ${response.statusCode}');
    }
  }
  static Future<List<NewsArticle>> getNewsByType(String type) async {
    try {
      var url = Uri.parse(urlGetNewsByType);
      var response = await http.post(url, body: {'type': type});

      if (response.statusCode == 200) {
        print(response.body);

        var data = json.decode(response.body);
        List<NewsArticle> articles = List.from(data.map((item) {
          Map<String, dynamic> articleMap = item;
          return NewsArticle.fromJsonDB(articleMap);
        }));
        return articles;
      } else {
        // Handle HTTP request error
        throw Exception('Failed to load news articles: ${response.statusCode}');
      }
    } catch (error) {
      // Handle general error
      throw Exception('Failed to load news articles: $error');
    }
  }

}


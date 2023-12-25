import 'dart:convert';
import 'package:http/http.dart' as http;
import 'NewsArticle.dart';
import 'package:xml/xml.dart' as xml;

class NewsApi {
  static const String baseUrl = 'https://api.nytimes.com/svc/topstories/v2/home.json';
  static const String apiKey = '9lE4P7b3BrtQdSCGJUt7kQOE9lKjC0Rs';

  static Future<List<NewsArticle>> fetchArticles() async {
    final response = await http.get(Uri.parse('$baseUrl?api-key=$apiKey'));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final articlesJson = json['results'] as List<dynamic>;

      return articlesJson
          .map((articleJson) => NewsArticle.fromJson(articleJson))
          .toList();
    } else {
      throw Exception('Failed to load articles');
    }
  }
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
            String description = item
                .findElements('description').single.text;

            String link = item.findElements('link').single.text;
            String pubDate = extractPubDate(item);
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
        } else {
          print('Failed to load data from RSS feed: $rssUrl');
        }
      }

      return articles;
    } catch (error) {
      throw Exception('Error: $error');
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


}

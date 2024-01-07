
import 'dart:convert';
import 'package:flutter_news_app/page/admin/model/User.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;



class UserApi {
  static String ip = "192.168.2.15";
  static String urlGetAllUser = "http://$ip/server/getAllUser.php";
  static String urlSaveUser = "http://$ip/server/saveUser.php";
  static String urlDeleteUser = "http://$ip/server/deleteUser.php";
  static String urlUpdateUser = "http://$ip/server/updateUser.php";
  static Future<List<User>> fetchDataDBUser() async {
    try {
      final url = Uri.parse(urlGetAllUser);
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonList = json.decode(response.body) as List<dynamic>;
        List<User> articles = jsonList.map((json) => User.fromJsonDB(json)).toList();
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
  static Future<void> saveUser(User user) async {
    var url = Uri.parse(urlSaveUser);

    var response = await http.post(url, body: user.toJson());

    if (response.statusCode == 200) {
      print('Lưu dữ liệu thành công');
    } else {
      print('Lỗi khi lưu dữ liệu: ${response.statusCode}');
    }
  }
  static Future<void> deleteUser(User user) async {
    var url = Uri.parse(urlDeleteUser);

    var response = await http.post(url, body: user.toJsonForDelete());

    if (response.statusCode == 200) {
      print('Lưu dữ liệu thành công');
    } else {
      print('Lỗi khi lưu dữ liệu: ${response.statusCode}');
    }
  }
  static Future<void> updateUser(User user, String oldEmail) async {
    var url = Uri.parse(urlUpdateUser);

    var response = await http.post(url, body: user.toJsonForUpdate(oldEmail));

    if (response.statusCode == 200) {
      print('Lưu dữ liệu thành công');
    } else {
      print('Lỗi khi lưu dữ liệu: ${response.statusCode}');
    }
  }
}

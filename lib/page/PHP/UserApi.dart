import 'package:flutter_news_app/page/model/User.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
Future<List<User>> fetchDataDBUser() async {
  try {
    final url = Uri.parse('http://172.27.240.1/server/getAllUser.php');
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
Future<void> saveUser(User user) async {
  var url = Uri.parse('http://172.27.240.1/server/saveUser.php');

  var response = await http.post(url, body: user.toJson());

  if (response.statusCode == 200) {
    print('Lưu dữ liệu thành công');
  } else {
    print('Lỗi khi lưu dữ liệu: ${response.statusCode}');
  }
}
Future<void> deleteUser(User user) async {
  var url = Uri.parse('http://172.27.240.1/server/deleteUser.php');

  var response = await http.post(url, body: user.toJsonForDelete());

  if (response.statusCode == 200) {
    print('Lưu dữ liệu thành công');
  } else {
    print('Lỗi khi lưu dữ liệu: ${response.statusCode}');
  }
}
Future<void> updateUser(User user, String oldEmail) async {
  var url = Uri.parse('http://172.27.240.1/server/updateUser.php');

  var response = await http.post(url, body: user.toJsonForUpdate(oldEmail));

  if (response.statusCode == 200) {
    print('Lưu dữ liệu thành công');
  } else {
    print('Lỗi khi lưu dữ liệu: ${response.statusCode}');
  }
}
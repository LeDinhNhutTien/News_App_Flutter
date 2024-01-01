import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_news_app/page/admin/HomeAdmin.dart';
import 'package:flutter_news_app/page/home/news_page.dart';
import 'package:flutter_news_app/page/user/google.dart';
import 'package:flutter_news_app/page/user/login.dart';
import 'package:flutter_news_app/page/user/profile.dart';
import 'package:flutter_news_app/page/user/userauth.dart';
import 'package:flutter_news_app/page/widget/home_widget.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class Histories extends StatefulWidget {
  @override
  _HistoriesState createState() => _HistoriesState();
}

class _HistoriesState extends State<Histories> {
  List<Map<String, dynamic>> newsList = [];
  late UserAuth userAuth;
  int _currentIndex = 0;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userAuth = Provider.of<UserAuth>(context, listen: false);
    final id = userAuth.userData['id'].toString() ;
    print(id);
    fetchHistoriesByUserId(id);
  }

  Future<void> fetchHistoriesByUserId(String userId) async {
    final uri = Uri.parse('http://172.26.208.1/server/gethistory.php?user_id=$userId');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      setState(() {
        newsList = List<Map<String, dynamic>>.from(json.decode(response.body));
      });
    } else {
      // Nếu server không trả về kết quả thành công, ném lỗi
      throw Exception('Failed to load histories');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Lịch sử xem'),
      ),
      body: ListView.builder(
        itemCount: newsList.length,
        itemBuilder: (context, index) {
          var newsItem = newsList[index];
          String timePart = extractTime(newsItem['create_at']);
          // Đảm bảo các khóa trong map phản ánh đúng các trường trong JSON
          return ListTile(

            leading: Image.network(newsItem['image'], width: 100, height: 100, fit: BoxFit.cover),
            title: Text(newsItem['title']),
            subtitle: Text('Thời gian xem:   ' +timePart),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.widgets),
            label: 'Widget',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Personal',
          ),
        ],
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          switch (index) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NewsPage()),
              );
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Home_Widget()),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Histories()),
              );
              break;
            case 3:
              final userAuth = Provider.of<UserAuth>(context, listen: false);
              if (userAuth.isLoggedIn) {
                final isAdmin = userAuth.userData['isAdmin'] ?? 2;
                if(isAdmin == 1){
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Profile(userData: userAuth.userData), // Pass the userData here
                    ),
                  );
                }
                else{
                  if(isAdmin== 0){
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AdminApp(), // Pass the userData here
                      ),
                    );
                  }
                  else{
                    if(isAdmin== 2){
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignInDemo(), // Pass the userData here
                        ),
                      );
                    }
                  }
                }

              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );
              }
              break;
          }
        },
      ),
    );

  }
  String extractTime(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    // Định dạng lại để lấy ngày, tháng, năm, giờ và phút
    String formattedDateTime = "${dateTime.year.toString().padLeft(4, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
    return formattedDateTime;
  }
}

import 'package:http/http.dart' as http;
class SaveHistorry{
  Future<void> insertHistory(
      String id, String imageUrl, String title) async {
    final uri = Uri.parse('http://172.30.80.1/server/history.php'); // URL to your PHP script
    try {
      final response = await http.post(uri, body: {
        'user_id': id, // Make sure this matches the expected key in your PHP
        'image': imageUrl,
        'title': title,
        'create_at': DateTime.now()
            .toIso8601String(), // Sends the current date and time
      });

      if (response.statusCode == 200) {
        // If the server returns an OK response, print the body
        print('Response data: ${response.body}');
      } else {
        // If the server did not return a 200 OK response,
        // throw an exception.
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending data: $e');
    }
  }

}
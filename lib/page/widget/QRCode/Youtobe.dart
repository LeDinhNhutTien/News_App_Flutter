import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
void main() {
  runApp(const Youtube());
}
class Youtube extends StatefulWidget {
  const Youtube({super.key});

  @override
  State<Youtube> createState() => _Youtube();
}

class _Youtube extends State<Youtube> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 200, 220, 239),
        title: const Text("NEWS APP"),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  // isSearching = true;
                });
              },
              icon: const Icon(Icons.search)),
        ],
      ),
      body: const WebView(
        initialUrl: 'https://www.youtube.com/',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}

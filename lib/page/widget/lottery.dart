import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
void main() {
  runApp(const Lottery());
}
class Lottery extends StatefulWidget {
  const Lottery({super.key});

  @override
  State<Lottery> createState() => _LotteryState();
}

class _LotteryState extends State<Lottery> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 200, 220, 239),
            title: const Text("Kết quả sổ xố"),
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
      initialUrl: 'https://xosohomnay.com.vn/',
      javascriptMode: JavascriptMode.unrestricted,
    ),
    );
  }
}

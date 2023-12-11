
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsWebView extends StatefulWidget {
  final String url;
  const NewsWebView({Key? key, required this.url}) : super(key: key);

  @override
  State<NewsWebView> createState() => _NewsWebViewState();
}

class _NewsWebViewState extends State<NewsWebView> {
  @override
  Widget build(BuildContext context) {
    // Check if the platform is not Windows
    // if (!kIsWeb && (defaultTargetPlatform != TargetPlatform.windows)) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("WebView Screen"),
        ),
        body: WebView(
          initialUrl: widget.url,
          javascriptMode: JavascriptMode.unrestricted,
        ),
      );
    }
    // else {
    //   // Provide an alternative UI for the Windows platform
    //   return Scaffold(
    //     appBar: AppBar(
    //       title: Text("WebView Screen (Not Supported on Windows)"),
    //     ),
    //     body: Center(
    //       child: Text("WebView is not supported on Windows."),
    //     ),
    //   );
    // }
  // }
}


import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomeScreen extends StatelessWidget {

  WebViewController webViewController = WebViewController()
    ..loadRequest(Uri.parse('http://blog.codefactory.ai'))
    ..setJavaScriptMode(JavaScriptMode.unrestricted);

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text("블로그"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              webViewController.loadRequest(Uri.parse('http://blog.codefactory.ai'));
            },
            icon: Icon(Icons.home)
          ),
          IconButton(
              onPressed: () {
                webViewController.goBack();
              },
              icon: Icon(Icons.arrow_back)
          ),
          IconButton(
              onPressed: () {
                webViewController.goForward();
              },
              icon: Icon(Icons.arrow_forward)
          )
        ],
      ),
      body: WebViewWidget(controller: webViewController),
    );
  }
}
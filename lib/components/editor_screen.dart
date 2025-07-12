import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class EditorScreen extends StatefulWidget {
  const EditorScreen({super.key});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  late final WebViewController _controller;
  String _htmlContent = "";

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'TextChannel',
        onMessageReceived: (msg) {
          setState(() {
            _htmlContent = msg.message;
          });
          debugPrint('Received HTML: $_htmlContent');
        },
      )
      ..loadFlutterAsset('assets/editor.html');
  }

  void _submitContent() async {
    final result = await _controller.runJavaScriptReturningResult(
      'getContent()',
    );
    debugPrint('Submitted: \$result');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ask Question')),
      body: Column(
        children: [
          Expanded(child: WebViewWidget(controller: _controller)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _submitContent,
              child: const Text("Submit"),
            ),
          ),
        ],
      ),
    );
  }
}

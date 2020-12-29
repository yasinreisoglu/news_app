import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DetailPage extends StatefulWidget {
  final String url;
  final String title;
  const DetailPage({Key key, @required this.url, @required this.title})
      : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  void initState() {
    print(widget.url);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title,
            style: TextStyle(fontSize: 14),
          ),
          actions: [
            IconButton(
                icon: Icon(Icons.share),
                onPressed: () async {
                  share();
                })
          ],
        ),
        body: WebView(
          initialUrl: widget.url,
          javascriptMode: JavascriptMode.unrestricted,
        ));
  }

  Future<void> share() async {
    await FlutterShare.share(
        title: 'Example share',
        text: widget.title + " ",
        linkUrl: widget.url,
        chooserTitle: 'Example Chooser Title');
  }
}

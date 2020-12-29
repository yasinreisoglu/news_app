import 'package:flutter/material.dart';
import 'package:news_app/detail_page.dart';
import 'package:news_app/settings.dart';
import 'package:webfeed/webfeed.dart';
import 'package:http/http.dart' as http;

class NewsPage extends StatefulWidget {
  NewsPage({Key key}) : super(key: key);

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final TextEditingController _controller = TextEditingController();
  List<RssItem> _news = List<RssItem>();
  List<RssItem> _listNews = List<RssItem>();
  bool isLoading = true;
  FocusNode myFocusNode;

  @override
  void initState() {
    super.initState();
    getNews();
    myFocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    isLoading = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          focusNode: myFocusNode,
          decoration: InputDecoration(
              hintText: "Aramak için yazınız",
              suffixIcon: IconButton(
                icon: Icon(Icons.cancel_rounded),
                onPressed: () {
                  setState(() {
                    _controller.clear();
                    myFocusNode.unfocus();
                  });
                },
              )),
          controller: _controller,
          onChanged: (value) => {
            value = value.toLowerCase(),
            setState(() {
              _listNews = _news.where((element) {
                var title = element.title.toLowerCase();
                return title.contains(value);
              }).toList();
            }),
          },
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings,
            ),
            onPressed: () {
              Navigator.push(context,
                  new MaterialPageRoute(builder: (context) => SettingsPage()));
            },
          ),
        ],
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          myFocusNode.unfocus();
        },
        child: Center(
            child: isLoading
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(
                        height: 25,
                        width: 25,
                      ),
                      Text("Haberler Yükleniyor...")
                    ],
                  )
                : RefreshIndicator(
                    onRefresh: () async {
                      getNews();
                    },
                    child: ListView.builder(
                        itemCount: lengthGive(),
                        itemBuilder: (context, index) {
                          return InkWell(
                            child: Container(
                              height: 150,
                              margin: EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 10.0),
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  image: DecorationImage(
                                    image: NetworkImage(_controller.text.isEmpty
                                        ? _news[index].imageUrl
                                        : _listNews[index].imageUrl),
                                    fit: BoxFit.fitWidth,
                                    alignment: Alignment.topCenter,
                                  )),
                              child: Container(
                                width: double.infinity,
                                margin: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 5.0),
                                decoration: BoxDecoration(
                                    color: Colors.black38,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0))),
                                child: Text(
                                  _controller.text.isEmpty
                                      ? _news[index].title
                                      : _listNews[index].title,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                              ),
                              alignment: Alignment.bottomCenter,
                            ),
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return DetailPage(
                                    url: _controller.text.isEmpty
                                        ? _news[index].link
                                        : _listNews[index].link,
                                    title: _controller.text.isEmpty
                                        ? _news[index].title
                                        : _listNews[index].title,
                                  );
                                },
                              ));
                            },
                          );
                        }),
                  )),
      ),
    );
  }

  Future<void> getNews() async {
    var client = http.Client();
    var response =
        await client.get("https://www.aa.com.tr/tr/rss/default?cat=guncel");
    var channel = RssFeed.parse(response.body);
    _news = channel.items;
    setState(() {
      isLoading = false;
    });
  }

  int lengthGive() {
    _news.forEach((element) {
      if (element.title.contains(_controller.text)) {
        _listNews.add(element);
      }
    });
    return _controller.text.isEmpty ? _news.length : _listNews.length;
  }
}

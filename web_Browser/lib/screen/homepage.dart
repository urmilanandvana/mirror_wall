import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey webKey = GlobalKey();
  InAppWebViewController? inAppWebViewController;
  late PullToRefreshController pullToRefreshController;
  TextEditingController textEditingController = TextEditingController();
  String searchedText = "";
  double progress = 0;

  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(
      useShouldOverrideUrlLoading: true,
      mediaPlaybackRequiresUserGesture: false,
    ),
    android: AndroidInAppWebViewOptions(
      useHybridComposition: true,
    ),
    ios: IOSInAppWebViewOptions(
      allowsInlineMediaPlayback: true,
    ),
  );

  @override
  void initState() {
    super.initState();

    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.blue,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          inAppWebViewController?.reload();
        } else if (Platform.isIOS) {
          inAppWebViewController?.loadUrl(
              urlRequest:
                  URLRequest(url: await inAppWebViewController?.getUrl()));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Web"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              await inAppWebViewController!.reload();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Column(
            children: [
              progress < 1.0
                  ? LinearProgressIndicator(
                      value: progress,
                      color: Colors.blue.withOpacity(0.5),
                    )
                  : Container(),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: textEditingController,
                    onSubmitted: (val) async {
                      searchedText = val;
                      Uri uri = Uri.parse(searchedText);

                      if (uri.scheme.isEmpty) {
                        uri = Uri.parse(
                            "https://www.google.com/search?q=" + searchedText);
                      }
                      await inAppWebViewController!
                          .loadUrl(urlRequest: URLRequest(url: uri));
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                      hintText: "Enter your web address....",
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 12,
                child: InAppWebView(
                  pullToRefreshController: pullToRefreshController,
                  initialOptions: options,
                  key: webKey,
                  initialUrlRequest: URLRequest(
                    url: Uri.parse("https://www.google.co.in"),
                  ),
                  onWebViewCreated: (controller) {
                    inAppWebViewController = controller;
                  },
                  onLoadStop: (controller, url) {
                    setState(() {
                      textEditingController.text = url.toString();
                    });
                  },
                  onProgressChanged: (controller, progress) async {
                    if (progress == 100) {
                      pullToRefreshController.endRefreshing();
                    } else if (await pullToRefreshController.isRefreshing()) {
                      setState(() {
                        showDialog(
                          context: context,
                          // barrierDismissible: false, // user must tap button!
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    pullToRefreshController.endRefreshing();
                                    Navigator.of(context).pop();
                                  });
                                },
                                child: const Text("Cancel"),
                              ),
                            );
                          },
                        );
                      });
                    }

                    setState(() {
                      this.progress = progress / 100;
                      textEditingController.text;
                    });
                  },
                ),
              ),
            ],
          ),
          Container(
            height: 50,
            width: double.infinity,
            color: Colors.blue,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    if (await inAppWebViewController!.canGoBack()) {
                      await inAppWebViewController!.goBack();
                    }
                  },
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(
                    Icons.home,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    await inAppWebViewController!.loadUrl(
                      urlRequest: URLRequest(
                        url: Uri.parse("https://www.google.co.in"),
                      ),
                    );
                  },
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    if (await inAppWebViewController!.canGoForward()) {
                      await inAppWebViewController!.canGoForward();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class JavaPointPAge extends StatefulWidget {
  const JavaPointPAge({Key? key}) : super(key: key);

  @override
  State<JavaPointPAge> createState() => _JavaPointPAgeState();
}

class _JavaPointPAgeState extends State<JavaPointPAge> {
  GlobalKey webKey = GlobalKey();
  TextEditingController textEditingController = TextEditingController();
  InAppWebViewController? inAppWebViewController;

  PullToRefreshController? pullToRefreshController;

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
      ));

  String searchText = "";
  double progress = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xff461200),
        title: const Text("JavaPoint"),
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
                      color: const Color(0xff461200).withOpacity(0.5),
                      backgroundColor: Colors.white,
                      minHeight: 7,
                    )
                  : Container(),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: textEditingController,
                    onSubmitted: (val) async {
                      searchText = val;
                      Uri uri = Uri.parse(searchText);
                      if (uri.scheme.isEmpty) {
                        uri = Uri.parse(
                            "https//www.google.com/search?q=" + searchText);
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
                flex: 16,
                child: InAppWebView(
                  key: webKey,
                  initialOptions: options,
                  pullToRefreshController: pullToRefreshController,
                  initialUrlRequest: URLRequest(
                    url: Uri.parse("https://www.javatpoint.com/"),
                  ),
                  onWebViewCreated: (controller) {
                    inAppWebViewController = controller;
                  },
                  onProgressChanged: (controller, progress) {
                    if (progress == 100) {
                      pullToRefreshController!.endRefreshing();
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
            color: Color(0xff461200),
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
                        url: Uri.parse("https://www.javatpoint.com/"),
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

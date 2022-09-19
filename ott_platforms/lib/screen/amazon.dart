import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class AmazonPage extends StatefulWidget {
  const AmazonPage({Key? key}) : super(key: key);

  @override
  State<AmazonPage> createState() => _AmazonPageState();
}

class _AmazonPageState extends State<AmazonPage> {
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
        backgroundColor: Colors.black,
        title: const Text("Amazon Prime"),
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
                      color: Colors.black.withOpacity(0.5),
                    )
                  : Container(),
              Expanded(
                child: InAppWebView(
                  pullToRefreshController: pullToRefreshController,
                  initialOptions: options,
                  key: webKey,
                  initialUrlRequest: URLRequest(
                    url: Uri.parse(
                        "https://www.primevideo.com/hp/video/offers/nonprimehomepage/ref=dvm_pds_amz_in_as_s_g_146?_encoding=UTF8&dvah=nonprimehomepage"),
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
                      setState(
                        () {
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
                        },
                      );
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
            color: Colors.black,
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
                        url: Uri.parse(
                            "https://www.primevideo.com/hp/video/offers/nonprimehomepage/ref=dvm_pds_amz_in_as_s_g_146?_encoding=UTF8&dvah=nonprimehomepage"),
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

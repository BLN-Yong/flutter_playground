import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_deep_link/deep_link_provider.dart' hide Provider;
import 'package:webview_flutter/webview_flutter.dart';

class DeepLinkEntryPage extends StatefulWidget {
  const DeepLinkEntryPage({super.key});

  @override
  State<DeepLinkEntryPage> createState() => _DeepLinkEntryPageState();
}

class _DeepLinkEntryPageState extends State<DeepLinkEntryPage> {
  @override
  Widget build(BuildContext context) {
    DeepLinkProvider deepLinkStream = Provider.of<DeepLinkProvider>(context);
    return StreamBuilder<DeepLinkData>(
      stream: deepLinkStream.state,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Text(
              "No deep link found",
              style: TextStyle(color: Colors.black),
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Center(
              child: DefaultTextStyle(
                style: TextStyle(color: Colors.black),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(snapshot.data!.page),
                    ...snapshot.data!.params.map((params) => Text(params)),
                    // if (snapshot.data!.params.isNotEmpty)
                    //   Expanded(
                    //     child: WebViewWidget(
                    //       controller: WebViewController()
                    //         ..loadRequest(
                    //           Uri.parse(
                    //             "https://www.airbnb.com/${snapshot.data!.page}/${snapshot.data!.params.join('/')}",
                    //           ),
                    //         ),
                    //     ),
                    //   ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}

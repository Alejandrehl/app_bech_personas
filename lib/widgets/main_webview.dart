import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MainWebview extends StatelessWidget {
  const MainWebview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String url =
        'https://desa-plataformadigital.bancoestado.cl/apps/enrolamiento/welcome';

    return Builder(
      builder: (BuildContext context) {
        return WebView(
          initialUrl: url,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {},
          onProgress: (int progress) {
            print("WebView is loading (progress : $progress%)");
          },
          javascriptChannels: <JavascriptChannel>{},
          navigationDelegate: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              print('blocking navigation to $request}');
              return NavigationDecision.prevent;
            }

            print('allowing navigation to $request');
            return NavigationDecision.navigate;
          },
          onPageStarted: (String url) {
            print('Page started loading: $url');
          },
          onPageFinished: (String url) {
            print('Page finished loading: $url');
          },
          gestureNavigationEnabled: true,
        );
      },
    );
  }
}

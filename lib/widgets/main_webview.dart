import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MainWebview extends StatefulWidget {
  const MainWebview({Key? key}) : super(key: key);

  @override
  _MainWebviewState createState() => _MainWebviewState();
}

class _MainWebviewState extends State<MainWebview> {
  var _controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    String url = 'https://distracted-davinci-a8cf4d.netlify.app/';
    //String url =
    'https://desa-plataformadigital.bancoestado.cl/apps/enrolamiento/welcome';

    void getDeviceInfo() async {
      print('========== DEVICE INFO ==========');
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        print('MODEL: ${androidInfo.model}');
        print('IS PHYSICAL DEVICE: ${androidInfo.isPhysicalDevice}');
        print('ANDROID ID: ${androidInfo.androidId}');
        print('BOARD: ${androidInfo.board}');
        print('BOOTLOADER: ${androidInfo.bootloader}');
        print('BRAND: ${androidInfo.brand}');
        print('DEVICE: ${androidInfo.device}');
        print('DISPLAY: ${androidInfo.display}');
        print('FINGERPRINT: ${androidInfo.fingerprint}');
        print('HARDWARE: ${androidInfo.hardware}');
        print('HOST: ${androidInfo.host}');
        print('ID: ${androidInfo.id}');
        print('MANUFACTURER: ${androidInfo.manufacturer}');
        print('PRODUCT: ${androidInfo.product}');
      } else {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        print('IDENTIFIER FOR VENDOR: ${iosInfo.identifierForVendor}');
        print('IS PHYSICAL DEVICE: ${iosInfo.isPhysicalDevice}');
        print('LOCALIZED MODEL: ${iosInfo.localizedModel}');
        print('MODEL: ${iosInfo.model}');
        print('NAME: ${iosInfo.name}');
        print('SYSTEM NAME: ${iosInfo.systemName}');
        print('SYSTEM VERSION: ${iosInfo.systemVersion}');
        print('MACHINE: ${iosInfo.utsname.machine}');
      }
    }

    return Builder(
      builder: (BuildContext context) {
        return Stack(
          children: <Widget>[
            WebView(
              initialUrl: url,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                _controller = webViewController;
              },
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
                getDeviceInfo();
              },
              onPageFinished: (String url) {
                print('Page finished loading: $url');
                setState(() {
                  isLoading = false;
                });
              },
              gestureNavigationEnabled: true,
            ),
            isLoading ? Center(child: CircularProgressIndicator()) : Stack(),
            FloatingActionButton(
              child: const Icon(Icons.arrow_upward),
              onPressed: () {
                _controller
                    .evaluateJavascript('fromFlutter("From Flutter x2")');
              },
            ),
          ],
        );
      },
    );
  }
}

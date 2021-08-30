import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MainWebview extends StatelessWidget {
  const MainWebview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String url =
        'https://desa-plataformadigital.bancoestado.cl/apps/enrolamiento/welcome';

    void getDeviceInfo() async {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      //AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      //print('Running on ${androidInfo.model}'); // e.g. "Moto G (4)"

      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      print('====== DEVICE INFO ======');
      print('IDENTIFIER FOR VENDOR: ${iosInfo.identifierForVendor}');
      print('IS PHYSICAL DEVICE: ${iosInfo.isPhysicalDevice}');
      print('LOCALIZED MODEL: ${iosInfo.localizedModel}');
      print('MODEL: ${iosInfo.model}');
      print('NAME: ${iosInfo.name}');
      print('SYSTEM NAME: ${iosInfo.systemName}');
      print('SYSTEM VERSION: ${iosInfo.systemVersion}');
      print('MACHINE: ${iosInfo.utsname.machine}');
    }

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
            getDeviceInfo();
          },
          gestureNavigationEnabled: true,
        );
      },
    );
  }
}
